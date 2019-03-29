//
//  XJCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJCollectionViewCell.h"

@implementation XJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0];
        self.label = label;
        [self.contentView addSubview:label];
    }
    return self;
}

@end
