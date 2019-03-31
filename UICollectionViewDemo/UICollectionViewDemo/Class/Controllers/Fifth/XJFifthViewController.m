//
//  XJFifthViewController.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2019/3/29.
//  Copyright © 2019年 silence. All rights reserved.
//

#import "XJFifthViewController.h"

#import "XJCollectionViewCell.h"
#import "XJCollectionHeaderView.h"

#import "RETEditionRightListLayout.h"

@interface XJFifthViewController () <UICollectionViewDelegate, UICollectionViewDataSource, RETEditionRightListLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation XJFifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
//    self.collectionView.frame = self.view.bounds;
    
    [self.collectionView registerClass:[XJCollectionViewCell class] forCellWithReuseIdentifier:@"XJCollectionViewCell"];
    [self.collectionView registerClass:[XJCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerClass:[XJCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

// MARK - collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 200);
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(300, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(200, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = @"HeaderView";
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        string = @"FooterView";
    }
    XJCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:string forIndexPath:indexPath];
    header.label.text = [NSString stringWithFormat:@"This is %@ ==%zd section",string, indexPath.section];
    header.backgroundColor =  indexPath.section == 0 ? [UIColor yellowColor] : [UIColor redColor];
    return header;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        RETEditionRightListLayout *layout = [[RETEditionRightListLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (CGFloat)layout:(RETEditionRightListLayout *)layout sectionHeaderHeight:(NSInteger)section
{
    return 60;
}

- (CGFloat)layout:(RETEditionRightListLayout *)layout sectionFooterHeight:(NSInteger)section
{
    return 30;
}

- (void)layout:(RETEditionRightListLayout *)layout section:(NSInteger)section
{
    NSLog(@"============================section==%zd", section);
}


- (NSArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
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
