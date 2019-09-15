//
//  KSGeoCodeSearch.m
//  kinsun
//
//  Created by kinsun on 2018/12/29.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSGeoCodeSearch.h"

@interface KSGeoCodeSearch () <BMKGeoCodeSearchDelegate>

@property (nonatomic, strong, readonly) BMKReverseGeoCodeSearchOption *geoCodeOptions;
@property (nonatomic, copy) KSGeoCodeSearchResultBlock searchCurrentAroundLocationCallback;

@end

@implementation KSGeoCodeSearch
@synthesize geoCodeOptions = _geoCodeOptions;

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (void)searchCurrentAroundLocation:(CLLocationCoordinate2D)location callback:(KSGeoCodeSearchResultBlock)callback {
    _searchCurrentAroundLocationCallback = callback;
    BMKReverseGeoCodeSearchOption *options = self.geoCodeOptions;
    options.location = location;
    BOOL r = [self reverseGeoCode:options];
    NSLog(@"rrrr = %d", r);
}

- (void)onGetReverseGeoCodeResult:(BMKPoiSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (_searchCurrentAroundLocationCallback != nil) {
        _searchCurrentAroundLocationCallback(result.poiList, error);
        _searchCurrentAroundLocationCallback = nil;
    }
}

- (BMKReverseGeoCodeSearchOption *)geoCodeOptions {
    if (_geoCodeOptions == nil) {
        _geoCodeOptions = [[BMKReverseGeoCodeSearchOption alloc] init];
    }
    return _geoCodeOptions;
}

@end
