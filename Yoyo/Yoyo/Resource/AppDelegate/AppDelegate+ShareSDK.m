//
//  AppDelegate+ShareSDK.m
//  Yoyo
//
//  Created by ning on 2019/6/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"

@implementation AppDelegate (ShareSDK)
- (void)initShareSDK {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        
        [platformsRegister setupQQWithAppId:@"101516616" appkey:@"027172f1b2a5ac1d815adb8556d4c3a6"];
        
//        [platformsRegister setupWeChatWithAppId:@"" appSecret:@""];
        
        
        
    }];
}

@end
