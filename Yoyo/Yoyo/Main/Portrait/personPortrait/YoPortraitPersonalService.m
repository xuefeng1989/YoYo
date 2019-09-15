//
//  YoPortraitPersonalService.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitPersonalService.h"

@implementation YoPortraitPersonalService {
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_userNo;
}

- (instancetype)initWithUserNo:(NSString *)userNo{
    self = [super init];
    if (self) {
        _userNo = userNo;
    }
    return self;

}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/album/space"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_userNo forKey:@"userNo"];
    return self.params;
}


@end
