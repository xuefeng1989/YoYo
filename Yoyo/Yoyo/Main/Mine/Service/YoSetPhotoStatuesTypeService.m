//
//  YoSetPhotoStatuesTypeService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoSetPhotoStatuesTypeService.h"

@implementation YoSetPhotoStatuesTypeService
{
    YoImageModel * _imageModel;
    NSString * _type;
}
- (id)initWithUserImageModel:(YoImageModel *)imageModel{
    self = [super init];
    if (self) {
        _imageModel = imageModel;
        [self switchType:imageModel.imageType];
    }
    return self;
}
- (void)switchType:(YoMineUploadCollectionViewCellType )type
{
    switch (type) {
        case YoMineUploadCollectionViewCellTypeNormal:
            _type = @"0";
            break;
        case YoMineUploadCollectionViewCellTypeFire:
            _type = @"1";
            break;
        case YoMineUploadCollectionViewCellTypePay:
            _type = @"2";
            break;
            break;
        default:
            _type = @"0";
            break;
    }
}
- (YTKRequestMethod)requestMethod {
    if (self.handlerType == BaseRequestHandlerTypeRemove) {
        return YTKRequestMethodDELETE;
    }
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    if (self.handlerType == BaseRequestHandlerTypeRemove) {
        NSString *url = [NSString stringWithFormat:@"v1/user/photo/%@",_imageModel.imageId];
        return url;
    }else{
        NSString *url = [NSString stringWithFormat:@"v1/user/photo/%@/%@",_imageModel.imageId,_type];
        return url;
    }
}
@end
