//
//  YoHomeSearchService.h
//  Yoyo
//
//  Created by guzhichao on 2019/9/16.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoHomeSearchService : BaseRequestService
- (id)initWithlikeName:(NSString *)likeName Current:(NSInteger)current cityCodes:(NSInteger )size;
@end

NS_ASSUME_NONNULL_END
