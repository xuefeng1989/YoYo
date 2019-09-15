//
//  YoMyPhotoService.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/25.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoMyPhotoService : BaseRequestService
- (void)setWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
@end

NS_ASSUME_NONNULL_END
