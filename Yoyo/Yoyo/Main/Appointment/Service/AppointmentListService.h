//
//  AppointmentListService.h
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointmentListService : BaseRequestService
- (id)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize cityCodes:(NSString *)codes;
@end

NS_ASSUME_NONNULL_END
