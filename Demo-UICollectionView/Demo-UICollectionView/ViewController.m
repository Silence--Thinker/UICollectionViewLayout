//
//  ViewController.m
//  Demo-UICollectionView
//
//  Created by Silence on 16/3/21.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "SupplementaryView.h"

@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[SupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryView"];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    SupplementaryView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryView" forIndexPath:indexPath];
    supplementaryView.label.text = @"SupplementaryView";
    supplementaryView.backgroundColor = [UIColor orangeColor];
    return supplementaryView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

@end
