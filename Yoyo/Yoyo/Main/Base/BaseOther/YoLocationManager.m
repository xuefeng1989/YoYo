//
//  YoLocationManager.m
//  Yoyo
//
//  Created by ning on 2019/6/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoLocationManager.h"

#import "Const.h"

@interface YoLocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;//设置manager

@property(nonatomic, copy) LocationBlock success;

@end

@implementation YoLocationManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YoLocationManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self start];
    }
    return self;
}

- (void)refreshLocation:(LocationBlock)success {
    self.success = success;
    [self start];
}


- (void)start {
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.manager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;//精准度
        // 位置信息更新最小距离，只有移动大于这个距离才更新位置信息，默认为kCLDistanceFilterNone：不进行距离限制
        self.manager.distanceFilter = kCLLocationAccuracyKilometer;
        
        [self.manager startUpdatingLocation];
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self start];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.manager stopUpdatingLocation];//停止定位
    CLLocation *loctaion = [locations firstObject];
    JSLogInfo(@"-------%f  %f",loctaion.coordinate.latitude,loctaion.coordinate.longitude );
    
    //创建位置
    __weak __typeof(self)weakSelf = self;
    CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:loctaion.coordinate.latitude longitude:loctaion.coordinate.longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *provice = placeMark.administrativeArea;
            NSString *city = placeMark.locality;
            NSString *district = placeMark.subLocality;
            if (city == nil) {
                JSLogError(@"---error:城市为空-------");
            } else {
                if (provice == nil) {
                    provice = @"";
                }
                JSLogInfo(@"----------%@",city);
                JSLogInfo(@"----------%@",provice);
                JSLogInfo(@"----------%@",district);
                weakSelf.success(loctaion.coordinate, provice, city, district);
            }
            
        } else if (error == nil && placemarks.count == 0 ) {
        } else if (error) {
            JSLogError(@"-----%@-----",error);
        }
    }];
}

@end
