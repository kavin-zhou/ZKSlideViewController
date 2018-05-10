//
//  ZKWeiboHeaderView.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import "ZKWeiboHeaderView.h"

@implementation ZKWeiboHeaderView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_canNotResponseTapTouchEvent) {
        return NO;
    }
    
    return [super pointInside:point withEvent:event];
}
- (IBAction)btnClick:(id)sender {
    NSLog(@"=============");
}

@end
