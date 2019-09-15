//
//  OnlineStatusService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "OnlineStatusService.h"

@implementation OnlineStatusService {
    NSInteger _status;
}
- (id)initWithStatus:(YoOnlineStatus)status {
    self = [super init];
    if (self) {
        _status = status;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"api/1.0.0/homepage/setOnlineStatus/%ld", _status];
    return url;
}

@end
