//
//  ZKHomePageViewController.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import "ZKHomePageViewController.h"
#import "ZKSegmentView.h"
#import "ZKFirstSubViewController.h"
#import "ZKSecondSubViewController.h"
#import "ZKThirdSubViewController.h"
#import "ColorUtility.h"
#import "ZKWeiboHeaderView.h"

@interface ZKHomePageViewController () <TableViewScrollingProtocol, UIScrollViewDelegate> {
    BOOL _stausBarColorIsBlack;
}

@property (nonatomic, weak) UIView *navView;
@property (nonatomic, strong) ZKSegmentView *segCtrl;
@property (nonatomic, strong) ZKWeiboHeaderView *headerView;

@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ZKHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    _scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = true;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleList = @[@"主页", @"微博", @"相册"];
    
    [self configNav];
    [self addController];
    [self addHeaderView];
    [self segmentedControlChangedValue:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return _stausBarColorIsBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > headerImgHeight - topBarHeight) {
        if (![_headerView.superview isEqual:self.view]) {
            [self.view insertSubview:_headerView belowSubview:_navView];
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    } else {
        if (![_headerView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headerView belowSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }
    if (offsetY>0) {
        CGFloat alpha = offsetY/136;
        self.navView.alpha = alpha;
        
        if (alpha > 0.6 && !_stausBarColorIsBlack) {
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            _stausBarColorIsBlack = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else if (alpha <= 0.6 && _stausBarColorIsBlack) {
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            _stausBarColorIsBlack = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } else {
        self.navView.alpha = 0;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _stausBarColorIsBlack = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    //    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    //    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    //    _headerView.userInteractionEnabled = NO;
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    //    _headerView.userInteractionEnabled = NO;
}

#pragma mark - Private
- (void)configNav {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, 20)];
    titleLabel.text = @"哎呦不错";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view addSubview:navView];
    
    _navView = navView;
}

- (void)addController {
    ZKFirstSubViewController *vc1 = [[ZKFirstSubViewController alloc] init];
    vc1.delegate = self;
    ZKSecondSubViewController *vc2 = [[ZKSecondSubViewController alloc] init];
    vc2.delegate = self;
    ZKThirdSubViewController *vc3 = [[ZKThirdSubViewController alloc] init];
    vc3.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_scrollView addSubview:obj.view];
        obj.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)addHeaderView {
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommualHeaderView" owner:nil options:nil] lastObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerImgHeight+switchBarHeight);
    _headerView.label.text = @"世界人民大团结万岁";
    self.segCtrl = _headerView.segCtrl;
    _segCtrl.titles = _titleList;
    _segCtrl.backgroundColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;
    [_segCtrl setSelectCallback:^(NSInteger index) {
        [weakSelf segmentedControlChangedValue:index];
    }];
}

- (void)segmentedControlChangedValue:(NSInteger)index {
    ZKBaseSubViewController *tableVC = self.childViewControllers[index];
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", tableVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    tableVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    //    [_scrollView bringSubviewToFront:tableVC.view];
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:true];
    
    // 当没有到达临界值
    if (offsetY <= headerImgHeight - topBarHeight) {
        [tableVC.view addSubview:_headerView];
        //        for (UIView *view in tableVC.view.subviews) {
        //            if ([view isKindOfClass:[UIImageView class]]) {
        //                [tableVC.view insertSubview:_headerView belowSubview:view];
        //                break;
        //            }
        //        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    } else {
        [self.view insertSubview:_headerView belowSubview:_navView];
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    }
    _showingVC = tableVC;
}

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (ZKBaseSubViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view insertSubview:_headerView belowSubview:_navView];
    [_segCtrl didScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (int)scrollView.contentOffset.x / SCREEN_WIDTH;
    [self segmentedControlChangedValue:index];
    [_segCtrl setIndex:index];
}

@end
