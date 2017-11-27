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

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;
@property (nonatomic, strong) UIImageView *indicatorView;

@end

static const CGFloat kTitleScrollViewHeight = 50.f;
static CGFloat kTitleMargin = 25.f;
static const CGFloat kTitleScrollViewBottomViewHeight = 3.f;

@implementation ZKSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initData];
    [self _setup];
}

- (void)_initData {
    _titleBtns = [NSMutableArray array];
    self.titleColorNormal = [UIColor blackColor];
    self.titleColorHighlight = [UIColor blueColor];
}

- (void)_setup {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self _setupTitleScrollView];
    [self _setupContentScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _setupTitles];
}

- (void)_setupTitles {
    if (_titleBtns.count) {
        return;
    }
    
    NSInteger count = self.childViewControllers.count;
    BOOL shouldAvg = count < 5;
    if (shouldAvg) {
        kTitleMargin = 0;
    }
    
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    CGFloat totalBtnWidth = 0;
    UIButton *preBtn = nil;
    
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *vc = self.childViewControllers[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:_titleColorNormal forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        CGFloat btnWidth = shouldAvg ? (SCREEN_WIDTH / count) : [vc.title zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT] + kTitleMargin;
        totalBtnWidth += btnWidth;
        
        [_titleScrollView addSubview:btn];
        CGFloat btnX = preBtn ? CGRectGetMaxX(preBtn.frame) : 0;
        
        btn.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        [btn addTarget:self action:@selector(_titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:btn];
        preBtn = btn;
    }
    
    _titleScrollView.contentSize = (CGSize){CGRectGetMaxX(preBtn.frame), 0};
    _titleScrollView.contentInset = UIEdgeInsetsMake(0, kTitleMargin * .5, 0, kTitleMargin * .5);
    _contentScrollView.contentSize = (CGSize){count * SCREEN_WIDTH, 0};
    [self _setupIndicatorView];
    [self _titleClick:_titleBtns.firstObject];
}

- (void)_setupIndicatorView {
    if (_indicatorView.superview) {
        return;
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRect){0, kTitleScrollViewHeight - kTitleScrollViewBottomViewHeight, _titleScrollView.contentSize.width, kTitleScrollViewBottomViewHeight}];
    bottomView.backgroundColor = [UIColor clearColor];
    [_titleScrollView addSubview:bottomView];
    
    _indicatorView = [[UIImageView alloc] init];
    _indicatorView.us_size = (CGSize){50, kTitleScrollViewBottomViewHeight};
    _indicatorView.us_centerX = _titleBtns[0].us_centerX;
    _indicatorView.backgroundColor = [_titleColorHighlight colorWithAlphaComponent:.9];
    _indicatorView.image = [UIImage imageNamed:@"icon_arrow_down"];
    _indicatorView.layer.masksToBounds = true;
    _indicatorView.layer.cornerRadius = kTitleScrollViewBottomViewHeight * .5;
    [bottomView addSubview:_indicatorView];
}

- (void)_selectBtn:(UIButton *)btn {
    [_selectedBtn setTitleColor:_titleColorNormal forState:UIControlStateNormal];
    [btn setTitleColor:_titleColorHighlight forState:UIControlStateNormal];
    
    [self _centerTitleBtn:btn];
    _selectedBtn = btn;
    [self _animate:^{
        _indicatorView.us_width = [btn.currentTitle zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT];
        _indicatorView.us_centerX = btn.us_centerX;
    }];
}

- (void)_centerTitleBtn:(UIButton *)btn {
    CGFloat offsetX = btn.center.x - SCREEN_WIDTH * .5;
    
    if (offsetX < -kTitleMargin * .5) {
        offsetX = -kTitleMargin * .5;
    }
    CGFloat maxOffset = _titleScrollView.contentSize.width - SCREEN_WIDTH + kTitleMargin * .5;
    if (offsetX > maxOffset) {
        offsetX = maxOffset;
    }
    [_titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:true];
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

- (void)_titleClick:(UIButton *)btn {
    [self _selectBtn:btn];
    
    NSInteger index = btn.tag;
    [self _setupSelectedViewController:index];
    
    CGFloat x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:.18 animations:^{
        _contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
}

- (void)_setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentScrollView];
    _contentScrollView.us_top = CGRectGetMaxY(_titleScrollView.frame);
    _contentScrollView.us_size = (CGSize){SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_titleScrollView.frame)};
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.pagingEnabled = true;
    _contentScrollView.showsHorizontalScrollIndicator = false;
    _contentScrollView.delegate = self;
}

- (void)_setupTitleScrollView {
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
    if ([_selectedBtn isEqual:titleBtn]) {
        return;
    }
    [self _selectBtn:titleBtn];
    [self _setupSelectedViewController:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger leftIndex = MAX(floorf(scrollView.contentOffset.x / SCREEN_WIDTH), 0);
    NSInteger rightIndex = MIN(_titleBtns.count - 1, leftIndex + 1);
    CGFloat slideDistance = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    UIButton *leftBtn = _titleBtns[leftIndex];
    UIButton *rightBtn = _titleBtns[rightIndex];
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
        _indicatorView.us_width = leftBtnWidth + widthDelta * rightScale;
        _indicatorView.us_centerX = leftBtn.us_centerX + centerDelta * rightScale;
    }];
    
    CGFloat deltaRateRed = (self.titleColorHighlight.zk_red - self.titleColorNormal.zk_red) * rightScale;
    CGFloat deltaRateGreen = (self.titleColorHighlight.zk_green - self.titleColorNormal.zk_green) * rightScale;
    CGFloat deltaRateBlue = (self.titleColorHighlight.zk_blue - self.titleColorNormal.zk_blue) * rightScale;
    CGFloat deltaRateAlpha = (self.titleColorHighlight.zk_alpha - self.titleColorNormal.zk_alpha) * rightScale;
    
    UIColor *rightColor = [UIColor colorWithRed:(_titleColorNormal.zk_red + deltaRateRed) green:(_titleColorNormal.zk_green + deltaRateGreen) blue:(_titleColorNormal.zk_blue + deltaRateBlue) alpha:(_titleColorNormal.zk_alpha + deltaRateAlpha)];
    UIColor *leftColor = [UIColor colorWithRed:(_titleColorHighlight.zk_red - deltaRateRed) green:(_titleColorHighlight.zk_green - deltaRateGreen) blue:(_titleColorHighlight.zk_blue - deltaRateBlue) alpha:(_titleColorHighlight.zk_alpha - deltaRateAlpha)];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}

- (void)_animate:(void(^)())animate {
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.66 initialSpringVelocity:.66 options:UIViewAnimationOptionCurveEaseInOut animations:animate completion:nil];
}

@end
