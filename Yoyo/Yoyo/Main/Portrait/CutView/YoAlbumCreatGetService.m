//
//  YoAlbumCreatGetService.m
//  Yoyo
//
//  Created by guzhichao on 2019/9/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAlbumCreatGetService.h"

@implementation YoAlbumCreatGetService
{
     NSString *_albumId;
}
- (instancetype)initWithAlbumId:(NSString *)albumId{
    self = [super init];
    if (self) {
        _albumId = albumId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (self.handlerType == BaseRequestHandlerTypeGET) {
         return YTKRequestMethodGET;
    }else if (self.handlerType == BaseRequestHandlerTypePOST){
        return YTKRequestMethodPOST;
    }
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    NSString *url = @"/api/v1/album";
    return url;
}
@end
