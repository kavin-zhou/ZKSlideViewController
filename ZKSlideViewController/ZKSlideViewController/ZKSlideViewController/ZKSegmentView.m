//
//  ZKSegmentView.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import "ZKSegmentView.h"
#import "ZKSlideHeader.h"
#import "ZKSlideViewController.h"

@interface ZKSegmentView ()

@end

CGFloat kTitleMargin = 25.f;

@implementation ZKSegmentView

+ (instancetype)segmentView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _titleBtns = [NSMutableArray array];
    [self _setupTitleScrollView];
}

- (void)_setupTitleScrollView {
    _titleScrollView = [[UIScrollView alloc] init];
    [self addSubview:_titleScrollView];
    _titleScrollView.frame = (CGRect){0, 0, SCREEN_WIDTH, kTitleScrollViewHeight};
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView.alwaysBounceHorizontal = true;
    _titleScrollView.showsHorizontalScrollIndicator = false;
}

- (void)_setupIndicatorView {
    if (_indicatorView.superview) {
        return;
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRect){0, kTitleScrollViewHeight - kTitleScrollViewBottomViewHeight, _titleScrollView.contentSize.width, kTitleScrollViewBottomViewHeight}];
    bottomView.backgroundColor = [UIColor clearColor];
    [_titleScrollView addSubview:bottomView];
    
    _indicatorView = [[UIImageView alloc] init];
    _indicatorView.us_size = (CGSize){kIndicatorDefaultWidth, kTitleScrollViewBottomViewHeight};
    _indicatorView.us_centerX = _titleBtns[0].us_centerX;
    _indicatorView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.9];
    _indicatorView.image = [UIImage imageNamed:@"icon_arrow_down"];
    _indicatorView.layer.masksToBounds = true;
    _indicatorView.layer.cornerRadius = kTitleScrollViewBottomViewHeight * .5;
    [bottomView addSubview:_indicatorView];
}

- (void)updateWithTitles:(NSArray<NSString *> *)titles {
    
}

- (void)setupTitles:(ZKSlideViewController *)baseVC {
    if (_titleBtns.count) {
        return;
    }
    
    NSInteger count = baseVC.childViewControllers.count;
    BOOL shouldAvg = count < 5;
    if (shouldAvg) {
        kTitleMargin = 0;
    }
    
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    CGFloat totalBtnWidth = 0;
    UIButton *preBtn = nil;
    
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *vc = baseVC.childViewControllers[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:baseVC.titleColorNormal forState:UIControlStateNormal];
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
    baseVC.contentScrollView.contentSize = (CGSize){count * SCREEN_WIDTH, 0};
    [self _setupIndicatorView];
    [baseVC _titleClick:_titleBtns.firstObject];
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

@end
