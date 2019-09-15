//
//  CheckThirdRegService.h
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 验证QQ是不是已经注册
@interface CheckThirdRegService : BaseRequestService
- (instancetype)initWithUid:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
