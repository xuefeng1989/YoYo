//
//  LoginService.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 用户手机号登录
@interface LoginService : BaseRequestService
- (id)initWithPhone:(NSString *)phone password:(NSString *)password openId:(NSString *)openId accessToken:(NSString *)token;
@end

NS_ASSUME_NONNULL_END
