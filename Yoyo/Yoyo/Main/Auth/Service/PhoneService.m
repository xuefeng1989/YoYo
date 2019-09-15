//
//  PhoneService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/1.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "PhoneService.h"

@implementation PhoneService {
    NSString *_phone;
}

- (instancetype)initWithPhone:(NSString *)phone
{
    self = [super init];
    if (self) {
        _phone = phone;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/auth/check/mobile"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_phone forKey:@"mobile"];
    
    return self.params;
}

@end
