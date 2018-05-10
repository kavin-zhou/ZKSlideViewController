//
//  ZKSegmentView.h
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSlideViewController;

@interface ZKSegmentView : UIView

@property (nonatomic, strong) UIScrollView         *titleScrollView;
@property (nonatomic, strong) UIImageView          *indicatorView;

@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;

+ (instancetype)segmentView;

- (void)setupTitles:(ZKSlideViewController *)vc;
- (void)_centerTitleBtn:(UIButton *)btn;
- (void)updateWithTitles:(NSArray <NSString *> *)titles;

@end

static const CGFloat kTitleScrollViewBottomViewHeight = 3.f;
static const CGFloat kTitleScrollViewHeight = 50.f;
static const CGFloat kIndicatorDefaultWidth = 30.f;
