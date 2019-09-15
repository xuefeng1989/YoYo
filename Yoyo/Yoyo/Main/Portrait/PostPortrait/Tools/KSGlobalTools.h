//
//  KSGlobalTools.h
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSPoiSearch.h"
#import "KSGeoCodeSearch.h"
#import "KSLocationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSGlobalTools : NSObject

@property (nonatomic, readonly, class) KSGlobalTools *tools;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

+ (void)startThirdLibWithDelegate:(id <UIApplicationDelegate>)delegate options:(NSDictionary *)launchOptions;

+ (void)getCurrentLocationWithCallback:(KSGetLocationResultBlock)callback;
+ (void)searchCurrentAroundLocationWithName:(NSString *)name page:(NSUInteger)page callback:(KSPoiSearchResultBlock)callback;
+ (void)searchCurrentAroundLocationWithcallback:(KSGeoCodeSearchResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
