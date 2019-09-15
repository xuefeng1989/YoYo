//
//  YoVIPConfigService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoVIPConfigService : BaseRequestService
@property (nonatomic,copy)NSString *configType; // vip or yb
@end

NS_ASSUME_NONNULL_END
