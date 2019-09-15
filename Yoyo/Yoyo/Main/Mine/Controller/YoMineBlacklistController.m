//
//  YoMineBlacklistController.m
//  Yoyo
//
//  Created by ningcol on 2019/7/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineBlacklistController.h"

#import "YoBlacklistCell.h"

#import "YoBlacklistModel.h"
#import "BlackListService.h"
#import "YoHomeListModel.h"
#import "BlackHandlerService.h"

@interface YoMineBlacklistController ()<YoBlacklistCellDelegate>

@end

@implementation YoMineBlacklistController

- (void)initSubviews {
    [super initSubviews];
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh {
    self.page = 1;
    [self resetNoMoreData];
    [self.dataArray removeAllObjects];
    BlackListService *listApi = [[BlackListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100)];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *modelArr = data[@"list"];
        for (NSDictionary *dic in modelArr) {
            self.showRefreshFooter = YES;
            YoHomeListModel *model = [[YoHomeListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        if (self.dataArray.count < 1) {
            self.showRefreshFooter = NO;
            [self showEmptyViewWithText:@"暂时没有拉黑任何人" detailText:@"" buttonTitle:@"" buttonAction:nil];
        }
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
}

- (void)tableViewDidTriggerFooterRefresh {
    self.page = self.page + 1;
    BlackListService *listApi = [[BlackListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100)];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        for (YoHomeListModel *model in [YoHomeListModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]]) {
            [self.dataArray addObject:model];
        }
        if ([[data objectForKey:@"current"] integerValue] == [[data objectForKey:@"pages"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoBlacklistCell *cell = [YoBlacklistCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row]; //self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - YoBlacklistCellDelegate
- (void)blacklistCell:(YoBlacklistCell *)cell didClickCancelUserNo:(NSInteger)userNo {
    BlackHandlerService *serVer = [[BlackHandlerService alloc] initWithUserNo:userNo handler:BlackHandlerTypeRemove];
    [serVer js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self tableViewDidTriggerHeaderRefresh];
    } failure:^(JSError *error) {
        [QMUITips showInfo:@"取消失败，稍后再试"];
    }];
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"黑名单";
}



@end
