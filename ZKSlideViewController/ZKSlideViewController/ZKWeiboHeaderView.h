//
//  ZKWeiboHeaderView.h
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSegmentView;

@interface ZKWeiboHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet ZKSegmentView *segCtrl;

@property (nonatomic, assign) BOOL canNotResponseTapTouchEvent;

@end


