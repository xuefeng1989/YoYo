//
//  YoCreatOrderService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoCreatOrderServiceOrderMenu) {
    YoCreatOrderServiceOrderCreate = 0,
    YoCreatOrderServiceOrderSubmit,
    YoCreatOrderServiceOrderVerify,
};


@interface YoCreatOrderService : BaseRequestService
@property (nonatomic,assign)YoCreatOrderServiceOrderMenu requestType;
@end

NS_ASSUME_NONNULL_END
