//
//  PhoneService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/1.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 判断手机是否存在
@interface PhoneService : BaseRequestService
- (id)initWithPhone:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END
