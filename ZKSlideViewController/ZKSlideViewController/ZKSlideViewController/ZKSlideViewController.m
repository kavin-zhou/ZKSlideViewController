//
//  ZKSlideViewController.m
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKSlideViewController.h"
#import "ZKSlideHeader.h"

@interface ZKSlideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ZKSegmentView        *segmentView;
@property (nonatomic, strong) UIScrollView         *contentScrollView;

@end

@implementation ZKSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initData];
    [self _setup];
}

- (void)_initData {
    self.titleColorNormal = [UIColor blackColor];
    self.titleColorHighlight = [UIColor redColor];
}

- (void)_setup {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self _setupSegmentView];
    [self _setupContentScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    [_segmentView setTitles:titles];
    self.contentScrollView.contentSize = (CGSize){titles.count * SCREEN_WIDTH, 0};
    [self.view bringSubviewToFront:_segmentView];
}

- (void)_setupSelectedViewController:(NSInteger)index {
    UIViewController *vc = self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    [_contentScrollView addSubview:vc.view];
    
    CGFloat x = SCREEN_WIDTH * index;
    CGFloat height = CGRectGetHeight(_contentScrollView.frame);
    vc.view.frame = (CGRect){x, 0, SCREEN_WIDTH, height};
}

- (void)_setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentScrollView];
    _contentScrollView.us_top = CGRectGetMaxY(_segmentView.frame);
    _contentScrollView.us_size = (CGSize){SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_segmentView.frame)};
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.pagingEnabled = true;
    _contentScrollView.showsHorizontalScrollIndicator = false;
    _contentScrollView.delegate = self;
}

- (void)_setupSegmentView {
    _segmentView = [[ZKSegmentView alloc] init];
    [self.view addSubview:_segmentView];
    _segmentView.frame = (CGRect){0, 64.f, SCREEN_WIDTH, kTitleScrollViewHeight};
    
    __weak typeof(self) weakSelf = self;
    [_segmentView setSelectCallback:^(NSInteger index) {
        CGFloat x = SCREEN_WIDTH * index;
        [UIView animateWithDuration:.18 animations:^{
            weakSelf.contentScrollView.contentOffset = CGPointMake(x, 0);
            [weakSelf _setupSelectedViewController:index];
        }];
    }];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [_segmentView setIndex:index];
    [self _setupSelectedViewController:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_segmentView didScroll:scrollView];
}

#pragma mark - Setter

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    _titleColorNormal = titleColorNormal;
    [_segmentView setTitleColorNormal:_titleColorNormal];
}

- (void)setTitleColorHighlight:(UIColor *)titleColorHighlight {
    _titleColorHighlight = titleColorHighlight;
    [_segmentView setTitleColorHighlight:titleColorHighlight];
}

- (void)setIndicatorStyle:(ZKSlideIndicatorStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
    [_segmentView setIndicatorStyle:indicatorStyle];
}

@end
