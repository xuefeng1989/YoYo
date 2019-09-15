//
//  YoCommonTableViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"
#import "Reachability.h"
#import <QMUIKit.h>


@interface YoCommonTableViewController ()
@property(nonatomic, weak) Reachability *reachbility;
@end

@implementation YoCommonTableViewController

- (void)didInitialize {
    [super didInitialize];
    
    //监听网络变化
    self.reachbility = [Reachability reachabilityWithHostName:Reachability_Test_Url];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(netStatusChange:) name:kReachabilityChangedNotification object:nil];
    //实现监听
    [self.reachbility startNotifier];
    
    _page = 0;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    
}

- (void)netStatusChange:(NSNotification *)noti {
    //判断网络状态
    switch (self.reachbility.currentReachabilityStatus) {
        case NotReachable:
            //            [MBProgressHUD showInfo:@"当前网络连接失败，请查看设置" ToView:self.view];
            JSLogInfo(@"网络异常");
            JSLogError(@"error");
            break;
        case ReachableViaWiFi:
            JSLogInfo(@"wifi上网");
            break;
        case ReachableViaWWAN:
            JSLogInfo(@"手机上网");
            break;
        default:
            break;
    }
}

#pragma mark - setter
- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_header = [JSRefreshHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
            }];
            self.tableView.mj_header.accessibilityIdentifier = @"refresh_header";
            //            header.updatedTimeHidden = YES;
        }
        else{
            [self.tableView setMj_header:nil];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_footer = [JSRefreshFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
            }];
            self.tableView.mj_footer.accessibilityIdentifier = @"refresh_footer";
        }
        else{
            [self.tableView setMj_footer:nil];
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (BOOL)isHeaderRefreshing {
    BOOL isRefreshing = NO;
    if (self.showRefreshHeader) {
        isRefreshing = self.tableView.mj_header.isRefreshing;
    }
    
    return isRefreshing;
}

- (BOOL)isFooterRefreshing {
    BOOL isRefreshing = NO;
    if (self.showRefreshFooter) {
        isRefreshing = self.tableView.mj_footer.isRefreshing;
    }
    
    return isRefreshing;
}


#pragma mark - QMUI
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}


- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

// 当用户点击界面上某个 view 时，如果此时键盘处于升起状态，则可通过重写这个方法并返回一个 YES 来达到“点击空白区域自动降下键盘”的需求
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}


/// 重写了返回按钮，shouldHoldBackButtonEvent会失效
- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIBarButtonItem *leftItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_back_black"] target:self action:@selector(handleNavLeftBarButtonEvent)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)handleNavLeftBarButtonEvent {
    [self.navigationController popViewControllerAnimated:YES];

}



#pragma mark - public refresh
- (void)autoTriggerHeaderRefresh {
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}

- (void)tableViewDidTriggerHeaderRefresh {
    
}

- (void)tableViewDidTriggerFooterRefresh {
    
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    });
}

- (void)tableViewEndRefreshNoMoreDataReload:(BOOL)reload {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

- (void)resetNoMoreData {
    [self.tableView.mj_footer resetNoMoreData];
}
@end
