//
//  HomeListService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "HomeListService.h"

#import "Const.h"

@implementation HomeListService {
    NSInteger _pageNum;
    NSInteger _pageSize;
    NSString *_typeString;
}

- (id)initWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize homeType:(YoHomeType)type {
    self = [super init];
    if (self) {
        _pageNum = pageNum;
        _pageSize = pageSize;
        
        switch (type) {
            case YoHomeTypeWomanNear:
                _typeString = @"WOMEN_NEAR";
                break;
            case YoHomeTypeWomanNew:
                _typeString = @"WOMEN_NEW";
                break;
            case YoHomeTypeWomanAuth:
                _typeString = @"WOMEN_AUTHED";
                break;
            case YoHomeTypeManNomal:
                _typeString = @"MEN_NORMAL";
                break;
            case YoHomeTypeManVip:
                _typeString = @"MEN_VIP";
                break;
            default:
                break;
        }
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/hall/users/%@?size=%ld&current=%ld", _typeString, _pageSize, _pageNum];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
