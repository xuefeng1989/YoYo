//
//  LogoutService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "LogoutService.h"

@implementation LogoutService
- (NSString *)requestUrl {
    return @"v1/auth/logout";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

@end
