//
//  YoMyPhotoService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/25.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMyPhotoService.h"

@implementation YoMyPhotoService {
    NSInteger _pageNum;
    NSInteger _pageSize;
}

- (void)setWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize {
    if (self) {
        _pageNum = pageNum;
        _pageSize = pageSize;
    }
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/photos?size=%ld&current=%ld", (long)_pageSize, (long)_pageNum];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
