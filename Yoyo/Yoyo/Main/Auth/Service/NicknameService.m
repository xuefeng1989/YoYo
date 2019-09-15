//
//  NicknameService.m
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "NicknameService.h"

@implementation NicknameService{
    NSString *_nickName;
}

- (instancetype)initWithNickname:(NSString *)nickName
{
    self = [super init];
    if (self) {
        _nickName = nickName;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/auth/check/nickname"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:[_nickName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]] forKey:@"nickName"];
    
    return self.params;
}

@end
