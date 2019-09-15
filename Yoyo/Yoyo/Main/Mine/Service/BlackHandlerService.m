//
//  BlackHandlerService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BlackHandlerService.h"

@implementation BlackHandlerService {
    NSInteger _userNo;
    BlackHandlerType _type;
}

- (id)initWithUserNo:(NSInteger)userNo handler:(BlackHandlerType)handlerType
{
    self = [super init];
    if (self) {
        _userNo = userNo;
        _type = handlerType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (_type == BlackHandlerTypeAdd) {
        return YTKRequestMethodPOST;
    }
    return YTKRequestMethodDELETE;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/black/%ld", _userNo];
    return url;
}


//- (id)requestArgument {
//    [super requestArgument];
//
//    [self.params setValue:_phone forKey:@"mobile"];
//    [self.params setValue:_code forKey:@"captcha"];
//
//    return self.params;
//}

@end
