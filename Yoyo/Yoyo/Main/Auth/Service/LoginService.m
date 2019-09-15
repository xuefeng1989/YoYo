//
//  LoginService.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "LoginService.h"
//#import "NSString+Hash.h"


@implementation LoginService{
    NSString *_phone;
    NSString *_password;
    NSString *_openId;
    NSString *_accessToken;

}

- (id)initWithPhone:(NSString *)phone password:(NSString *)password openId:(NSString *)openId accessToken:(NSString *)token{
    self = [super init];
    if (self) {
        _phone = phone;
        _password = password;
        _openId = openId;
        _accessToken = token;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"v1/auth/login";
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_phone forKey:@"mobile"];
    [self.params setValue:_password forKey:@"password"];
    [self.params setValue:_openId forKey:@"openId"];
    [self.params setValue:_accessToken forKey:@"accessToken"];



    return self.params;
}

@end
