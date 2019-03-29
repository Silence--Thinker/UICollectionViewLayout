//
//  XJSecondCollectionViewLayout.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJSecondCollectionViewLayout.h"

#define ITEM_WIDTH              100
#define ITEM_HEIGHT             100

@interface XJSecondCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

@implementation XJSecondCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    self.center = CGPointMake(size.width * 0.5, (size.height - 64) * 0.5 );
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.radius = (MIN(size.width, size.height) - ITEM_WIDTH - 10) / 2;
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    
    attribute.center = CGPointMake(_center.x + _radius * cos(indexPath.item * M_PI * 2 /_cellCount),
                                   _center.y + _radius * sin(indexPath.item * M_PI * 2 /_cellCount));
    attribute.zIndex = indexPath.item;
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0 ; i < _cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return array;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
            
        }else if (update.updateAction == UICollectionUpdateActionInsert) {
            
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    //  释放insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        // 只改变插入的 attributes
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // configure attributes...
        attributes.alpha = 0;
        attributes.center = _center;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    return attributes;
}

// For each element on screen after the invalidation,
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0;
        attributes.center = _center;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    return attributes;
}

@end

