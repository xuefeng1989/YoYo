//
//  YoUserInfoNetrequestService.m
//  Yoyo
//
//  Created by 谷志超 on 2019/8/9.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoUserInfoNetrequestService.h"

@implementation YoUserInfoNetrequestService
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
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    
    NSString *url = [NSString stringWithFormat:@"v1/user/info/%ld", _userNo];
    return url;
}
@end
