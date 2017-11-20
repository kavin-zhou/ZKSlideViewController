//
//  ZKSlideViewController.m
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKSlideViewController.h"
#import "ZKSlideHeader.h"
#import "NSString+ZK_Add.h"

@interface ZKSlideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;
@property (nonatomic, strong) UIImageView *indicatorView;

@end

static const CGFloat kTitleScrollViewHeight = 50.f;
static const CGFloat kTitleMargin = 25.f;
static const CGFloat kTitleScrollViewBottomViewHeight = 3.f;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTitles];
}

- (void)setupTitles {
    if (_titleBtns.count) {
        return;
    }
    
    NSInteger count = self.childViewControllers.count;
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    CGFloat totalBtnWidth = 0;
    UIButton *preBtn = nil;
    
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *vc = self.childViewControllers[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        CGFloat btnWidth = [vc.title zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT] + kTitleMargin;
        totalBtnWidth += btnWidth;
        
        [_titleScrollView addSubview:btn];
        CGFloat btnX = preBtn ? CGRectGetMaxX(preBtn.frame) : 0;
        
        btn.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:btn];
        preBtn = btn;
    }
    
    _titleScrollView.contentSize = (CGSize){CGRectGetMaxX(preBtn.frame), 0};
    _titleScrollView.contentInset = UIEdgeInsetsMake(0, kTitleMargin * .5, 0, kTitleMargin * .5);
    _contentScrollView.contentSize = (CGSize){count * SCREEN_WIDTH, 0};
    [self setupIndicatorView];
    [self titleClick:_titleBtns.firstObject];
}

- (void)setupIndicatorView {
    if (_indicatorView.superview) {
        return;
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRect){0, kTitleScrollViewHeight - kTitleScrollViewBottomViewHeight, _titleScrollView.contentSize.width, kTitleScrollViewBottomViewHeight}];
    bottomView.backgroundColor = [UIColor clearColor];
    [_titleScrollView addSubview:bottomView];
    
    _indicatorView = [[UIImageView alloc] init];
    _indicatorView.us_size = (CGSize){50, kTitleScrollViewBottomViewHeight};
    _indicatorView.us_centerX = _titleBtns[0].us_centerX;
    _indicatorView.backgroundColor = [UIColor redColor];
    _indicatorView.image = [UIImage imageNamed:@"icon_arrow_down"];
    _indicatorView.layer.masksToBounds = true;
    _indicatorView.layer.cornerRadius = kTitleScrollViewBottomViewHeight * .5;
    [bottomView addSubview:_indicatorView];
}

- (void)selectBtn:(UIButton *)btn {
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self centerTitleBtn:btn];
    _selectedBtn = btn;
    [self animate:^{
        _indicatorView.us_width = [btn.currentTitle zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT];
        _indicatorView.us_centerX = btn.us_centerX;
    }];
}

- (void)centerTitleBtn:(UIButton *)btn {
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

- (void)setupSelectedViewController:(NSInteger)index {
    
    UIViewController *vc = self.childViewControllers[index];
    
    if (vc.view.superview) {
        return;
    }
    
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
    [UIView animateWithDuration:.18 animations:^{
        _contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
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
    if ([_selectedBtn isEqual:titleBtn]) {
        return;
    }
    [self selectBtn:titleBtn];
    [self setupSelectedViewController:index];
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
    CGFloat leftScale = 1 - rightScale;
    UIFont *font = rightBtn.titleLabel.font;
    
    CGFloat centerDelta = rightBtn.us_centerX - leftBtn.us_centerX;
    CGFloat rightBtnWidth = [rightBtn.currentTitle zk_stringWidthWithFont:font height:MAXFLOAT];
    CGFloat leftBtnWidth = [leftBtn.currentTitle zk_stringWidthWithFont:font height:MAXFLOAT];
    CGFloat widthDelta = rightBtnWidth - leftBtnWidth;
    
    [self animate:^{
        _indicatorView.us_width = leftBtnWidth + widthDelta * rightScale;
        _indicatorView.us_centerX = leftBtn.us_centerX + centerDelta * rightScale;
    }];
    
    UIColor *rightColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}

- (void)animate:(void(^)())animate {
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.66 initialSpringVelocity:.66 options:UIViewAnimationOptionCurveEaseInOut animations:animate completion:nil];
}

@end
