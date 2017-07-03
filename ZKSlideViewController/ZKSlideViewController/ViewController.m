//
//  ViewController.m
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "ZKHotViewController.h"
#import "ZKListViewController.h"
#import "ZKVideoViewController.h"
#import "ZKHeadViewController.h"
#import "ZKNewsViewController.h"
#import "ZKProfileViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self setupChildViewControllers];
}

- (void)setupChildViewControllers {
    ZKHotViewController *hotVC = [ZKHotViewController new];
    hotVC.title = @"热门";
    [self addChildViewController:hotVC];
    
    ZKListViewController *listVC = [ZKListViewController new];
    listVC.title = @"榜单";
    [self addChildViewController:listVC];
    
    ZKVideoViewController *videoVC = [ZKVideoViewController new];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    ZKHeadViewController *headVC = [ZKHeadViewController new];
    headVC.title = @"头条";
    [self addChildViewController:headVC];
    
    ZKNewsViewController *newsVC = [ZKNewsViewController new];
    newsVC.title = @"新闻";
    [self addChildViewController:newsVC];
    
    ZKProfileViewController *profielVC = [ZKProfileViewController new];
    profielVC.title = @"个人";
    [self addChildViewController:profielVC];
}

@end
