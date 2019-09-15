//
//  RefreshTokenService.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "RefreshTokenService.h"

@implementation RefreshTokenService
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    return @"v1/auth/token/refresh";
}

@end
