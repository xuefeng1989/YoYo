//
//  YoTool.m
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoTool.h"

#import "Const.h"


@implementation YoTool
+ (void)saveUserInfo:(NSDictionary *)data {
    YoUserDefault.avatar = [data objectForKey:@"avatar"];
    YoUserDefault.sex = [[data objectForKey:@"gender"] integerValue];
    if (YoUserDefault.loginType == YoLoginTypePhone) {
        YoUserDefault.mobile = [data objectForKey:@"mobile"];
    }
    YoUserDefault.userNo = [data objectForKey:@"userNo"];
    YoUserDefault.balance = [[data objectForKey:@"accountBalances"] floatValue];
    YoUserDefault.lookPermissionStatus = [[data objectForKey:@"lookPermission"] integerValue];
    YoUserDefault.isVip = [[data objectForKey:@"vip"] integerValue] ? 1 : 0 ;
    YoUserDefault.vipCounter = [[data objectForKey:@"vipCounter"] integerValue];
    YoUserDefault.token = [data objectForKey:@"token"];
    YoUserDefault.tokenHead = [data objectForKey:@"tokenHead"];

    
    YoUserDefault.appointmentStatus = [[data objectForKey:@"dateStatus"] integerValue];
    YoUserDefault.authStatus = [[data objectForKey:@"authenticate"] integerValue];
    YoUserDefault.onlineStatus = [[data objectForKey:@"onlineStatus"] integerValue];
 
    YoUserDefault.nickName = [data objectForKey:@"userName"];
    YoUserDefault.ageString = [[data objectForKey:@"age"] stringValue];
    YoUserDefault.professionString = [data objectForKey:@"job"];
    YoUserDefault.heightString = [data objectForKey:@"hight"];
    YoUserDefault.weightString = [data objectForKey:@"weight"];
    YoUserDefault.sizeString = [data objectForKey:@"chest"];
    YoUserDefault.styleString = [data objectForKey:@"dressStyle"];
    YoUserDefault.languageString = [data objectForKey:@"language"];
    YoUserDefault.statusString = [data objectForKey:@"feeling"];
    YoUserDefault.appointmentItemString = [data objectForKey:@"dateShow"];
    YoUserDefault.appointmentConditString = [data objectForKey:@"dateCondition"];
    YoUserDefault.qqString = [data objectForKey:@"qq"];
    YoUserDefault.wxString = [data objectForKey:@"weixin"];
    YoUserDefault.fromString = [data objectForKey:@"getAppFrom"];
    YoUserDefault.tagString = [data objectForKey:@"introduce"];
    YoUserDefault.appointmentAreaCodeString = [data objectForKey:@"dateRange"];
    YoUserDefault.imPassword = [data objectForKey:@"imPassword"];
    YoUserDefault.imUsername = [data objectForKey:@"imUsername"];
}
@end
