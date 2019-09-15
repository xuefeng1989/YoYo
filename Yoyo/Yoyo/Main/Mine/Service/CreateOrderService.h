//
//  CreateOrderService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YoCreateOrderType) {
    YoCreateOrderTypeRecharge = 0,
    YoCreateOrderTypeMemeber,
    YoCreateOrderTypePhoto,
    YoCreateOrderTypeContact,
    YoCreateOrderTypeAblum,
    YoCreateOrderTypeWithdraw,
};
@interface CreateOrderService : BaseRequestService

- (instancetype)initWithOrderType:(YoCreateOrderType)type contentJsonString:(NSString *)contentStr totalMoney:(double)money userNo:(NSInteger)userNo;

@end

NS_ASSUME_NONNULL_END
