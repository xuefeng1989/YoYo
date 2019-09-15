//
//  YoCommonTabBarViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "QMUITabBarViewController.h"
#import "MCTabBar.h"


NS_ASSUME_NONNULL_BEGIN
@protocol YoCommonTabBarViewControllerDelegate<UITabBarControllerDelegate>
// 重写了选中方法，主要处理中间item选中事件
- (void)commonTabBarViewController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end


@interface YoCommonTabBarViewController : QMUITabBarViewController
@property(nonatomic, weak) id<YoCommonTabBarViewControllerDelegate> cDelegate;
@property(nonatomic, strong) MCTabBar *mcTabbar;

@end

NS_ASSUME_NONNULL_END
