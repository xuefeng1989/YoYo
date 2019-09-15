//
//  NicknameService.h
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 判断昵称是否存在
@interface NicknameService : BaseRequestService
- (id)initWithNickname:(NSString *)nickName;
@end

NS_ASSUME_NONNULL_END
