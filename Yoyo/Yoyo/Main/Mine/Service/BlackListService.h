//
//  blackListService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface BlackListService : BaseRequestService
- (id)initWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
@end

NS_ASSUME_NONNULL_END
