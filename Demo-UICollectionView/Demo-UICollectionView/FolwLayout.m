//
//  FolwLayout.m
//  Demo-UICollectionView
//
//  Created by Silence on 16/3/21.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "FolwLayout.h"
#import "DecorationView.h"

#define ITEM_WIDTH          50
#define ITEM_HEIGHT         50

@implementation FolwLayout
- (instancetype)init {
    if (self = [super init]) {
        [self registerClass:[DecorationView class] forDecorationViewOfKind:@"DecorationView"];
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    self.minimumLineSpacing = 20.0f;
    self.minimumInteritemSpacing = 20.0f;
    self.sectionInset = UIEdgeInsetsMake(30, 15, 20, 15);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.headerReferenceSize = CGSizeMake(20, 30);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arrayM = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    NSInteger count = arrayM.count;
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = [arrayM objectAtIndex:i];
        if (att.representedElementCategory == UICollectionElementCategoryCell) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"DecorationView" atIndexPath:att.indexPath];
            attributes.size = CGSizeMake(60, 60);
            attributes.center = att.center;
            if (att.indexPath.item == 9) {
                CGSize size = self.collectionView.bounds.size;
                attributes.frame = CGRectMake(0, att.center.y - 20, size.width, 40);
            }
            [arrayM addObject:attributes];
        }
        att.zIndex = 3;
    }
    return arrayM.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.size = CGSizeMake(55, 55);
    attributes.center = CGPointMake(0, 0);
    attributes.zIndex = 1;
    return attributes;
}

@end
