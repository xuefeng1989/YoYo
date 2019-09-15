//
//  BlackHandlerService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, BlackHandlerType) {
    BlackHandlerTypeAdd = 0,
    BlackHandlerTypeRemove,
};

@interface BlackHandlerService : BaseRequestService
- (id)initWithUserNo:(NSInteger)userNo handler:(BlackHandlerType)handlerType;

@end

NS_ASSUME_NONNULL_END
