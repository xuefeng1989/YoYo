//
//  LookPermitService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "LookPermitService.h"

@implementation LookPermitService  {
    NSInteger _permit;
}

- (id)initWithPermit:(NSInteger)permit
{
    self = [super init];
    if (self) {
        _permit = permit;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/lookPermit/%ld", _permit];
    return url;
}


@end
