//
//  blackListService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BlackListService.h"

@implementation BlackListService {
    NSInteger _pageNum;
    NSInteger _pageSize;
}

- (id)initWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize {
    self = [super init];
    if (self) {
        _pageNum = pageNum;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/blacks?size=%ld&current=%ld", _pageSize, _pageNum];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


@end
