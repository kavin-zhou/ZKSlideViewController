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
    [self setupChildViewControllers];
}

- (void)setupChildViewControllers {
    NSArray <NSString *> *titles = @[
                                     @"热门",
                                     @"最新电视剧",
                                     @"我",
                                     @"关于北京的那些事",
                                     @"自选",
                                     @"最热商品"
                                     ];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [UIViewController new];
        vc.title = obj;
        vc.view.backgroundColor = ZKRandomColor;
        [self addChildViewController:vc];
    }];
}

@end
