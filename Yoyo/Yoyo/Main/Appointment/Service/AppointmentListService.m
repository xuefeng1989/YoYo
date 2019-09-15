//
//  AppointmentListService.m
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AppointmentListService.h"

@implementation AppointmentListService{
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_codes;

}

- (id)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize cityCodes:(NSString *)codes
{
    self = [super init];
    if (self) {
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _codes = codes;
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    return @"v1/broadcast/pageList";
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"pageIndex"];
    [self.params setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"pageSize"];
    [self.params setValue:_codes forKey:@"maps"];

    return self.params;
}


@end
