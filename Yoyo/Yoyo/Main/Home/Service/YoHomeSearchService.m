//
//  YoHomeSearchService.m
//  Yoyo
//
//  Created by guzhichao on 2019/9/16.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeSearchService.h"

@implementation YoHomeSearchService{
       NSInteger _current;
       NSInteger _size;
       NSString *_likeName;
}
- (id)initWithlikeName:(NSString *)likeName Current:(NSInteger)pageSize cityCodes:(NSInteger )pageIndex
{
    self = [super init];
    if (self) {
        _current = pageIndex;
        _size = pageSize;
        _likeName = likeName;
    }
    return self;
}
- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/hall/users"];
    return url;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    [super requestArgument];
    [self.params setValue:[NSNumber numberWithInteger:_current] forKey:@"current"];
    [self.params setValue:[NSNumber numberWithInteger:50] forKey:@"size"];
    [self.params setValue:_likeName forKey:@"likeName"];
    return self.params;
}

@end
