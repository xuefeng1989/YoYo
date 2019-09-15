//
//  YoTabBarViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoTabBarViewController.h"
#import "YoCommonNavigationController.h"
#import "YoHomeViewController.h"
#import "YoAppointmentViewController.h"
#import "YoPortraitViewController.h"
#import "YoMessageViewController.h"
#import "YoMineViewController.h"


#import "YoUIHelper.h"
#import "YoCommonUI.h"

@interface YoTabBarViewController ()<YoCommonTabBarViewControllerDelegate>

@end

@implementation YoTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mcTabbar.tintColor = UIColorMake(251, 199, 115);
    self.mcTabbar.translucent = NO;
    self.mcTabbar.position = MCTabBarCenterButtonPositionBulge;
    self.mcTabbar.centerImage = [UIImage imageNamed:@"icon_tabbar_portrait"];
    self.mcTabbar.centerOffsetY = 10;
    self.cDelegate = self;
    [self addChildViewControllers];
    
}

- (void)addChildViewControllers {
    YoHomeViewController *homeVc = [[YoHomeViewController alloc] init];
    homeVc.hidesBottomBarWhenPushed = NO;
    YoCommonNavigationController *homeNavController = [[YoCommonNavigationController alloc] initWithRootViewController:homeVc];
    homeNavController.tabBarItem = [YoUIHelper tabBarItemWithTitle:@"主页" image:[UIImageMake(@"icon_tabbar_home") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"icon_tabbar_home_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    
    // 约会
    YoAppointmentViewController *appointmentVc = [[YoAppointmentViewController alloc] init];
    appointmentVc.hidesBottomBarWhenPushed = NO;
    YoCommonNavigationController *appointmentNavController = [[YoCommonNavigationController alloc] initWithRootViewController:appointmentVc];
    appointmentNavController.tabBarItem = [YoUIHelper tabBarItemWithTitle:@"约会" image:[UIImageMake(@"icon_tabbar_appointment") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_appointment_select") tag:1];
    
    // 写真
    YoPortraitViewController *portraitVc = [[YoPortraitViewController alloc] init];
    portraitVc.hidesBottomBarWhenPushed = NO;
    YoCommonNavigationController *portraitNavController = [[YoCommonNavigationController alloc] initWithRootViewController:portraitVc];

    portraitNavController.tabBarItem = [YoUIHelper tabBarItemWithTitle:@"写真集" image:[UIImageMake(@"") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"") tag:2];
    
    
    // 消息
    YoMessageViewController *messageVc = [[YoMessageViewController alloc] init];
    messageVc.hidesBottomBarWhenPushed = NO;
    YoCommonNavigationController *messageVcNavController = [[YoCommonNavigationController alloc] initWithRootViewController:messageVc];
    messageVcNavController.tabBarItem = [YoUIHelper tabBarItemWithTitle:@"消息" image:[UIImageMake(@"icon_tabbar_message") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_message_select") tag:3];
    
    // Mine
    YoMineViewController *mineVc = [[YoMineViewController alloc] initWithType:YoMineViewControllerTypeMineAndSexTypeMale];
//    YoMineViewController *mineVc = [[YoMineViewController alloc] initWithType:YoMineViewControllerTypeMineAndSexTypeFemale];
    mineVc.hidesBottomBarWhenPushed = NO;
    YoCommonNavigationController *mineNavController = [[YoCommonNavigationController alloc] initWithRootViewController:mineVc];
    
    mineNavController.tabBarItem = [YoUIHelper tabBarItemWithTitle:@"个人中心" image:[UIImageMake(@"icon_tabbar_me") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_me_select") tag:4];
    mineNavController.navigationBarHidden = YES;
    // window root controller
    self.viewControllers = @[homeNavController, appointmentNavController, portraitNavController, messageVcNavController, mineNavController];
}


- (void)commonTabBarViewController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2){
//        [self rotationAnimation];
    }else {
        [self.mcTabbar.centerBtn.layer removeAllAnimations];
    }
}


/// 旋转动画
- (void)rotationAnimation{
    if ([@"key" isEqualToString:[self.mcTabbar.centerBtn.layer animationKeys].firstObject]){
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [self.mcTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}

@end
