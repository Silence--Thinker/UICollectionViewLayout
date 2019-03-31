//
//  XJCollectionHeaderView.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2019/3/29.
//  Copyright © 2019年 silence. All rights reserved.
//

#import "XJCollectionHeaderView.h"

@implementation XJCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0];
        self.label = label;
        [self addSubview:label];
    }
    return self;
}

@end
