//
//  YoVIPConfigService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoVIPConfigService.h"

@implementation YoVIPConfigService

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/order/config?orderType=%@", self.configType];
    return url;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
