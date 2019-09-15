//
//  KSGlobalTools.m
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

#import "KSGlobalTools.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>

static NSString * const k_BAIDU_MAP_SDK_APP_KEY = @"gBIx79DiTq4Db6XzXNGKetln7Gcy86k9";
//static NSString * const k_BAIDU_MAP_SDK_APP_KEY = @"tdFgny15kZjDpccBSm9NTjUtS5gtSqAS";

@interface KSGlobalTools () <BMKLocationAuthDelegate, BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;
@property (nonatomic, strong, readonly) KSLocationManager *locationManager;
@property (nonatomic, strong, readonly) KSPoiSearch *pioSearchManager;
@property (nonatomic, strong, readonly) KSGeoCodeSearch *geoCodeSearchManager;

@end

@implementation KSGlobalTools
@synthesize locationManager = _locationManager,
pioSearchManager = _pioSearchManager,
geoCodeSearchManager = _geoCodeSearchManager;

static KSGlobalTools *_instance = nil;

+ (KSGlobalTools *)tools {
    if (_instance == nil) {
        @synchronized(self) {
            if (_instance == nil) {
                _instance = [[self alloc] init];
            }
        }
    }
    return _instance;
}

+ (void)startThirdLibWithDelegate:(id <UIApplicationDelegate>)delegate options:(NSDictionary *)launchOptions {
    KSGlobalTools *tools = self.tools;
    [BMKLocationAuth.sharedInstance checkPermisionWithKey:k_BAIDU_MAP_SDK_APP_KEY authDelegate:tools];
    BMKMapManager *mapManager = BMKMapManager.alloc.init;
    tools.mapManager = mapManager;
    [mapManager start:k_BAIDU_MAP_SDK_APP_KEY generalDelegate:tools];
}

+ (void)getCurrentLocationWithCallback:(KSGetLocationResultBlock)callback {
    KSGlobalTools *tools = self.tools;
    KSLocationManager *locationManager = tools.locationManager;
    [locationManager getCurrentLocationWithCallback:^(double latitude, double longitude, NSError * _Nonnull error) {
        tools.longitude = longitude;
        tools.latitude = latitude;
        if (callback != nil) {
            callback(latitude, longitude, error);
        }
    }];
}

+ (void)searchCurrentAroundLocationWithName:(NSString *)name page:(NSUInteger)page callback:(KSPoiSearchResultBlock)callback {
    KSGlobalTools *tools = self.tools;
    CLLocationCoordinate2D location = (CLLocationCoordinate2D){tools.latitude, tools.longitude};
    KSPoiSearch *pioSearchManager = tools.pioSearchManager;
    [pioSearchManager searchCurrentAroundLocation:location name:name page:page callback:callback];
}

+ (void)searchCurrentAroundLocationWithcallback:(KSGeoCodeSearchResultBlock)callback {
    KSGlobalTools *tools = self.tools;
    CLLocationCoordinate2D location = (CLLocationCoordinate2D){tools.latitude, tools.longitude};
    KSGeoCodeSearch *geoCodeSearchManager = tools.geoCodeSearchManager;
    [geoCodeSearchManager searchCurrentAroundLocation:location callback:callback];
}

- (KSLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[KSLocationManager alloc] init];
    }
    return _locationManager;
}

- (KSPoiSearch *)pioSearchManager {
    if (_pioSearchManager == nil) {
        _pioSearchManager = [[KSPoiSearch alloc] init];
    }
    return _pioSearchManager;
}

- (KSGeoCodeSearch *)geoCodeSearchManager {
    if (_geoCodeSearchManager == nil) {
        _geoCodeSearchManager = [[KSGeoCodeSearch alloc] init];
    }
    return _geoCodeSearchManager;
}

@end
