//
//  FollowHandlerService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, FollowHandlerType) {
    FollowHandlerTypeAdd = 0,
    FollowHandlerTypeRemove,
};

@interface FollowHandlerService : BaseRequestService
- (id)initWithUserNo:(NSInteger)userNo handler:(FollowHandlerType)handlerType;

@end

NS_ASSUME_NONNULL_END
