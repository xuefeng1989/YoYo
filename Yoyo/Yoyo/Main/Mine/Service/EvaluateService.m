//
//  EvaluateService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "EvaluateService.h"

@implementation EvaluateService{
    NSInteger _userNo;
}

- (id)initWithUserNo:(NSInteger)userNo {
    self = [super init];
    if (self) {
        _userNo = userNo;
    }
    return self;
}

- (NSString *)requestUrl {
    if (self.handlerType == BaseRequestHandlerTypePOST) {
        return @"v1/user/signs";
    }else{
        NSString *url = [NSString stringWithFormat:@"v1/user/signs/%ld", _userNo];
        return url;
    }
}

- (YTKRequestMethod)requestMethod {
    if (self.handlerType == BaseRequestHandlerTypePOST) {
        return YTKRequestMethodPOST;
    }else{
        return YTKRequestMethodGET;
    }
}



@end
