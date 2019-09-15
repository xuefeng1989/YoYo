//
//  YoNewDetailViewController.m
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoNewDetailViewController.h"

#import "YoNewsDetailCell.h"

#import "YoNewsDetailModel.h"

@interface YoNewDetailViewController ()

@end

@implementation YoNewDetailViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorGrayBackGround;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [@[@"系统消息",@"广播消息",@"写真集消息",@"打赏消息",@"钱包消息",@"评价消息"] copy];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoNewsDetailCell *cell = [YoNewsDetailCell cellWithTableView:tableView];
    cell.type = self.newsType;
    YoNewsDetailModel *model = [[YoNewsDetailModel alloc] init];
    if (self.newsType == YoNewsTypeSystem) {
        model.title = self.dataArray[indexPath.row];
    } else {
        
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
