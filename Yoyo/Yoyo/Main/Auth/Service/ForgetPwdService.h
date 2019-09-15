//
//  ForgetPwdService.h
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 忘记密码
@interface ForgetPwdService : BaseRequestService
- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
