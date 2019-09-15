//
//  ChangePwdService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "ChangePwdService.h"

@implementation ChangePwdService {
    NSString *_oldPassword;
    NSString *_password;
    NSString *_code;
}

- (instancetype)initWithOldPwd:(NSString *)oldPassword password:(NSString *)password
{
    self = [super init];
    if (self) {
        _oldPassword = oldPassword;
        _password = password;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"v1/auth/change/password";
}


- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_oldPassword forKey:@"oldPassword"];
    [self.params setValue:_password forKey:@"password"];
    
    return self.params;
}

@end
