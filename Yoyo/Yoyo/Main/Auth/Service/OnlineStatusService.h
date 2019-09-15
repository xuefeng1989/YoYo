//
//  OnlineStatusService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN
/// 更新在线状态
@interface OnlineStatusService : BaseRequestService
- (id)initWithStatus:(YoOnlineStatus)status;

@end

NS_ASSUME_NONNULL_END
