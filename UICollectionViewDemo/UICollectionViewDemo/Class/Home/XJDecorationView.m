//
//  XJDecorationView.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/17.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJDecorationView.h"

#import "XJLayoutAttributes.h"

@implementation XJDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0];
        self.label = label;
        [self addSubview:label];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    XJLayoutAttributes *attribute = (XJLayoutAttributes *)layoutAttributes;
    self.label.text = attribute.title;
    self.label.backgroundColor = attribute.color;
}

@end
