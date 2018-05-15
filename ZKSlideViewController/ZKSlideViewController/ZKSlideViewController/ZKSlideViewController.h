//
//  ZKSlideViewController.h
//  ZKSlideViewController
//
//  Created by ZK on 2017/4/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSegmentView.h"

@interface ZKSlideViewController : UIViewController

@property (nonatomic, assign) ZKSlideIndicatorStyle indicatorStyle;
@property (nonatomic, strong) UIColor *titleColorNormal; //!< 正常颜色
@property (nonatomic, strong) UIColor *titleColorHighlight; //!< 高亮颜色
@property (nonatomic, assign) CGFloat topInset;

@end
