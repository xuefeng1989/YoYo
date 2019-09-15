//
//  DateDataService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "DateDataService.h"

@implementation DateDataService
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/dateStatus"];
    return url;
}


@end
