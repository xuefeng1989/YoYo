//
//  UserStaticInfoService.m
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//  

#import "UserStaticInfoService.h"

@implementation UserStaticInfoService{
    NSInteger _sex;
}

- (instancetype)initWithSex:(BOOL)isMan
{
    self = [super init];
    if (self) {
        _sex = isMan ? 1 : 2;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/auth/initdata"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];

    [self.params setValue:[NSNumber numberWithInteger:_sex] forKey:@"gender"];
    return self.params;
}
@end
