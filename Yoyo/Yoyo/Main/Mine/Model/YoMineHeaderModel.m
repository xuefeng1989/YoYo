//
//  YoMineHeaderModel.m
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineHeaderModel.h"

@implementation YoMineHeaderModel

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"gender"]) {
        NSNumber *gender = (NSNumber *)value;
        self.gender = value;
        if (gender.intValue == 1) {
            self.isMan = YES;
        }else{
             self.isMan = NO;
        }
    }else if ([key isEqualToString:@"photos"]){
        NSMutableArray *tempArr = [NSMutableArray array];
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arr) {
                YoImageModel *image = [[YoImageModel alloc] init];
                [image setValuesForKeysWithDictionary:dic];
                [tempArr addObject:image];
            }
            self.photos = tempArr;
        }
    }else if ([key isEqualToString:@"authenticate"]){
        NSNumber *authenticate = (NSNumber *)value;
        if (authenticate.integerValue == 1) {
            self.authStatus = YoAuthStatusSuccess;
        }else if (authenticate.integerValue == 0){
             self.authStatus = YoAuthStatusNo;
        }else if (authenticate.integerValue == 2){
            self.authStatus = YoAuthStatusRunning;
        }else if (authenticate.integerValue == 3){
            self.authStatus = YoAuthStatusFail;
        }
        
    }else if ([key isEqualToString:@"photoOnce"]){
        NSDictionary *photoOnce = (NSDictionary *)value;
        self.photoOnce = [[YoMinePhotoOnce alloc] init];
        [self.photoOnce setValuesForKeysWithDictionary:photoOnce];
    }else if ([key isEqualToString:@"lon"]){
        NSNumber *longitude = (NSNumber *)value;
        self.longitude = longitude.doubleValue;
    } else if ([key isEqualToString:@"lat"]){
        NSNumber *latitude = (NSNumber *)value;
        self.latitude = latitude.doubleValue;
    }else if ([key isEqualToString:@"lookPermission"]){
         NSNumber *lookPermission = (NSNumber *)value;
        self.lookPermission = lookPermission;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
