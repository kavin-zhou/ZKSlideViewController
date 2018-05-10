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

@property (nonatomic, strong) UIButton             *selectedBtn;
@property (nonatomic, strong) UIScrollView         *titleScrollView;
@property (nonatomic, strong) UIImageView          *indicatorView;

@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;

@end

CGFloat kTitleMargin = 25.f;
static const CGFloat kTitleScrollViewBottomViewHeight = 3.f;
static const CGFloat kIndicatorDefaultWidth = 30.f;

@implementation ZKSegmentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    _indicatorView.image = [UIImage imageNamed:@"icon_arrow_down"];
    _indicatorView.layer.masksToBounds = true;
    _indicatorView.layer.cornerRadius = kTitleScrollViewBottomViewHeight * .5;
    _indicatorView.backgroundColor = [_titleColorHighlight colorWithAlphaComponent:.9];
    [bottomView addSubview:_indicatorView];
}

- (void)_titleClick:(UIButton *)btn {
    [self _selectBtn:btn];
    
    NSInteger index = btn.tag;
    !self.selectCallback ?: _selectCallback(index);
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

- (void)_selectBtn:(UIButton *)btn {
    [_selectedBtn setTitleColor:_titleColorNormal forState:UIControlStateNormal];
    [btn setTitleColor:_titleColorHighlight forState:UIControlStateNormal];
    
    [self _centerTitleBtn:btn];
    _selectedBtn = btn;
    [UIView animateWithDuration:.2 animations:^{
        if (_indicatorStyle == ZKSlideIndicatorStyleNormal) {
            _indicatorView.us_width = [btn.currentTitle zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT];
        }
        _indicatorView.us_centerX = btn.us_centerX;
    }];
}

- (void)didScroll:(UIScrollView *)scrollView {
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
        if (_indicatorStyle == ZKSlideIndicatorStyleNormal) {
            _indicatorView.us_width = leftBtnWidth + widthDelta * rightScale;
        }
        else if (_indicatorStyle == ZKSlideIndicatorStyleStickiness) {
            if (rightScale <= .5) {
                _indicatorView.us_width = kIndicatorDefaultWidth + centerDelta * rightScale * 2;
            }
            else {
                _indicatorView.us_width = kIndicatorDefaultWidth + centerDelta - (rightScale-.5) * 2 * centerDelta;
            }
        }
        _indicatorView.us_centerX = leftBtn.us_centerX + centerDelta * rightScale;
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

- (void)setIndex:(NSInteger)index {
    if (_index == index) {
        return;
    }
    _index = index;
    [self _selectBtn:_titleBtns[index]];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    if (_titleBtns.count) {
        return;
    }
    
    NSInteger count = titles.count;
    BOOL shouldAvg = count < 5;
    if (shouldAvg) {
        kTitleMargin = 0;
    }
    
    CGFloat btnHeight = CGRectGetHeight(_titleScrollView.frame);
    CGFloat totalBtnWidth = 0;
    UIButton *preBtn = nil;
    
    for (NSInteger i = 0; i < count; i ++) {
        NSString *title = titles[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_titleColorNormal forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        CGFloat btnWidth = shouldAvg ? (SCREEN_WIDTH / count) : [title zk_stringWidthWithFont:btn.titleLabel.font height:MAXFLOAT] + kTitleMargin;
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
    [self _setupIndicatorView];
    [self _titleClick:_titleBtns.firstObject];
}

@end

const CGFloat kTitleScrollViewHeight = 50.f;
