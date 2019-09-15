//
//  UploadImageService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "UploadImageService.h"

#import <AFNetworking.h>
#import "Const.h"
//#import <MJExtension.h>

@implementation UploadImageService {
    NSArray *_imageArr;
    NSArray *_widthArr;
    NSArray *_heigthArr;
    NSString *_type;
}

- (id)initWithImageArray:(NSArray *)imageArr type:(YoUploadImgType)type widthArray:(NSArray *)widthArr  heightArray:(NSArray *)heightArr {
    self = [super init];
    if (self) {
        _imageArr = imageArr;
        _widthArr = widthArr;
        _heigthArr = heightArr;
        switch (type) {
            case YoUploadImgTypeAvatar:
                _type = @"AVATAR";
                break;
            case YoUploadImgTypePhoto:
                _type = @"PHOTO";
                break;
            case YoUploadImgTypeAlbum:
                _type = @"ALBUM";
                break;
            default:
                break;
        }
        
    }
    return self;
}


- (NSString *)requestUrl {
    if (_heigthArr == nil || _widthArr == nil) {
        NSString *url = [NSString stringWithFormat:@"v1/oss/files?type=%@", _type];
        return url;

    }
    NSString *heigthStr =  [_heigthArr mj_JSONString];
    NSString *widthStr =  [_widthArr mj_JSONString];
    NSString *url = [NSString stringWithFormat:@"v1/oss/files?type=%@?hs=%@?ws=%@", _type, heigthStr, widthStr];
    return url;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < _imageArr.count; i ++ ) {
            NSData *data = UIImageJPEGRepresentation(_imageArr[i], 0.8);
            NSString *name = @"img.jpg";
            NSString *formKey = @"files";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
       
    };
}


@end
