//
//  RegisterService.m
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "RegisterService.h"

#import "Const.h"

@implementation RegisterService {
    NSString *_phone;
    NSString *_password;
    NSString *_code;
    NSInteger _sex;
}

- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)code isMan:(BOOL)isMan
{
    self = [super init];
    if (self) {
        _phone = phone;
        _password = password;
        _code = code;
        _sex = isMan ? 1 : 2;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"v1/auth/register";
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
    [self.params setValue:[NSNumber numberWithInteger:_sex] forKey:@"gender"];
    [self.params setValue:self.fromString forKey:@"getAppFrom"];
    [self.params setValue:self.heightString forKey:@"hight"];
    [self.params setValue:self.tagString forKey:@"introduce"];
    [self.params setValue:self.professionString forKey:@"job"];
    [self.params setValue:self.languageString forKey:@"language"];
    [self.params setValue:[NSString stringWithFormat:@"%lf",YoUserDefault.latitude] forKey:@"latitude"];
    [self.params setValue:YoUserDefault.city forKey:@"location"];
    [self.params setValue:[NSString stringWithFormat:@"%lf",YoUserDefault.longitude] forKey:@"longitude"];
    
    [self.params setValue:_phone forKey:@"mobile"];
    [self.params setValue:_password forKey:@"password"];
    [self.params setValue:_code forKey:@"captcha"];
    [self.params setValue:@"111" forKey:@"pushToken"];
    [self.params setValue:self.qqString forKey:@"qq"];
    [self.params setValue:self.nickName forKey:@"userName"];
    [self.params setValue:self.weightString forKey:@"weight"];
    [self.params setValue:self.wxString forKey:@"weixin"];
    
    [self.params setValue:self.uid forKey:@"openId"];
    [self.params setValue:self.accessToken forKey:@"accessToken"];


    
    return self.params;
}

@end
