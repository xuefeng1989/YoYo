//
//  SMSCodeService.h
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoSendSMSType) {
    YoSendSMSTypeRegister = 0,
    YoSendSMSTypeBanding,
    YoSendSMSTypeOutBanding,
    YoSendSMSTypeForget,
};


/// 获取通用短信验证码
@interface SMSCodeService : BaseRequestService
- (id)initWithPhone:(NSString *)phone sendType:(YoSendSMSType)type;

@end

NS_ASSUME_NONNULL_END
