//
//  FollowHandlerService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "FollowHandlerService.h"

@implementation FollowHandlerService {
    NSInteger _userNo;
    FollowHandlerType _type;
}

- (id)initWithUserNo:(NSInteger)userNo handler:(FollowHandlerType)handlerType
{
    self = [super init];
    if (self) {
        _userNo = userNo;
        _type = handlerType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (_type == FollowHandlerTypeAdd) {
        return YTKRequestMethodPOST;
    }
    return YTKRequestMethodDELETE;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/follow/%ld", _userNo];
    return url;
}


@end
