//
//  JSUrlArgumentsFilter.h
//  LGRestaurant
//
//  Created by ning on 2019/3/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate+YTKNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>
+ (JSUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

@end

NS_ASSUME_NONNULL_END
