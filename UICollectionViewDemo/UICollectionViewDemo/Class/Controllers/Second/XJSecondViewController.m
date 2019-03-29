//
//  XJSecondViewController.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJSecondViewController.h"

#import "XJCollectionViewCell.h"
#import "XJSecondCollectionViewLayout.h"

@interface XJSecondViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation XJSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[XJCollectionViewCell class] forCellWithReuseIdentifier:@"XJCollectionViewCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.collectionView addGestureRecognizer:tap];
}

// MARK - collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 50;
    cell.contentView.layer.borderColor = [UIColor redColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.contentView.backgroundColor = [self.dataList[indexPath.item] objectForKey:@"color"];
    cell.label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    [cell.contentView setNeedsLayout];
    
    return cell;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [sender locationInView:self.collectionView];
        NSIndexPath *pinchIndexPath = [self.collectionView indexPathForItemAtPoint:endPoint];
        
        if (pinchIndexPath != nil) {
            // 变动数据源
            [self.dataList removeLastObject];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[pinchIndexPath]];
            } completion:^(BOOL finished) {
                [self.collectionView reloadData];
            }];
            
        }else {
            
            [self.dataList addObject:self.dataList.lastObject];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            } completion:^(BOOL finished) {
                [self.collectionView reloadData];
            }];
        }
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        XJSecondCollectionViewLayout *layout = [[XJSecondCollectionViewLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"color"] = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:0.8];
            [arrayM addObject:dict];
        }
        _dataList = arrayM;
    }
    return _dataList;
}

@end
