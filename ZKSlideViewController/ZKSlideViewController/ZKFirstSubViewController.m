//
//  ZKFirstSubViewController.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2018/5/10.
//  Copyright © 2018年 ZK. All rights reserved.
//

#import "ZKFirstSubViewController.h"

@interface ZKFirstSubViewController ()

@end

@implementation ZKFirstSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"homePage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"主页 %zd", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)request_data {
    // 如果需要请求网络数据, 再调用tableView的reloadData之后，调用下面resetContentInset方法可以消除底部多余空白
}

#pragma mark - Private
- (void)resetContentInset {
    [self.tableView layoutIfNeeded];
    
    if (self.tableView.contentSize.height < SCREEN_HEIGHT + 136) {  // 136 = 200
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SCREEN_HEIGHT+88-self.tableView.contentSize.height, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}
@end
