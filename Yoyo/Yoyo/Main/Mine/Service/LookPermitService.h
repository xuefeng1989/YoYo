//
//  LookPermitService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 设置访问权限
@interface LookPermitService : BaseRequestService
- (id)initWithPermit:(NSInteger)permit;
@end

NS_ASSUME_NONNULL_END
