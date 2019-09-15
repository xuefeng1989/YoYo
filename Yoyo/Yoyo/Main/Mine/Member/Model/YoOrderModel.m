//
//  YoOrderModel.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOrderModel.h"

@implementation YoOrderItemRequestModel

+ (YoOrderItemRequestModel *)apple_Buy{
    YoOrderItemRequestModel *model = [[YoOrderItemRequestModel alloc] init];
    model.type = @"BUY_COIN";
    model.typeValue = @0;
    model.desc = @"苹果内购充值";
    return model;
}
+ (YoOrderItemRequestModel *)vip_Buy{
    YoOrderItemRequestModel *model = [[YoOrderItemRequestModel alloc] init];
    model.type = @"BUY_VIP";
    model.typeValue = @1;
    model.desc = @"购买vip";
    return model;
}
+ (YoOrderItemRequestModel *)photo_Buy{
    YoOrderItemRequestModel *model = [[YoOrderItemRequestModel alloc] init];
    model.type = @"BUY_PHOTO";
    model.typeValue = @2;
    model.desc = @"购买照片";
    return model;
}
+ (YoOrderItemRequestModel *)connect_Buy{
    YoOrderItemRequestModel *model = [[YoOrderItemRequestModel alloc] init];
    model.type = @"BUY_CONTACT";
    model.typeValue = @3;
    model.desc = @"购买联系方式";
    return model;
}
@end






@implementation YoOrderItemModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

@implementation YoOrderModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        YoOrderItemModel *itemModel = [[YoOrderItemModel alloc] init];
        [itemModel setValuesForKeysWithDictionary:value];
        self.content = itemModel;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
