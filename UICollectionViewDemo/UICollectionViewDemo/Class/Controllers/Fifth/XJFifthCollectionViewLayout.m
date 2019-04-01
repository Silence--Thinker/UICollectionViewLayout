//
//  XJFifthCollectionViewLayout.m
//  RETBCategoryList
//
//  Created by 曹秀锦 on 2019/3/29.
//

#import "XJFifthCollectionViewLayout.h"

@interface XJFifthCollectionViewLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *sectionFooterHeightDict;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *alwaysTopHeaderArray;

@property (nonatomic, assign) NSInteger now_section;

@end

@implementation XJFifthCollectionViewLayout
{
    NSMutableArray<NSDictionary *> *_sectionOffsetYArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        _now_section = NSNotFound;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat rowHeight = 200;    //self.itemSize.height;
    CGFloat totalHeight = 0;
    _sectionOffsetYArray = [NSMutableArray array];
    _alwaysTopHeaderArray = [NSMutableArray array];
    _sectionFooterHeightDict = [NSMutableDictionary dictionary];
    _sectionHeaderHeightDict = [NSMutableDictionary dictionary];
    
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < section; i++) {
        BOOL always = self.alwaysHeaderTop ? self.alwaysHeaderTop(i) : NO;
        CGFloat headerHeight = 0;
        CGFloat footerHeight = 0;
        if ([self.delegate respondsToSelector:@selector(layout:sectionHeaderHeight:)]) {
            headerHeight = [self.delegate layout:self sectionHeaderHeight:i];
        } else{
            headerHeight = self.sectionHeaderHeight ? self.sectionHeaderHeight(i) : 0;
        }
        _sectionHeaderHeightDict[@(i)] = @(headerHeight);
        
        if ([self.delegate respondsToSelector:@selector(layout:sectionFooterHeight:)]) {
            footerHeight = [self.delegate layout:self sectionFooterHeight:i];
        }else{
            footerHeight = self.sectionFooterHeight ? self.sectionFooterHeight(i) : 0;
        }
        _sectionFooterHeightDict[@(i)] = @(footerHeight);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"section"] = @(i);
        dict[@"header"] = @(totalHeight);
        if (headerHeight > 0) {
            totalHeight += headerHeight;
        }
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        totalHeight += (rowCount * rowHeight);
        
        if (footerHeight > 0) {
            totalHeight += footerHeight;
        }
        
        if (always) {
            totalHeight -= headerHeight;
            [_alwaysTopHeaderArray addObject:@(i)];
        }
        dict[@"footer"] = @(totalHeight);
        [_sectionOffsetYArray addObject:dict];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    
    CGRect currentRect;
    currentRect.origin = self.collectionView.contentOffset;
    currentRect.size = self.collectionView.bounds.size;
    
    NSInteger section = [self.collectionView numberOfSections];
    CGFloat currentOffset = currentRect.origin.y;
    
    __block NSInteger currentSection = NSNotFound;
    [_sectionOffsetYArray enumerateObjectsUsingBlock:^(NSDictionary *offset_value, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat header = [offset_value[@"header"] doubleValue];
        CGFloat footer = 0;
        footer = (idx == section -1) ? CGFLOAT_MAX : [offset_value[@"footer"] doubleValue];
        if (currentOffset >= header && currentOffset < footer && header != footer) {
            currentSection = [offset_value[@"section"] integerValue];
            *stop = YES;
        }
    }];
    
    // currentHeaderAttribute
    CGFloat currentHeaderHeight = 0;
    if (currentSection != NSNotFound) {
        currentHeaderHeight = [_sectionHeaderHeightDict[@(currentSection)] doubleValue];
        if ([self.delegate respondsToSelector:@selector(layout:section:)] && _now_section != currentSection) {
            [self.delegate layout:self section:currentSection];
        }
        _now_section = currentSection;
    }
    UICollectionViewLayoutAttributes *currentHeaderAttribute = [self exitSectionHeader:currentSection inArray:array];
    
    // 总是悬浮的header
    NSArray<NSNumber *> *minArray = [self findNeedTopHeader:currentSection];
    __block CGFloat temp_height = currentOffset;
    __block BOOL isCurrentAlwaysTop = NO;
    [minArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger temp_section = [obj integerValue];
        if (temp_section >= 0 && temp_section < currentSection && temp_section != currentSection) {
            
            UICollectionViewLayoutAttributes *headerAttribute = [self exitSectionHeader:temp_section inArray:array];
            if (headerAttribute == nil) {
                headerAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:temp_section]];
            }
            CGFloat headerHeight = [self->_sectionHeaderHeightDict[@(temp_section)] doubleValue];
            headerAttribute.frame = CGRectMake(0, temp_height, currentRect.size.width, headerHeight);
            headerAttribute.zIndex = 200;
            [array addObject:headerAttribute];
            
            temp_height += headerHeight;
        }
        if (temp_section == currentSection) {
            isCurrentAlwaysTop = YES;
        }
    }];
    
    // 当前sectionHeader位置
    CGFloat headerOffsetY = temp_height;
    if (currentSection != NSNotFound ) {
        if (isCurrentAlwaysTop) {
            headerOffsetY = temp_height;
        } else{
            NSDictionary *dict = _sectionOffsetYArray[currentSection];
            CGFloat footer = [dict[@"footer"] doubleValue];
            if (footer - currentOffset > 0 && footer - currentOffset <= currentHeaderHeight) {
                headerOffsetY = temp_height - currentHeaderHeight + footer - currentOffset;
            }
        }
    }
    
    if (currentHeaderAttribute) {
        currentHeaderAttribute.frame = CGRectMake(0, headerOffsetY, currentRect.size.width, currentHeaderHeight);
        currentHeaderAttribute.zIndex = 100;
    }
    if (currentHeaderAttribute == nil && currentSection != NSNotFound && [self.sectionHeaderHeightDict[@(currentSection)] doubleValue]) {
        //        NSLog(@"======================没有section");
        UICollectionViewLayoutAttributes *headerAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentSection]];
        headerAttribute.frame = CGRectMake(0, headerOffsetY, currentRect.size.width, currentHeaderHeight);
        headerAttribute.zIndex = 100;
        [array addObject:headerAttribute];
    }
    
    return array;
}

- (NSArray *)findNeedTopHeader:(NSInteger)currentSection
{
    if (currentSection == NSNotFound || currentSection < 0) {
        return nil;
    }
    NSMutableArray *minArray = [NSMutableArray array];
    [self.alwaysTopHeaderArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] <= currentSection) {
            [minArray addObject:obj];
        }
    }];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [minArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    return minArray;
}

- (UICollectionViewLayoutAttributes *)exitSectionHeader:(NSInteger)section inArray:(NSArray<UICollectionViewLayoutAttributes *> *)array
{
    UICollectionViewLayoutAttributes *headerAttribute = nil;
    for (UICollectionViewLayoutAttributes *attribute in array) {
        if (attribute.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            if ([attribute.representedElementKind isEqualToString: UICollectionElementKindSectionHeader]) {
                if (attribute.indexPath.section == section) {
                    headerAttribute = attribute;
                }
            }
        }
    }
    return headerAttribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    return attribute;
}

@end
