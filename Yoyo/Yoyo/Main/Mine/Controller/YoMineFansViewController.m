//
//  YoMineFansViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineFansViewController.h"
#import "YoHomeListCell.h"
#import "FollowListService.h"
#import "YoHomeListModel.h"
#import "FollowHandlerService.h"

static CGFloat const kMineFansCellHeight = 90;
@interface YoMineFansViewController ()
@end

@implementation YoMineFansViewController

- (void)initSubviews {
    [super initSubviews];
    self.dataArray = [NSMutableArray array];
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh {
    self.page = 1;
    [self resetNoMoreData];
    FollowListService *listApi = [[FollowListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100)];
    [self.dataArray removeAllObjects];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *modelArr = data[@"list"];
        if (modelArr && modelArr.count > 10) {
             self.showRefreshFooter = YES;
        }else{
            self.showRefreshFooter = NO;
        }
        for (NSDictionary *dic in modelArr) {
            YoHomeListModel *model = [[YoHomeListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        if (self.dataArray.count < 1) {
            self.showRefreshFooter = NO;
            [self showEmptyViewWithText:@"暂时没有关注任何人" detailText:@"" buttonTitle:@"去关注" buttonAction:@selector(takeAction)];
        }
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
}
- (void)takeAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableViewDidTriggerFooterRefresh {
    self.page = self.page + 1;
    FollowListService *listApi = [[FollowListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100)];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        //        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        //        for (YoHomeListModel *model in [YoHomeListModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"records"]]) {
        //            [self.dataArray addObject:model];
        //        }
        //        if ([[data objectForKey:@"current"] integerValue] == [[data objectForKey:@"pages"] integerValue]) {
        //            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        } else {
        //            [self.tableView.mj_footer endRefreshing];
        //        }
        //        [self.tableView reloadData];
        
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoHomeListCell *cell = [YoHomeListCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMineFansCellHeight;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteActionWithIndex:(NSIndexPath *)indexPath];
        JSLogInfo(@"点击了取消关注");
    }];
    
    if (self.isFoucsVc) {
         return @[deleteRowAction];
    } else {
        return @[];
    }
}
- (void)deleteActionWithIndex:(NSIndexPath *)indexPath{
    YoHomeListModel *model = self.dataArray[indexPath.row];
    FollowHandlerService *service = [[FollowHandlerService alloc] initWithUserNo:model.userNo handler:FollowHandlerTypeRemove];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self tableViewDidTriggerHeaderRefresh];
    } failure:^(JSError *error) {
        
    }];
}
@end
