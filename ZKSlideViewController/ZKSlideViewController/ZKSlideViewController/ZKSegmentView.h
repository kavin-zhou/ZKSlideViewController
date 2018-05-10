//
//  ZKSegmentView.h
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZKSlideIndicatorStyle) {
    ZKSlideIndicatorStyleNormal,     //!< 正常样式
    ZKSlideIndicatorStyleStickiness, //!< 仿微博粘性指示器效果
};

@interface ZKSegmentView : UIView

@property (nonatomic, assign) ZKSlideIndicatorStyle indicatorStyle;
@property (nonatomic, strong) UIColor *titleColorNormal; //!< 正常颜色
@property (nonatomic, strong) UIColor *titleColorHighlight; //!< 高亮颜色

@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^selectCallback)(NSInteger index);

- (void)didScroll:(UIScrollView *)scrollView;

@end

UIKIT_EXTERN const CGFloat kTitleScrollViewHeight;
