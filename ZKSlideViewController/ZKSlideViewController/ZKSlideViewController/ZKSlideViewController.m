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

@end

@implementation ZKSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initData];
    [self _setup];
}

- (void)_initData {
    self.titleColorNormal = [UIColor blackColor];
    self.titleColorHighlight = [UIColor blueColor];
}

- (void)_setup {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self _setupSegmentView];
    [self _setupContentScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_segmentView setupTitles:self];
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
    _segmentView = [ZKSegmentView segmentView];
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
    UIButton *titleBtn = _segmentView.titleBtns[index];
//    if ([_selectedBtn isEqual:titleBtn]) {
//        return;
//    }
    [_segmentView _selectBtn:titleBtn];
    [self _setupSelectedViewController:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger leftIndex = MAX(floorf(scrollView.contentOffset.x / SCREEN_WIDTH), 0);
    NSInteger rightIndex = MIN(_segmentView.titleBtns.count - 1, leftIndex + 1);
    CGFloat slideDistance = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    UIButton *leftBtn = _segmentView.titleBtns[leftIndex];
    UIButton *rightBtn = _segmentView.titleBtns[rightIndex];
    if (leftIndex == slideDistance) {
        rightBtn = leftBtn;
    }
    CGFloat rightScale = slideDistance - leftIndex;
    UIFont *font = rightBtn.titleLabel.font;
    
    CGFloat centerDelta = rightBtn.us_centerX - leftBtn.us_centerX;
    CGFloat rightBtnWidth = [rightBtn.currentTitle zk_stringWidthWithFont:font height:MAXFLOAT];
    CGFloat leftBtnWidth = [leftBtn.currentTitle zk_stringWidthWithFont:font height:MAXFLOAT];
    CGFloat widthDelta = rightBtnWidth - leftBtnWidth;
    
    [self _animate:^{
        if (_indicatorStyle == ZKSlideIndicatorStyleNormal) {
            _segmentView.indicatorView.us_width = leftBtnWidth + widthDelta * rightScale;
        }
        else if (_indicatorStyle == ZKSlideIndicatorStyleStickiness) {
            if (rightScale <= .5) {
                _segmentView.indicatorView.us_width = kIndicatorDefaultWidth + centerDelta * rightScale * 2;
            }
            else {
                _segmentView.indicatorView.us_width = kIndicatorDefaultWidth + centerDelta - (rightScale-.5) * 2 * centerDelta;
            }
        }
        _segmentView.indicatorView.us_centerX = leftBtn.us_centerX + centerDelta * rightScale;
    }];
    
    CGFloat deltaRateRed = (self.titleColorHighlight.zk_red - self.titleColorNormal.zk_red) * rightScale;
    CGFloat deltaRateGreen = (self.titleColorHighlight.zk_green - self.titleColorNormal.zk_green) * rightScale;
    CGFloat deltaRateBlue = (self.titleColorHighlight.zk_blue - self.titleColorNormal.zk_blue) * rightScale;
    CGFloat deltaRateAlpha = (self.titleColorHighlight.zk_alpha - self.titleColorNormal.zk_alpha) * rightScale;
    
    UIColor *rightColor = [UIColor colorWithRed:(_titleColorNormal.zk_red + deltaRateRed)
                                          green:(_titleColorNormal.zk_green + deltaRateGreen)
                                           blue:(_titleColorNormal.zk_blue + deltaRateBlue)
                                          alpha:(_titleColorNormal.zk_alpha + deltaRateAlpha)];
    UIColor *leftColor = [UIColor colorWithRed:(_titleColorHighlight.zk_red - deltaRateRed)
                                         green:(_titleColorHighlight.zk_green - deltaRateGreen)
                                          blue:(_titleColorHighlight.zk_blue - deltaRateBlue)
                                         alpha:(_titleColorHighlight.zk_alpha - deltaRateAlpha)];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}

- (void)_animate:(void(^)())animate {
    if (_indicatorStyle == ZKSlideIndicatorStyleNormal) {
        [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.66 initialSpringVelocity:.66 options:UIViewAnimationOptionCurveEaseInOut animations:animate completion:nil];
    }
    else if (_indicatorStyle == ZKSlideIndicatorStyleStickiness) {
        [UIView animateWithDuration:.25 animations:animate];
    }
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
