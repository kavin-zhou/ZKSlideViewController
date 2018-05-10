//
//  ViewController.m
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "ZKSlideHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.indicatorStyle = ZKSlideIndicatorStyleStickiness;
    [self setupChildViewControllers];
    self.titleColorNormal = [UIColor darkGrayColor];
    self.titleColorHighlight = [UIColor redColor];
}

- (void)setupChildViewControllers {
    NSArray <NSString *> *titles = @[
                                     @"热门",
                                     @"最新电视剧",
                                     @"我",
                                     ];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [UIViewController new];
        vc.title = obj;
        vc.view.backgroundColor = ZKRandomColor;
        [self addChildViewController:vc];
    }];
}

@end
