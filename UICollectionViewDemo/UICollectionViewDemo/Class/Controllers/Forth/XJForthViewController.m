//
//  XJForthViewController.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJForthViewController.h"

#import "XJCollectionViewCell.h"
#import "XJForthCollectionViewLayout.h"

@interface XJForthViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation XJForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[XJCollectionViewCell class] forCellWithReuseIdentifier:@"XJCollectionViewCell"];
}

// MARK - collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 3;
    cell.contentView.layer.borderColor = [UIColor redColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.contentView.backgroundColor = [self.dataList[indexPath.item] objectForKey:@"color"];
    cell.label.text = [self.dataList[indexPath.item] objectForKey:@"title"];
    
    [cell.contentView setNeedsLayout];
    
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        XJForthCollectionViewLayout *layout = [[XJForthCollectionViewLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < 40; i++) {
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
