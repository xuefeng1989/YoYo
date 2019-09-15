//
//  YoPhotoBroweService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoPhotoBroweService : BaseRequestService
- (id)initWithUserImageId:(NSString *)imageId;
@end

NS_ASSUME_NONNULL_END
