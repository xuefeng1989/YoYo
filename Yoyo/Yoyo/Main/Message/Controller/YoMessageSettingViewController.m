//
//  YoMesssageSettingViewController.m
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMessageSettingViewController.h"

#import "YoMessageSettgingCell.h"

@interface YoMessageSettingViewController ()<YoMessageSettgingCellDelegate>
@property(nonatomic, strong) NSArray *isOpenArray;
@end

@implementation YoMessageSettingViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorGrayBackGround;
    
    self.dataArray = [@[@"私聊消息通知",@"广播通知",@"写真集通知"] copy];
    self.isOpenArray = @[@YES,@NO,@NO];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoMessageSettgingCell *cell = [YoMessageSettgingCell cellWithTableView:tableView];
    cell.title = self.dataArray[indexPath.row];
    cell.isOpen = [self.isOpenArray[indexPath.row]  boolValue];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (void)settingCell:(YoMessageSettgingCell *)cell switchValueChage:(BOOL)on {
    JSLogInfo(@"%@ = %d",cell.title ,on);
}




- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"消息设置";
}

@end
