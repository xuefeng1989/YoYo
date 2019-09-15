//
//  YoNewsViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoNewsViewController.h"
#import "YoNewDetailViewController.h"

#import "YoNewsCell.h"

@interface YoNewsViewController ()
@property(nonatomic, strong) NSArray *picArray;
@end

@implementation YoNewsViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorGrayBackGround;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [@[@"系统消息",@"广播消息",@"写真集消息",@"打赏消息",@"钱包消息",@"评价消息"] copy];
    self.picArray = @[@"icon_news_system",@"icon_news_appointment",@"icon_news_portrait",@"icon_news_reward",@"icon_news_wallet",@"icon_news_evaluate"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoNewsCell *cell = [YoNewsCell cellWithTableView:tableView];
    cell.title = self.dataArray[indexPath.row];
    cell.logoName = self.picArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YoNewDetailViewController *detailVc = [[YoNewDetailViewController alloc] init];
    detailVc.title = self.dataArray[indexPath.row];
    detailVc.newsType = indexPath.row;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}



@end
