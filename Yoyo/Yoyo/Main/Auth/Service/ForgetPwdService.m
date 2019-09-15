//
//  ForgetPwdService.m
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "ForgetPwdService.h"

@implementation ForgetPwdService {
    NSString *_phone;
    NSString *_password;
    NSString *_code;
}

- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _phone = phone;
        _password = password;
        _code = code;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"v1/auth/forget/password";
}


- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_phone forKey:@"mobile"];
    [self.params setValue:_password forKey:@"password"];
    [self.params setValue:_code forKey:@"captcha"];

    return self.params;
}
@end
