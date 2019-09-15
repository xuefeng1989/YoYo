//
//  NSObject+YoRootViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "NSObject+YoRootViewController.h"

@implementation NSObject (YoRootViewController)

- (UITabBarController *)yo_tabbarController {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;

}

- (UINavigationController *)yo_navigationConotroller {
    UITabBarController *tabbarController = [self yo_tabbarController];
    UINavigationController *selectedNV = tabbarController.selectedViewController;
    if ([selectedNV isKindOfClass:[UINavigationController class]]) {
        return selectedNV;
    }
    return nil;
}

- (UIViewController *)yo_rootViewController {
    UINavigationController *nav = [self yo_navigationConotroller];
    
    UIViewController *vc = nav.childViewControllers.firstObject;
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    return nil;
}

@end
