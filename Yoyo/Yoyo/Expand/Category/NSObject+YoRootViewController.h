//
//  NSObject+YoRootViewController.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YoRootViewController)
- (UITabBarController *)yo_tabbarController;
- (UINavigationController *)yo_navigationConotroller;
- (UIViewController *)yo_rootViewController;



@end

NS_ASSUME_NONNULL_END
