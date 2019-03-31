//
//  RETEditionRightListLayout.m
//  RETBCategoryList
//
//  Created by 曹秀锦 on 2019/3/29.
//

#import "RETEditionRightListLayout.h"

@interface RETEditionRightListLayout ()

@property (nonatomic, copy) BOOL(^alwaysHeaderTop)(NSInteger section);

@end

@implementation RETEditionRightListLayout
{
    NSMutableArray<NSDictionary *> *_sectionOffsetYArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        _sectionHeaderHeightDict = @{ @(0) : @(60),
                                      @(1) : @(60),
                                      @(2) : @(60),
                                      @(3) : @(60),
                                      @(4) : @(60)}.mutableCopy;
        _sectionFooterHeightDict = @{ @(0) : @(30),
                                      @(1) : @(30),
                                      @(2) : @(30),
                                      @(3) : @(30),
                                      @(4) : @(30)}.mutableCopy;
        _alwaysTopHeaderArray = [NSMutableArray array];
        self.alwaysHeaderTop = ^BOOL(NSInteger section) {
            return (section == 0 ) ? YES : NO;
        };
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat rowHeight = 200;    //self.itemSize.height;
    CGFloat height = 0;
    _sectionOffsetYArray = [NSMutableArray array];
    _alwaysTopHeaderArray = [NSMutableArray array];
    NSInteger section = [self.collectionView numberOfSections];
    CGFloat alwaysHeight = 0;
    for (NSInteger i = 0; i < section; i++) {
        CGFloat headerHeight = [self.sectionHeaderHeightDict[@(i)] doubleValue];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"section"] = @(i);
        dict[@"header"] = @(height);
        if (headerHeight > 0) {
            height += headerHeight;
        }
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        height += (rowCount * rowHeight);
        
        CGFloat footerHeight = [self.sectionFooterHeightDict[@(i)] doubleValue];
        if (footerHeight > 0) {
            height += footerHeight;
        }
        BOOL always = self.alwaysHeaderTop(i);
        if (always) {
            height -= headerHeight;
            [_alwaysTopHeaderArray addObject:@(i)];
        }
        dict[@"footer"] = @(height);
        [_sectionOffsetYArray addObject:dict];
        alwaysHeight = always ? headerHeight : 0;
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
    }
    UICollectionViewLayoutAttributes *currentHeaderAttribute = [self exitSectionHeader:currentSection inArray:array];
    
    // 总悬浮
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
        NSLog(@"======================没有section");
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
