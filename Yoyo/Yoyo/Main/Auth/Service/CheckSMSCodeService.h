//
//  CheckSMSCodeService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"
#import "SMSCodeService.h"

NS_ASSUME_NONNULL_BEGIN
/// 验证验证码是否正确
@interface CheckSMSCodeService : BaseRequestService
- (id)initWithPhone:(NSString *)phone sendType:(YoSendSMSType)type code:(NSString *)codeStr;

@end

NS_ASSUME_NONNULL_END
