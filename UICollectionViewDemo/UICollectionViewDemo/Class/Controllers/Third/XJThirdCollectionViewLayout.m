//
//  XJThirdCollectionViewLayout.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJThirdCollectionViewLayout.h"

@interface XJThirdCollectionViewLayout ()

@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, strong) NSMutableArray *attributeArray;
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

@property (nonatomic, strong) NSMutableDictionary *headerMinY;
@property (nonatomic, strong) NSMutableDictionary *footerMixY;

@end

@implementation XJThirdCollectionViewLayout

// MARK: - 预加载

- (NSMutableArray *)attributeArray {
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

- (NSMutableDictionary *)maxYDict {
    if (!_maxYDict) {
        _maxYDict = [NSMutableDictionary dictionary];
    }
    return _maxYDict;
}

- (NSMutableDictionary *)headerMinY {
    if (!_headerMinY) {
        _headerMinY = [NSMutableDictionary dictionary];
    }
    return _headerMinY;
}

- (NSMutableDictionary *)footerMixY {
    if (!_footerMixY) {
        _footerMixY = [NSMutableDictionary dictionary];
    }
    return _footerMixY;
}

- (instancetype)init {
    if (self = [super init]) {
        self.firstY = 0;
        self.rowMargin = 10;
        self.columnMargin = 15;
        self.columnCount = 2;
        self.itemSize = CGSizeMake(40, 40);
        self.sectionHeaderSize = CGSizeZero;
        self.sectionFooterSize = CGSizeZero;
        self.sectionInsets = UIEdgeInsetsZero;
        self.specialSection = NSIntegerMax;
    }
    return self;
}

// MARK: - 布局

- (void)prepareLayout {
    [super prepareLayout];
    
    // 初始化一些值
    [self xj_initialzeLayoutVariablesValu];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        // headerSize
        if ([self delegateSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            _sectionHeaderSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
            if (CGSizeEqualToSize(_sectionHeaderSize, CGSizeZero) == false) {
                UICollectionViewLayoutAttributes *header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [self.attributeArray addObject:header];
            }
        }
        
        for (NSInteger item = 0 ; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributeArray addObject:attribute];
        }
        if (itemCount == 0) { // 更新header Y值
            [self.headerMinY setObject:@(_firstY) forKey:@(section + 1)];
            [self.footerMixY setObject:@(_firstY) forKey:@(section)];
        }
        
        // footerSize
        if ([self delegateSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            _sectionFooterSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
            if (CGSizeEqualToSize(_sectionFooterSize, CGSizeZero) == false) {
                UICollectionViewLayoutAttributes *footer = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [self.attributeArray addObject:footer];
            }
        }
    }
}

- (void)xj_initialzeLayoutVariablesValu {
    _firstY = 0;
    self.itemSize = CGSizeMake(40, 40);
    [self.attributeArray removeAllObjects];
    self.sectionHeaderSize = CGSizeZero;
    self.sectionFooterSize = CGSizeZero;
    self.sectionInsets = UIEdgeInsetsZero;
}

- (void)cleanMaxYDict {
    for (NSInteger i = 0; i < self.columnCount; i++) {
        self.maxYDict[@(i)] = @(self.firstY);
    }
}

- (CGSize)collectionViewContentSize {
    __block NSNumber *maxColumn = @0;
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj doubleValue] > [self.maxYDict[maxColumn] doubleValue]) {
            maxColumn = key;
        }
    }];
    CGFloat height = [self.maxYDict[maxColumn] doubleValue];
    if (height <= _firstY) {
        height = _firstY;
    }
    return CGSizeMake(0, height + _sectionFooterSize.height + _sectionInsets.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemX = 0, itemY = 0, width = 0, height = 0;
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    
    // itemSize
    if ([self delegateSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        _itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    width = _itemSize.width;
    height = _itemSize.height;
    
    // sectionInsets
    if ([self delegateSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        _sectionInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    if (item == 0) {
        [self.headerMinY setObject:@(_firstY) forKey:@(section)];
        _firstY += _sectionHeaderSize.height + _sectionInsets.top;
    }
    
    // 是否是一个瀑布流section
    if (section != self.specialSection) {
        itemX = _sectionInsets.left;
        itemY = _firstY;
        
        [self.footerMixY setObject:@(_firstY + _itemSize.height) forKey:@(section)];
        _firstY += (_sectionFooterSize.height + _itemSize.height);
        if (item == itemCount - 1) {
            [self.headerMinY setObject:@(_firstY) forKey:@(section + 1)];
        }
        attribute.frame = CGRectMake(itemX, itemY, width, height);
        return attribute;
    }
    
    if (item == 0) {
        [self cleanMaxYDict];
    }
    // 默认第一列Y值小
    __block NSNumber *minColumn = @0;
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj doubleValue] < [self.maxYDict[minColumn] doubleValue]) {
            minColumn = key;
        }
    }];
    
    NSInteger minNum = [minColumn integerValue];
    // 位置
    CGFloat temp = (item == 0 || item == 1) ? 0 : self.rowMargin;
    itemX = (width + self.columnMargin) * minNum + _sectionInsets.left;
    itemY = [self.maxYDict[minColumn] doubleValue] + temp;
    
    // 更新列Y值
    self.maxYDict[minColumn] = @(itemY + height);
    [self.footerMixY setObject:@(itemY + height) forKey:@(section)];
    
    attribute.frame = CGRectMake(itemX, itemY, width, height);
    return attribute;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute;
    attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    NSInteger section = indexPath.section;
    CGFloat viewY = 0;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        viewY = [[self.headerMinY objectForKey:@(section)] doubleValue];
        attribute.frame = CGRectMake(0, viewY, self.collectionView.frame.size.width, _sectionHeaderSize.height);
    }else {
        viewY = [[self.footerMixY objectForKey:@(section)] doubleValue];
        attribute.frame = CGRectMake(0, viewY, self.collectionView.frame.size.width, _sectionFooterSize.height);
    }
    return attribute;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributeArray;
}

/*
 * delegate 是否可以响应
 */
- (BOOL)delegateSelector:(SEL)selector  {
    if ([self.delegate respondsToSelector:selector]) {
        return YES;
    }
    return NO;
}

@end
