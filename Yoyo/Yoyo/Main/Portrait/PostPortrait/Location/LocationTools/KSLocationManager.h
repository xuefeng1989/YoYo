//
//  KSLocationManager.h
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <BMKLocationkit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KSGetLocationResultBlock)(double latitude, double longitude, NSError *error);

@interface KSLocationManager : BMKLocationManager

- (void)getCurrentLocationWithCallback:(KSGetLocationResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
