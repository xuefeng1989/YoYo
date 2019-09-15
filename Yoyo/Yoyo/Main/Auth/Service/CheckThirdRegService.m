//
//  CheckThirdRegService.m
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "CheckThirdRegService.h"

@implementation CheckThirdRegService {
    NSString *_uid;
}

- (instancetype)initWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        _uid = uid;
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/auth/check/thirdreg"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_uid forKey:@"openId"];
    return self.params;
}




@end
