//
//  YoUploadImageService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/16.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoUploadImageService.h"

@implementation YoUploadImageService
{
    NSArray * _imageArr;
}
- (id)initWithUserImageArray:(NSArray *)imageArr{
    self = [super init];
    if (self) {
        _imageArr = imageArr;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    
    NSString *url = [NSString stringWithFormat:@"v1/user/photos"];
    return url;
}
- (id)requestArgument {
    [super requestArgument];
    [self.params setValue:_imageArr forKey:@"list"];
    return self.params;
}
@end
