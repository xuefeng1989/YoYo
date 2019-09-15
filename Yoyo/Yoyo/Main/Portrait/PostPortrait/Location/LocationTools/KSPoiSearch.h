//
//  KSGeoCodeSearch.h
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KSPoiSearchResultBlock)(NSArray <BMKPoiInfo *> * _Nullable poiInfoList, NSUInteger currentPage, NSUInteger totalPage, NSInteger errorCode);

@interface KSPoiSearch : BMKPoiSearch

- (void)searchCurrentAroundLocation:(CLLocationCoordinate2D)location name:(NSString *)name page:(NSUInteger)page callback:(KSPoiSearchResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
