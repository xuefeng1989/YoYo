//
//  JSTool.h
//  LGRestaurant
//
//  Created by ning on 2019/3/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSTool : NSObject
/**
 计算两个经纬度之间的距离

 @param lng1 <#lng1 description#>
 @param lat1 <#lat1 description#>
 @param lng2 <#lng2 description#>
 @param lat2 <#lat2 description#>
 @return 距离单位为米（m）
 */
+ (double)distanceBetweenOrderBylongitude1:(double)lng1 latitude1:(double)lat1 longitude2:(double)lng2 latitude2:(double)lat2;

+ (void)openScheme:(NSString *)scheme;

+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;

+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage;

/// 获取设备信息
+ (NSString *)getDeviceName;
@end

NS_ASSUME_NONNULL_END
