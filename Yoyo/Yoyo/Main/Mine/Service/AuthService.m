//
//  AuthService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AuthService.h"

@implementation AuthService{
    NSString *_code;
    NSString *_picUrl;
}

- (id)initWithAuthCode:(NSString *)code authPicUrl:(NSString *)picUrl
{
    self = [super init];
    if (self) {
        _code = code;
        _picUrl = picUrl;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"v1/user/auth";
}


- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_code forKey:@"authCode"];
    [self.params setValue:_picUrl forKey:@"authPhoto"];
    
    return self.params;
}
@end
