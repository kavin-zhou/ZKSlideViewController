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
    CGFloat btnWidth = 100.f;
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *vc = self.childViewControllers[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [_titleScrollView addSubview:btn];
        CGFloat btnX = btnWidth * i;
        btn.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        btn.transform = CGAffineTransformMakeScale(.8, .8);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:btn];
        i == 0?[self titleClick:btn]:nil;
    }
    
    _titleScrollView.contentSize = (CGSize){count * btnWidth, 0};
    _contentScrollView.contentSize = (CGSize){count * SCREEN_WIDTH, 0};
}

- (void)selectBtn:(UIButton *)btn {
    _selectedBtn.transform = CGAffineTransformMakeScale(.8, .8);
    
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self centerTitleBtn:btn];
    [self setTitleBtnScale:btn];
    _selectedBtn = btn;
}

- (void)setTitleBtnScale:(UIButton *)btn {
    [UIView animateWithDuration:.18 delay:0 options:KeyboardAnimationCurve animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)centerTitleBtn:(UIButton *)btn {
    CGFloat offsetX = btn.center.x - SCREEN_WIDTH * .5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffset = _titleScrollView.contentSize.width - SCREEN_WIDTH;
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
    _contentScrollView.contentOffset = CGPointMake(x, 0);
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
    NSInteger leftIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    NSInteger rightIndex = leftIndex + 1;
    
    UIButton *leftBtn = _titleBtns[leftIndex];
    UIButton *rightBtn = nil;
    if (rightIndex < _titleBtns.count) {
        rightBtn = _titleBtns[rightIndex];
    }
    CGFloat rightScale = scrollView.contentOffset.x / SCREEN_WIDTH;
    rightScale -= leftIndex;
    
    CGFloat leftScale = 1 - rightScale;
    
    leftBtn.transform = CGAffineTransformMakeScale(leftScale * .2 + .8, leftScale * .2 + .8);
    rightBtn.transform = CGAffineTransformMakeScale(rightScale * .2 + .8, rightScale * .2 + .8);
    
    UIColor *rightColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}

@end
