//
//  UserStaticInfoService.h
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 注册用户基本信息
@interface UserStaticInfoService : BaseRequestService
- (id)initWithSex:(BOOL)isMan;

@end

NS_ASSUME_NONNULL_END
