//
//  KSLocationManager.m
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSLocationManager.h"

@interface KSLocationManager () <BMKLocationManagerDelegate>

@property (nonatomic, copy) KSGetLocationResultBlock getLocationCallback;

@end

@implementation KSLocationManager

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        //设置返回位置的坐标系类型
        self.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        self.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        self.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        self.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        self.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        self.allowsBackgroundLocationUpdates = NO;
        //设置位置获取超时时间
        self.locationTimeout = 10;
        //设置获取地址信息超时时间
        self.reGeocodeTimeout = 10;
    }
    return self;
}

- (void)getCurrentLocationWithCallback:(KSGetLocationResultBlock)callback {
    _getLocationCallback = callback;
    [self startUpdatingLocation];
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (_getLocationCallback != nil) {
        CLLocationCoordinate2D coordinate = location.location.coordinate;
        _getLocationCallback(coordinate.latitude, coordinate.longitude, error);
        _getLocationCallback = nil;
    }
    [manager stopUpdatingLocation];
}

@end
