//
//  YoPortraitService.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitService.h"

@implementation YoPortraitService {
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString * _type;
}

- (instancetype)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize sendType:(YoPortraitType)type {
    self = [super init];
    if (self) {
        _pageIndex = pageIndex;
        _pageSize = pageSize == 0 ? 10 : pageSize;
        if (type == YoPortraitTypeNearby) {
            _type = @"NEAR";
        }else{
             _type = @"HOT";
        }
        
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    NSString *url = @"v1/album/list";
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    [self.params setValue:@(_pageIndex) forKey:@"current"];
    [self.params setValue:@(_pageSize) forKey:@"size"];
    [self.params setValue:_type forKey:@"type"];
    return self.params;
}


@end
