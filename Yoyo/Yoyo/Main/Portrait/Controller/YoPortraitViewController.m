//
//  YoPortraitViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "YoNearbyViewController.h"
#import "YoHotViewController.h"
#import "SGPagingView.h"
#import "YoPortraitTagViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <HWPanModal.h>
#import "YoPortraitCommentViewController.h"
#import "YoUIHelper.h"
#import "YoPortraitNavigationController.h"
#import "YoPortraitCutViewController.h"
#import "Yoyo-Swift.h"


#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048


@interface YoPortraitViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *titleArray;


@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation YoPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleArray = @[@"附近",@"最热"];
    [self setupPageView];
    
}

#pragma mark -

- (void)test {
    
    YoPortraitNavigationController *nav = [[YoPortraitNavigationController alloc] init];
    
    [self presentPanModal:nav];
}


- (void)create {
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
//    QMUIAlertAction *video = [QMUIAlertAction actionWithTitle:@"视频" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [self openVideo];
//    }];
    QMUIAlertAction *photo = [QMUIAlertAction actionWithTitle:@"照片" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [self openPhoto];
    }];
//    QMUIAlertAction *test = [QMUIAlertAction actionWithTitle:@"测试评论" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [self test];
//    }];
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];

//    [alert addAction:video];
    [alert addAction:photo];
//    [alert addAction:test];
    [alert addAction:cancel];
    [alert showWithAnimated:YES];
}

- (void)openPhoto {
    KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxItemCount:9];
    KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)openVideo {
    KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxItemCount:9];
    KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
    
}


- (void)setupPageView {
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.showBottomSeparator = NO;
    configure.titleFont = UIFontMake(16);
    configure.indicatorHeight = 2;
    configure.indicatorToBottomDistance = 1;
    configure.titleSelectedFont = UIFontMake(16);
    configure.titleSelectedColor = UIColorGlobal;
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.indicatorColor = UIColorGlobal;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, NORMAL_Y, self.view.frame.size.width, 44) delegate:self titleNames:self.titleArray configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
 
    YoNearbyViewController *vc0 = [[YoNearbyViewController alloc] init];
    YoHotViewController *vc1 = [[YoHotViewController alloc] init];
    
    NSArray *childArr = @[vc0, vc1];
    /// pageContentScrollView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
}


#pragma mark -
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    /// 说明：在此获取标题or当前子控制器下标值
    NSLog(@"index - - %ld", index);
}
- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"写真集";
    UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_home_add"] target:self action:@selector(create)];
    self.navigationItem.rightBarButtonItems = @[item];
}


#pragma mark - <TZImagePickerControllerDelegate>
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    JSLogInfo(@"%@",asset);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    JSLogInfo(@"%@",photos);
    YoPortraitCutViewController *cutVC = [[YoPortraitCutViewController alloc] init];
    cutVC.imagesAssetArray = photos;
    [self.navigationController pushViewController:cutVC animated:YES];
}


@end
