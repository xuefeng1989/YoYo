//
//  YoMessageViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMessageViewController.h"
#import "YoConversationController.h"
#import "YoNewsViewController.h"
#import "YoMessageSettingViewController.h"

#import <SGPagingView.h>


@interface YoMessageViewController () <SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) SGPageTitleView *pageTitleView;
@property(nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@end

@implementation YoMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"聊天",@"消息"];

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
    
    YoConversationController *conversationVc = [[YoConversationController alloc] init];
    YoNewsViewController *newsVc = [[YoNewsViewController alloc] init];
    NSArray *childArr = @[conversationVc, newsVc];
    
    /// pageContentScrollView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"消息中心";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImageMake(@"btn_nav_message_setting") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(handleRightBarButtonItemEvent)];
}

#pragma mark - event
- (void)handleRightBarButtonItemEvent {
    YoMessageSettingViewController *settingVc = [[YoMessageSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
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
