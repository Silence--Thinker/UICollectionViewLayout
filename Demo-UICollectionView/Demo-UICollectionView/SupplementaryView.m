//
//  SupplementaryView.m
//  Demo-UICollectionView
//
//  Created by Silence on 16/3/21.
//  Copyright © 2016年 silence. All rights reserved.
//

#import "SupplementaryView.h"

@implementation SupplementaryView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor underPageBackgroundColor];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}
@end
