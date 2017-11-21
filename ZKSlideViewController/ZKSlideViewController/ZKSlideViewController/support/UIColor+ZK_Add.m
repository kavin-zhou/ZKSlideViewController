//
//  UIColor+ZK_Add.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2017/11/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "UIColor+ZK_Add.h"

@implementation UIColor (ZK_Add)

- (CGFloat)zk_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)zk_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)zk_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)zk_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
