//
//  AppDelegate.h
//  Yoyo
//
//  Created by ning on 2019/5/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+YTKNetwork.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+RefreshToken.h"

#import "YoTabBarViewController.h"
#import "YoCommonNavigationController.h"
#import "YoIndexViewController.h"

#import "MyFileLogger.h"
#import "YoLocationManager.h"

#define AppkeyHunXin @"1110190603065847#appsshidai"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 网络请求配置
    [self initNetwork];
    // shareSDK
    [self initShareSDK];
    // location
    [self initLocationManager];
    // 登录刷新
//    [self refreshTokens];
    
    // 日志
    [MyFileLogger sharedManager];
    
    EMOptions *options = [EMOptions optionsWithAppkey:AppkeyHunXin];
    // apnsCertName是证书名称，可以先传nil，等后期配置apns推送时在传入证书名称
    options.apnsCertName = @"aps_development";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initRootController];
    
    return YES;
}

- (void)initRootController {
    if (!StringIsEmpty(YoUserDefault.token)) {
        YoTabBarViewController *tabBarViewController = [[YoTabBarViewController alloc] init];
        self.window.rootViewController = tabBarViewController;
    } else {
        YoIndexViewController *indexVc = [[YoIndexViewController alloc] init];
        YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:indexVc];
        self.window.rootViewController = navVc;
    }
    if (YoUserDefault.imUsername && YoUserDefault.imUsername.length > 0 &&YoUserDefault.imPassword) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:YoUserDefault.imUsername password:YoUserDefault.imPassword];
        if (!error) {
            NSLog(@"登录成功");
        }
    }
    [self.window makeKeyAndVisible];
}


- (void)initLocationManager {
    YoLocationManager *manager = [YoLocationManager sharedInstance];
    [manager refreshLocation:^(CLLocationCoordinate2D coordinate, NSString * _Nonnull provice, NSString * _Nonnull city, NSString * _Nonnull district) {
        JSLogInfo(@"%@ %@ %@",provice,city,district);
        YoUserDefault.longitude = coordinate.longitude;
        YoUserDefault.latitude = coordinate.latitude;
        YoUserDefault.city = city;
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTokens];
    });
     [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
