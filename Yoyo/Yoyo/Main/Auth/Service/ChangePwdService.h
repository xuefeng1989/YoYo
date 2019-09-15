//
//  ChangePwdService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePwdService : BaseRequestService
- (instancetype)initWithOldPwd:(NSString *)oldPassword password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
