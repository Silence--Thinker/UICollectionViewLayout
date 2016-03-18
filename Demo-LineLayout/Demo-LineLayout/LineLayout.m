//
//  LineLayout.m
//  Demo-LineLayout
//
//  Created by Silence on 16/3/16.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "LineLayout.h"

#define ITEM_WIDTH         180
#define ITEM_HEIGHT        180

#define ITEM_SCALE         0.3
#define ITEM_SPACING       50

@implementation LineLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.minimumLineSpacing = ITEM_SPACING;
    }
    return self;
}

// 布局初始化一般在这里进行
- (void)prepareLayout {
    [super prepareLayout];
    CGFloat leftPadding = (CGRectGetWidth(self.collectionView.bounds) - ITEM_WIDTH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(200, leftPadding , 200, leftPadding);
}

//- (CGSize)collectionViewContentSize {
//    CGSize size = [super collectionViewContentSize];
//     CGFloat leftPadding = (CGRectGetWidth(self.collectionView.bounds) - ITEM_WIDTH) * 0.5;
//    return CGSizeMake(size.width + leftPadding , size.height);
//}

// 每当collectionView边界改变时便调用这个方法询问 是否 重新初始化布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/*
 cell 的中心点距离 为 0时时1.3
 距离 为cell的宽度 + 50 的时候是1
 距离50 相差1 + 0.3
 距离25 相差1 + (0.3 * (25 / 50))
 */

// 初始化布局是调用，返回在一定区域内，每个cell和Supplementary和Decoration的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
//    NSLog(@"%@ %@",NSStringFromCGPoint(self.collectionView.contentOffset) ,NSStringFromCGRect(rect));
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 当前collectionView 在屏幕位置的位置
    CGRect currentRect;
    currentRect.origin = self.collectionView.contentOffset;
    currentRect.size = self.collectionView.bounds.size;
    
    // 寻找离中心点最近的cell变大，比例为0.3
    CGFloat center = CGRectGetMidX(currentRect);
    
    for (UICollectionViewLayoutAttributes *attribute in array) {
        // cell距离中心的距离
        if (CGRectIntersectsRect(attribute.frame, currentRect)) {
            CGFloat distance = center - attribute.center.x;
            
            if (ABS(distance) < ITEM_SPACING + ITEM_WIDTH) {
                CGFloat scale = distance / (ITEM_SPACING + ITEM_WIDTH);
                CGFloat zoom = 1 + ITEM_SCALE * (1 - ABS(scale));
                attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
                attribute.zIndex = 1;
            }
        }
    }
    return array;
}

// 当滚动停止时，会调用该方法确定collectionView滚动到的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 寻找到最接近中心点的cell
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes *attribute in array) {
        CGFloat distance = attribute.center.x - horizontalCenter;
        if (ABS(distance) < ABS(offsetAdjustment)) {
            offsetAdjustment = distance;
        }
    }
    CGFloat offsetX = proposedContentOffset.x + offsetAdjustment;
    return CGPointMake(offsetX, proposedContentOffset.y);
}
@end
