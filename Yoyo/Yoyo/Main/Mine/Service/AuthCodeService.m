//
//  AuthCodeService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AuthCodeService.h"

@implementation AuthCodeService
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"v1/user/authCode";
}
@end
