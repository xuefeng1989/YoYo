//
//  YoPhotoBroweService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPhotoBroweService.h"

@implementation YoPhotoBroweService
{
    NSString * _imageId;
}
- (id)initWithUserImageId:(NSString *)imageId{
    self = [super init];
    if (self) {
        _imageId = imageId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/user/photo/browse/%@",_imageId];
    return url;
}
@end
