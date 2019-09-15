//
//  YoAlbumCreatGetService.h
//  Yoyo
//
//  Created by guzhichao on 2019/9/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoAlbumCreatGetService : BaseRequestService
- (instancetype)initWithAlbumId:(NSString *)albumId;
@end

NS_ASSUME_NONNULL_END
