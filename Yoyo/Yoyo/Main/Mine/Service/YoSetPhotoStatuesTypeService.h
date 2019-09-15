//
//  YoSetPhotoStatuesTypeService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"
#import "YoImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YoSetPhotoStatuesTypeService : BaseRequestService
- (id)initWithUserImageModel:(YoImageModel *)imageModel;
@end

NS_ASSUME_NONNULL_END
