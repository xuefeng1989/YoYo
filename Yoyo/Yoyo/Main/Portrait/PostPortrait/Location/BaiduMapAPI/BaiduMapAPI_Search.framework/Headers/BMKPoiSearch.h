/*
 *  BMKPoiSearch.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKPoiSearchType.h"
#import "BMKPoiSearchOption.h"
#import "BMKPoiSearchResult.h"
#import "BMKSearchBase.h"

@protocol BMKPoiSearchDelegate;
///搜索服务
@interface BMKPoiSearch : BMKSearchBase
/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKPoiSearchDelegate> delegate;


/**
 *城市POI检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiResult通知
 *@param option 城市内搜索的搜索参数类（BMKCitySearchOption）
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiSearchInCity:(BMKPOICitySearchOption*)option;

/**
 *根据范围和检索词发起范围检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiResult通知
 *@param option 范围搜索的搜索参数类（BMKBoundSearchOption）
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiSearchInbounds:(BMKPOIBoundSearchOption*)option;
/**
 *根据中心点、半径和检索词发起周边检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiResult通知
 *@param option 周边搜索的搜索参数类（BMKNearbySearchOption）
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiSearchNearBy:(BMKPOINearbySearchOption*)option;
/**
 *根据poi uid 发起poi详情检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiDetailResult通知
 *@param option poi详情检索参数类（BMKPoiDetailSearchOption）
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiDetailSearch:(BMKPOIDetailSearchOption*)option;
/**
 *poi室内检索
 *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiIndoorResult通知
 *@param option poi室内检索参数类（BMKPoiIndoorSearchOption）
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)poiIndoorSearch:(BMKPOIIndoorSearchOption*)option;
@end

///搜索delegate，用于获取搜索结果
@protocol BMKPoiSearchDelegate<NSObject>
@optional
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode;

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPOIDetailSearchResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode;

/**
 *返回POI室内搜索结果
 *@param searcher 搜索对象
 *@param poiIndoorResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiIndoorResult:(BMKPoiSearch*)searcher result:(BMKPOIIndoorSearchResult*)poiIndoorResult errorCode:(BMKSearchErrorCode)errorCode;
@end
