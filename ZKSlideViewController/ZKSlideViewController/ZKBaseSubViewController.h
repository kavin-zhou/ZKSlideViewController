//
//  ZKBaseSubViewController.h
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSlideHeader.h"

@protocol TableViewScrollingProtocol <NSObject>

@required
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

@end


@interface ZKBaseSubViewController : UITableViewController
@property (nonatomic, weak) id<TableViewScrollingProtocol> delegate;
@end
