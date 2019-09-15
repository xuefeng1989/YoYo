//
//  YoHomeViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeViewController.h"
#import "YoCommonNavigationController.h"
#import "YoHomeWomanNearController.h"
#import "YoHomeWomanNewController.h"
#import "YoHomeWomanAuthController.h"
#import "YoHomeManNomalController.h"
#import "YoHomeManVipController.h"
#import "YoHomeCityFilterController.h"
#import "YoHomeSearchController.h"
#import "YoHomeBaseTableViewController.h"
#import "YoCityTablePickerView.h"
#import "YoCityPickerView.h"
#import <SGPagingView.h>

@interface YoHomeViewController () <SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) SGPageTitleView *pageTitleView;
@property(nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation YoHomeViewController

- (void)initSubviews {
    [super initSubviews];
        
    self.titleArray = @[@"附近",@"新来",@"认证"];
    if (YoUserDefault.sex == YoSexTypeWoman) {
        self.titleArray = @[@"普通男士",@"VIP男士"];
    }
    
    
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.bottomSeparatorColor = UIColorSeparator;
    configure.showBottomSeparator = YES;
    configure.titleFont = UIFontMake(16);
    configure.indicatorHeight = 2;
    configure.titleSelectedFont = UIFontMake(16);
    configure.titleSelectedColor = UIColorGlobal;
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.indicatorColor = UIColorGlobal;
    
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, NavigationContentTop, self.view.frame.size.width, 44) delegate:self titleNames:self.titleArray configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    YoHomeBaseTableViewController *nearVc = [[YoHomeBaseTableViewController alloc] init];
    nearVc.listDataType = YoHomeTypeWomanNear;
    YoHomeBaseTableViewController *newVc = [[YoHomeBaseTableViewController alloc] init];
    newVc.listDataType = YoHomeTypeWomanNew;
    YoHomeBaseTableViewController *authVc = [[YoHomeBaseTableViewController alloc] init];
    authVc.listDataType = YoHomeTypeWomanAuth;
    NSArray *childArr = @[nearVc, newVc, authVc];
    YoHomeBaseTableViewController *nomalVc = [[YoHomeBaseTableViewController alloc] init];
    nomalVc.listDataType = YoHomeTypeManNomal;
    YoHomeBaseTableViewController *vipVc = [[YoHomeBaseTableViewController alloc] init];
     vipVc.listDataType = YoHomeTypeManVip;
    if (YoUserDefault.sex == YoSexTypeWoman) {
        childArr = @[nomalVc, vipVc];
    }
    /// pageContentScrollView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, self.view.qmui_width - (44 + 25), 36);
    
    QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = titleView.bounds;
    [btn setImage:UIImageMake(@"icon_nav_title_search") forState:UIControlStateNormal];
    [btn setTitle:@"输入昵称搜索" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
    btn.titleLabel.font = UIFontMake(13);
    btn.backgroundColor = UIColorGrayBackGround1;
    btn.adjustsButtonWhenHighlighted = NO;
    btn.imagePosition = QMUIButtonImagePositionLeft;
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.spacingBetweenImageAndTitle = 2;
    [btn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImageMake(@"btn_nav_location") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(handleRightBarButtonItemEvent)];
    
}


#pragma mark - event
- (void)handleRightBarButtonItemEvent {
    __weak __typeof(self)weakSelf = self;
     YoCityTablePickerView *picker = [YoCityTablePickerView showWithblock:^(NSArray * _Nonnull selectedCitys, NSArray * _Nonnull selectedCityCodes) {
        JSLogInfo(@"selectedCityCodes:%@",[selectedCityCodes componentsJoinedByString:@","]);
        
        YoHomeCityFilterController *filterVc = [[YoHomeCityFilterController alloc] init];
        filterVc.title = [selectedCitys componentsJoinedByString:@","];
        [weakSelf.navigationController pushViewController:filterVc animated:YES];
    }];
    
    [picker seletedMaxCount:2 block:^(BOOL isMax) {
        [QMUITips showError:@"城市选择不能超过2个" inView:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }];
}

- (void)clickSearchBtn {
    YoHomeSearchController *searchVc = [[YoHomeSearchController alloc] init];
    YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:navVc animated:YES completion:nil];
}


#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentScrollViewDelegate
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    /// 说明：在此获取标题or当前子控制器下标值
    NSLog(@"index - - %ld", index);
}



@end
