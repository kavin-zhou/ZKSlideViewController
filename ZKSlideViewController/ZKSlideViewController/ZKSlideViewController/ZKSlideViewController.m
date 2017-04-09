//
//  ZKSlideViewController.m
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKSlideViewController.h"
#import "ZKSlideHeader.h"
#import "ZKHotViewController.h"
#import "ZKListViewController.h"
#import "ZKVideoViewController.h"
#import "ZKHeadViewController.h"
#import "ZKNewsViewController.h"
#import "ZKProfileViewController.h"

@interface ZKSlideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;

@end

static const CGFloat kTitleScrollViewHeight = 50.f;

@implementation ZKSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setup];
}

- (void)initData {
    _titleBtns = [NSMutableArray array];
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self setupChildViewControllers];
    [self setupTitles];
}

- (void)setupTitles {
    NSInteger count = self.childViewControllers.count;
    CGFloat btnWidth = 100.f;
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *vc = self.childViewControllers[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleScrollView addSubview:btn];
        CGFloat btnX = btnWidth * i;
        btn.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:btn];
        i == 0?[self titleClick:btn]:nil;
    }
    
    _titleScrollView.contentSize = (CGSize){count * btnWidth, 0};
    _contentScrollView.contentSize = (CGSize){count * SCREEN_WIDTH, 0};
}

- (void)selectBtn:(UIButton *)btn {
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectedBtn = btn;
}

- (void)setupSelectedViewController:(NSInteger)index {
    UIViewController *vc = self.childViewControllers[index];
    [_contentScrollView addSubview:vc.view];
    
    CGFloat x = SCREEN_WIDTH * index;
    CGFloat height = CGRectGetHeight(_contentScrollView.frame);
    
    vc.view.frame = (CGRect){x, 0, SCREEN_WIDTH, height};
}

- (void)titleClick:(UIButton *)btn {
    [self selectBtn:btn];
    
    NSInteger index = btn.tag;
    [self setupSelectedViewController:index];
    
    CGFloat x = SCREEN_WIDTH * index;
    _contentScrollView.contentOffset = CGPointMake(x, 0);
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

- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentScrollView];
    _contentScrollView.us_top = CGRectGetMaxY(_titleScrollView.frame);
    _contentScrollView.us_size = (CGSize){SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_titleScrollView.frame)};
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.pagingEnabled = true;
    _contentScrollView.showsHorizontalScrollIndicator = false;
    _contentScrollView.delegate = self;
}

- (void)setupTitleScrollView {
    _titleScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_titleScrollView];
    _titleScrollView.frame = (CGRect){0, 64.f, SCREEN_WIDTH, kTitleScrollViewHeight};
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView.alwaysBounceHorizontal = true;
    _titleScrollView.showsHorizontalScrollIndicator = false;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    UIButton *titleBtn = _titleBtns[index];
    
    [self selectBtn:titleBtn];
    [self setupSelectedViewController:index];
}

@end
