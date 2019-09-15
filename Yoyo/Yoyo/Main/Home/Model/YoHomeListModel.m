//
//  YoHomeListModel.m
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeListModel.h"

@implementation YoHomeListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
     if ([key isEqualToString:@"lon"]){
        NSNumber *longitude = (NSNumber *)value;
        self.longitude = longitude.doubleValue;
    } else if ([key isEqualToString:@"lat"]){
        NSNumber *latitude = (NSNumber *)value;
        self.latitude = latitude.doubleValue;
    } else{
        [super setValue:value forKey:key];
    }
}
@end
