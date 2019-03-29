//
//  XJForthCollectionViewLayout.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJForthCollectionViewLayout.h"

#import "XJDecorationView.h"
#import "XJLayoutAttributes.h"

#define ITEM_WIDTH          [UIScreen mainScreen].bounds.size.width - 100
#define ITEM_HEIGHT         200

@interface XJForthCollectionViewLayout ()

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation XJForthCollectionViewLayout

- (instancetype)init {
    if (self = [super init]) {
        [self registerClass:[XJDecorationView class] forDecorationViewOfKind:@"XJDecorationView"];
    }
    return self;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        
        // cell
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [arrayM addObject:att];
        
        // decorationView
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"XJDecorationView" atIndexPath:att.indexPath];
        attributes.size = CGSizeMake(40, 40);
        attributes.frame = CGRectMake(10, att.center.y - 20, 40, 40);
        [arrayM addObject:attributes];
        att.zIndex = 3;
    }
    return arrayM.copy;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger index = indexPath.item;
    
    attribute.frame = CGRectMake(60, index * ITEM_HEIGHT + index * 15 + 10, ITEM_WIDTH, ITEM_HEIGHT);
    attribute.zIndex = 1;
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    XJLayoutAttributes *attributes = [XJLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.title = [NSString stringWithFormat:@"%zd", indexPath.item];
    attributes.color = [self.dataList[indexPath.item] objectForKey:@"color"];
    attributes.zIndex = 1;
    return attributes;
}

- (NSArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < 100; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"color"] = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:0.8];
            dict[@"title"] = [NSString stringWithFormat:@"%zd", i];
            [arrayM addObject:dict];
        }
        _dataList = arrayM;
    }
    return _dataList;
}

@end
