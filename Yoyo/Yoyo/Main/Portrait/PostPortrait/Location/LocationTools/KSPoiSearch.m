//
//  KSGeoCodeSearch.m
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSPoiSearch.h"

@interface KSPoiSearch () <BMKPoiSearchDelegate>

@property (nonatomic, strong, readonly) BMKPOINearbySearchOption *options;
@property (nonatomic, copy) KSPoiSearchResultBlock searchCurrentAroundLocationCallback;

@end

@implementation KSPoiSearch
@synthesize options = _options;

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (void)searchCurrentAroundLocation:(CLLocationCoordinate2D)location name:(NSString *)name page:(NSUInteger)page callback:(KSPoiSearchResultBlock)callback {
    _searchCurrentAroundLocationCallback = callback;
    BMKPOINearbySearchOption *nearbyOption = self.options;
    nearbyOption.pageIndex = page;
    nearbyOption.keywords = @[name];
    nearbyOption.location = location;
    [self poiSearchNearBy:nearbyOption];
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (_searchCurrentAroundLocationCallback != nil) {
        _searchCurrentAroundLocationCallback(poiResult.poiInfoList, poiResult.curPageIndex, poiResult.totalPageNum, error);
        _searchCurrentAroundLocationCallback = nil;
    }
}

- (BMKPOINearbySearchOption *)options {
    if (_options == nil) {
        BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
        nearbyOption.pageSize = 20;
        nearbyOption.radius = 10000;
        _options = nearbyOption;
    }
    return _options;
}

@end
