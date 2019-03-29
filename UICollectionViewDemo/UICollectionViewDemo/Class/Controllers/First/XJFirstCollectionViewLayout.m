//
//  XJFirstCollectionViewLayout.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJFirstCollectionViewLayout.h"

#define ITEM_WIDTH         180
#define ITEM_HEIGHT        180

#define ITEM_SCALE         0.3
#define ITEM_SPACING       50

@implementation XJFirstCollectionViewLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.minimumLineSpacing = ITEM_SPACING;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat leftPadding = (CGRectGetWidth(self.collectionView.bounds) - ITEM_WIDTH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(200, leftPadding , 200, leftPadding);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect currentRect;
    currentRect.origin = self.collectionView.contentOffset;
    currentRect.size = self.collectionView.bounds.size;
    
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
