//
//  UploadImageService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoUploadImgType) {
    YoUploadImgTypeAvatar = 0,
    YoUploadImgTypePhoto,
    YoUploadImgTypeAlbum,
};


/// 上传图片
@interface UploadImageService : BaseRequestService
- (id)initWithImageArray:(NSArray *)imageArr type:(YoUploadImgType)type widthArray:(NSArray *)widthArr  heightArray:(NSArray *)heightArr;
@end

NS_ASSUME_NONNULL_END
