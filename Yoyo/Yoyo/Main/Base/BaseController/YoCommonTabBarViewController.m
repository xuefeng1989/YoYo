//
//  YoCommonTabBarViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTabBarViewController.h"

@interface YoCommonTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation YoCommonTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mcTabbar = [[MCTabBar alloc] init];
    [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
    self.delegate = self;
}


// 重写选中事件， 处理中间按钮选中问题
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    _mcTabbar.centerBtn.selected = (tabBarController.selectedIndex == self.viewControllers.count/2);
    
    if ([self.cDelegate respondsToSelector:@selector(commonTabBarViewController:didSelectViewController:)]){
        [self.cDelegate commonTabBarViewController:tabBarController didSelectViewController:viewController];
    }
}

- (void)buttonAction:(UIButton *)button{
    NSInteger count = self.viewControllers.count;
    self.selectedIndex = count/2;//关联中间按钮
    [self tabBarController:self didSelectViewController:self.viewControllers[self.selectedIndex]];
}

@end
