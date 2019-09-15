//
//  YoPortraitService.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoPortraitType) {
    YoPortraitTypeNearby = 1,
    YoPortraitTypeHot,
};


@interface YoPortraitService : BaseRequestService
- (instancetype)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize sendType:(YoPortraitType)type;
@end

NS_ASSUME_NONNULL_END
