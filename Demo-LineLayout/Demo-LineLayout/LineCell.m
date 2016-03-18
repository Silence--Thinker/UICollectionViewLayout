//
//  LineCell.m
//  Demo-LineLayout
//
//  Created by Silence on 16/3/16.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "LineCell.h"

@implementation LineCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.font = [UIFont systemFontOfSize:40];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor underPageBackgroundColor];
        [self.contentView addSubview:label];
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.layer.borderWidth = 2.0f;
        
        self.label = label;
    }
    return self;
}

@end
