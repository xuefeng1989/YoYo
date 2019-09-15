//
//  YoCommonTableViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "QMUICommonTableViewController.h"
#import "Const.h"

#import "JSRefreshHeader.h"
#import "JSRefreshFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoCommonTableViewController : QMUICommonTableViewController
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) int page;

@property (nonatomic) BOOL showRefreshHeader;

@property (nonatomic) BOOL showRefreshFooter;

@property (nonatomic, readonly) BOOL isHeaderRefreshing;

@property (nonatomic, readonly) BOOL isFooterRefreshing;
/// header刷新
- (void)tableViewDidTriggerHeaderRefresh;
/// footer刷新
- (void)tableViewDidTriggerFooterRefresh;
/// 结束刷新 是不是header 是否reload
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

- (void)tableViewEndRefreshNoMoreDataReload:(BOOL)reload;
/// 重置没有更多的数据
- (void)resetNoMoreData;
- (void)handleNavLeftBarButtonEvent;
@end

NS_ASSUME_NONNULL_END
