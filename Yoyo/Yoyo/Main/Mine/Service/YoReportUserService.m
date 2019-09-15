//
//  YoReportUserService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/11.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoReportUserService.h"

@implementation YoReportUserService
{
    NSInteger _userNo;
}
- (id)initWithUserNo:(NSInteger)userNo
{
    self = [super init];
    if (self) {
        _userNo = userNo;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    
    NSString *url = [NSString stringWithFormat:@"v1/user/report"];
    return url;
}
@end
