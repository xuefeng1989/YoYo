//
//  HomeListService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoHomeType) {
    YoHomeTypeWomanNear,
    YoHomeTypeWomanNew,
    YoHomeTypeWomanAuth,
    YoHomeTypeManNomal,
    YoHomeTypeManVip
};

@interface HomeListService : BaseRequestService
- (id)initWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize homeType:(YoHomeType)type;
@end

NS_ASSUME_NONNULL_END
