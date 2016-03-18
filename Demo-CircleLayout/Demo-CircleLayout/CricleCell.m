//
//  CricleCell.m
//  Demo-CircleLayout
//
//  Created by Silence on 16/3/17.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "CricleCell.h"

@implementation CricleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0];
        self.contentView.layer.cornerRadius = frame.size.width/ 2;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.layer.borderWidth = 2.0f;
        self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
        
        self.label = label;
        [self.contentView addSubview:label];
    }
    return self;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}
@end
