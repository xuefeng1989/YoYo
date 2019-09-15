//
//  YoRefreshViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoRefreshViewController : YoCommonViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *defaultFooterView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) int page;

@property (nonatomic) BOOL showRefreshHeader;

@property (nonatomic) BOOL showRefreshFooter;

@property (nonatomic, readonly) BOOL isHeaderRefreshing;

@property (nonatomic, readonly) BOOL isFooterRefreshing;

//- (void)setRefreshHeaderColor:(UIColor *)aColor;


- (void)tableViewDidTriggerHeaderRefresh;

- (void)tableViewDidTriggerFooterRefresh;

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end

NS_ASSUME_NONNULL_END
