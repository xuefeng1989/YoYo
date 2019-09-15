//
//  YoHomeWomanNewController.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeWomanNewController.h"
#import "YoOtherFemaleViewController.h"
#import "YoHomeListCell.h"
#import "YoHomeListModel.h"
#import "HomeListService.h"
#import "OnlineStatusService.h"


static CGFloat const kHomeUserCellHeight = 90;
@interface YoHomeWomanNewController ()
{
    YoHomeType type;
}
@end

@implementation YoHomeWomanNewController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh {
    self.page = 1;
    [self resetNoMoreData];
    HomeListService *listApi = [[HomeListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100) homeType:YoHomeTypeWomanNew];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self.dataArray removeAllObjects];
        
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        for (YoHomeListModel *model in [YoHomeListModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]]) {
            [self.dataArray addObject:model];
        }
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
}

- (void)tableViewDidTriggerFooterRefresh {
    self.page = self.page + 1;
    HomeListService *listApi = [[HomeListService alloc] initWithPageNum:self.page pageSize:ceilf(SCREEN_HEIGHT/100) homeType:YoHomeTypeWomanNew];
    [listApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
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
    YoHomeListCell *cell = [YoHomeListCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHomeUserCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YoOtherFemaleViewController *detailVc = [[YoOtherFemaleViewController alloc] init];
    YoHomeListModel *model = (YoHomeListModel *)self.dataArray[indexPath.row];
    detailVc.userNo = [NSString stringWithFormat:@"%ld",model.userNo];
    [self.navigationController pushViewController:detailVc animated:YES];
}
@end
