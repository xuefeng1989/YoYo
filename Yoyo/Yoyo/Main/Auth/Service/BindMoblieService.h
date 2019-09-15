//
//  BindMoblieService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 绑定手机号或者换绑手机号
@interface BindMoblieService : BaseRequestService
- (instancetype)initWithPhone:(NSString *)phone smsCode:(NSString *)code;
@end

NS_ASSUME_NONNULL_END
