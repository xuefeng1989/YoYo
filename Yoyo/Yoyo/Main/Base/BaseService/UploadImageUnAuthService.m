//
//  UploadImageUnAuthService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "UploadImageUnAuthService.h"
#import "AFNetworking.h"


@implementation UploadImageUnAuthService  {
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
    NSString *url = [NSString stringWithFormat:@"v1/oss/file?type=AVATAR"];
    return url;
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
