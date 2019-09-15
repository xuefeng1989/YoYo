//
//  YoUploadImageService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/16.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoUploadImageService : BaseRequestService
- (id)initWithUserImageArray:(NSArray *)imageArr;
@end

NS_ASSUME_NONNULL_END
