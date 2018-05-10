//
//  ZKSegmentView.h
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSlideViewController;

typedef NS_ENUM(NSUInteger, ZKSlideIndicatorStyle) {
    ZKSlideIndicatorStyleNormal,     //!< 正常样式
    ZKSlideIndicatorStyleStickiness, //!< 仿微博粘性指示器效果
};

@interface ZKSegmentView : UIView

@property (nonatomic, assign) ZKSlideIndicatorStyle indicatorStyle;
@property (nonatomic, strong) UIColor *titleColorNormal; //!< 正常颜色
@property (nonatomic, strong) UIColor *titleColorHighlight; //!< 高亮颜色
@property (nonatomic, strong) UIScrollView         *titleScrollView;
@property (nonatomic, strong) UIImageView          *indicatorView;

@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtns;

+ (instancetype)segmentView;

- (void)setupTitles:(ZKSlideViewController *)vc;
- (void)_centerTitleBtn:(UIButton *)btn;
- (void)updateWithTitles:(NSArray <NSString *> *)titles;
- (void)_selectBtn:(UIButton *)btn;

@property (nonatomic, copy) void (^selectCallback)(NSInteger index);

@end

static const CGFloat kTitleScrollViewBottomViewHeight = 3.f;
static const CGFloat kTitleScrollViewHeight = 50.f;
static const CGFloat kIndicatorDefaultWidth = 30.f;
