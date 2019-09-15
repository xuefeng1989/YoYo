//
//  UserAvatarService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "UserAvatarService.h"

#import <AFNetworking.h>

@implementation UserAvatarService {
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}


- (NSString *)requestUrl {
    return @"api/1.0.0/aliyun/upload/avatar";
}

- (id)requestArgument {
    return @{
            
             };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.8);
        NSString *name = @"img.jpg";
        NSString *formKey = @"file";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}


@end
