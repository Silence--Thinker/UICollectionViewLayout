//
//  ViewController.m
//  Demo-CircleLayout
//
//  Created by Silence on 16/3/17.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "ViewController.h"
#import "CricleCell.h"

static NSString * const kCricleCell = @"CricleCell";
@interface ViewController ()

@property (nonatomic, assign) NSInteger cellCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellCount = 10;
    [self.collectionView registerClass:[CricleCell class] forCellWithReuseIdentifier:kCricleCell];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.collectionView addGestureRecognizer:tap];
    
    self.collectionView.backgroundColor = [UIColor grayColor];
}



#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CricleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCricleCell forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [sender locationInView:self.collectionView];
        NSIndexPath *pinchIndexPath = [self.collectionView indexPathForItemAtPoint:endPoint];
        if (pinchIndexPath != nil) {
            // 变动数据源
            self.cellCount = self.cellCount - 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[pinchIndexPath]];
            } completion:nil];
            [self.collectionView reloadData];
        }else {
            self.cellCount = self.cellCount + 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            } completion:^(BOOL finished) {
//                NSLog(@"%s", __func__);
            }];
        
        }
    }
}



@end
