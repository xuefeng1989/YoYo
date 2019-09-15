//
//  EvaluateService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 获取评价
@interface EvaluateService : BaseRequestService
- (id)initWithUserNo:(NSInteger)userNo;
@end

NS_ASSUME_NONNULL_END
