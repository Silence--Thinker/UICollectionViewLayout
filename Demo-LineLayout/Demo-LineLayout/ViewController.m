//
//  ViewController.m
//  Demo-LineLayout
//
//  Created by Silence on 16/3/16.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "ViewController.h"
#import "LineCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[LineCell class] forCellWithReuseIdentifier:@"LineCell"];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LineCell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

@end
