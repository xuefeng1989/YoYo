//
//  UserInfoService.m
//  Yoyo
//
//  Created by ningcol on 2019/8/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "UserInfoService.h"

#import "Const.h"

@implementation UserInfoService

- (NSString *)requestUrl {
    return @"v1/auth/user/update";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    [super requestArgument];
    [self.params setValue:self.ageString forKey:@"age"];
    [self.params setValue:self.avatarUrlString forKey:@"avatar"];
    [self.params setValue:self.sizeString forKey:@"chest"];
    [self.params setValue:self.appointmentConditString forKey:@"dateCondition"];
    [self.params setValue:self.appointmentAreaCodeString forKey:@"dateRange"];
    [self.params setValue:self.appointmentItemString forKey:@"dateShow"];
    [self.params setValue:self.styleString forKey:@"dressStyle"];
    [self.params setValue:self.statusString forKey:@"feeling"];

    [self.params setValue:self.fromString forKey:@"getAppFrom"];
    [self.params setValue:self.heightString forKey:@"hight"];
    [self.params setValue:self.tagString forKey:@"introduce"];
    [self.params setValue:self.professionString forKey:@"job"];
    [self.params setValue:self.languageString forKey:@"language"];
    [self.params setValue:[NSString stringWithFormat:@"%lf",YoUserDefault.latitude] forKey:@"latitude"];
    [self.params setValue:YoUserDefault.city forKey:@"location"];
    [self.params setValue:[NSString stringWithFormat:@"%lf",YoUserDefault.longitude] forKey:@"longitude"];
    
   
    [self.params setValue:self.qqString forKey:@"qq"];
    [self.params setValue:self.nickName forKey:@"userName"];
    [self.params setValue:self.weightString forKey:@"weight"];
    [self.params setValue:self.wxString forKey:@"weixin"];
    return self.params;
}
@end
