//
//  YoLocationManager.h
//  Yoyo
//
//  Created by ning on 2019/6/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN
typedef void(^LocationBlock)(CLLocationCoordinate2D coordinate, NSString *provice, NSString *city, NSString *district);

@interface YoLocationManager : NSObject
+ (instancetype)sharedInstance;
/// 返回定位基本信息，经纬度、省、市、区，如果是直辖市省为空字符串
- (void)refreshLocation:(LocationBlock)success;

@end

NS_ASSUME_NONNULL_END
