//
//  YoFiredBrowseService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/25.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoFiredBrowseService.h"

@implementation YoFiredBrowseService
- (NSString *)requestUrl {
    return @"v1/user/photo/browse";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

@end
