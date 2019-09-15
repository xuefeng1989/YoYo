//
//  BindMoblieService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BindMoblieService.h"

@implementation BindMoblieService {
    NSString *_phone;
//    NSString *_password;
    NSString *_code;
}

- (instancetype)initWithPhone:(NSString *)phone smsCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _phone = phone;
//        _password = password;
        _code = code;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"v1/auth/bind/mobile";
}


- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_phone forKey:@"mobile"];
    [self.params setValue:_code forKey:@"captcha"];
    
    return self.params;
}

@end
