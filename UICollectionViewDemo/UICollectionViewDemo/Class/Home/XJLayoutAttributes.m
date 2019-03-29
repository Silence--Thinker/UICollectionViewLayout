//
//  XJLayoutAttributes.m
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/17.
//  Copyright © 2018年 silence. All rights reserved.
//

#import "XJLayoutAttributes.h"

@implementation XJLayoutAttributes

- (BOOL)isEqualToLayoutAttributes:(XJLayoutAttributes *)attribute {
    if (!attribute) {
        return NO;
    }
    BOOL titleEqual = (!self.title && !attribute.title) || ([self.title isEqualToString:attribute.title]);
    
    BOOL colorEqual = (!self.color && !attribute.color) || ([self.color isEqual:attribute.color]);
    
    return titleEqual && colorEqual;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[XJLayoutAttributes class]]) {
        return NO;
    }
    
    return [self isEqualToLayoutAttributes:(XJLayoutAttributes *)object];
}

- (NSUInteger)hash {
    return [self.title hash] ^ [self.color hash];
}

@end
