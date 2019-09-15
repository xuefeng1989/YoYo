//
//  KSGeoCodeSearch.h
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KSGeoCodeSearchResultBlock)(NSArray <BMKPoiInfo *> * _Nullable poiInfoList, NSInteger errorCode);

@interface KSGeoCodeSearch : BMKGeoCodeSearch

- (void)searchCurrentAroundLocation:(CLLocationCoordinate2D)location callback:(KSGeoCodeSearchResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
