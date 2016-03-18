//
//  CircleLayout.h
//  Demo-CircleLayout
//
//  Created by Silence on 16/3/17.
//  Copyright © 2016年 silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
