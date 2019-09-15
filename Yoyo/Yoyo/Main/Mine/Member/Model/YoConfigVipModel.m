//
//  YoConfigVipModel.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoConfigVipModel.h"

@implementation YoConfigVipItemModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end


@implementation YoConfigVipModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"dictValue"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)value;
            YoConfigVipItemModel *model = [[YoConfigVipItemModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            self.itemModel = model;
        }else{
            self.dictValue = value;
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
