//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation ViewController

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

// MARK - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.dataList[indexPath.row] objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *classStr = [self.dataList[indexPath.row] objectForKey:@"viewcontroller"];
    NSString *title = [self.dataList[indexPath.row] objectForKey:@"title"];
    UIViewController *vc = [NSClassFromString(classStr) new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *titleArray = @[@"线性collecView布局", @"圆形collectionView布局", @"瀑布流collectionView布局", @"collectionView布局一览"];
        NSArray *controllerArray = @[@"XJFirstViewController", @"XJSecondViewController", @"XJThirdViewController", @"XJForthViewController"];
        for (NSInteger i = 0; i < titleArray.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"title"] = titleArray[i];
            dict[@"viewcontroller"] = controllerArray[i];
            [arrayM addObject:dict];
        }
        _dataList = arrayM;
    }
    return _dataList;
}

@end
