//
//  CircleLayout.m
//  Demo-CircleLayout
//
//  Created by Silence on 16/3/17.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "CircleLayout.h"

#define ITEM_WIDTH              80
#define ITEM_HEIGHT             80

@interface CircleLayout ()
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end
@implementation CircleLayout


#pragma mark - 关于初始化布局的东西，这些方法给出了一个完整的collectionView的布局
/*
    相关布局的方法定义在 UICollectionViewLayout (UISubclassingHooks) 这个扩展中
 */
- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    self.center = CGPointMake(size.width * 0.5, size.height * 0.5);
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.radius = MIN(size.width, size.height) / 2 - ITEM_WIDTH;
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    
    attribute.center = CGPointMake(_center.x + _radius * cos(indexPath.item * M_PI * 2 /_cellCount),
                                   _center.y + _radius * sin(indexPath.item * M_PI * 2 /_cellCount));
    attribute.zIndex = 1;
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

#pragma mark - 下面的方法关系到单个item 被删除或者增加的动画
/*
    相关的更新视图的方法定义在 UICollectionViewLayout (UIUpdateSupportHooks) 这个扩展中
 */

// 在insert或者delete之前，prepareForCollectionViewUpdates:会调用，可以使用这个方法来完成 添加/ 删除的布局
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

// 更新结束后调用 这个方法在 performBatchUpdates:completion: complete的Block之前调用
- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    //  释放insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}


/**
    这两个方法是成对出现的，一个是在在屏幕上失效之前调用，一个是在屏幕上失效之后调用，
    在[collecView reloadData]或者performBatchUpdates:completion:调用的时候
    只要是有刷新的效果，他们就会被调用多次，视图不断的消失（失效，被摧毁）出现（重组 被创建或者回收利用）
 */
// For each element on screen before the invalidation,
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    NSLog(@"%zd===%@", itemIndexPath.row, attributes);
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
