//
//  ZKSlideViewController.h
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZKSlideIndicatorStyle) {
    ZKSlideIndicatorStyleNormal,     //!< 正常样式
    ZKSlideIndicatorStyleStickiness, //!< 仿微博粘性指示器效果
};

@interface ZKSlideViewController : UIViewController

@property (nonatomic, assign) ZKSlideIndicatorStyle indicatorStyle;
@property (nonatomic, strong) UIColor *titleColorNormal; //!< 正常颜色
@property (nonatomic, strong) UIColor *titleColorHighlight; //!< 高亮颜色

@end
