//
//  YoHomeListModel.h
//  Yoyo
//
//  Created by ningcol on 2019/7/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Const.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoHomeListModel : NSObject
/**
 年龄
 */
@property(nonatomic, assign) NSInteger age;

/**
 是否认证（1已认证 0未认证）
 */
@property(nonatomic, assign) NSInteger authenticate;

/**
 头像
 */
@property(nonatomic, copy) NSString *avatar;
/**距离(米)
 */
//@property(nonatomic, assign) NSInteger distance;
/**纬度
 */
@property(nonatomic, assign) double longitude;
/**经度
 */
@property(nonatomic, assign) double latitude;
/** 性别
 */
@property(nonatomic, assign) YoSexType gender;
/**职业
 */
@property(nonatomic, copy) NSString *job;
/**
 城市
 */
@property(nonatomic, copy) NSString *location;

/**
 在线状态
 */
@property(nonatomic, assign) YoOnlineStatus onlineStatus;

/**
 昵称
 */
@property(nonatomic, copy) NSString *userName;

/**
 图片数量
 */
@property(nonatomic, assign) NSInteger photoCount;

/**
 用户id
 */
@property(nonatomic, assign) NSInteger userNo;

/**
 vip(vip:0普通 1vip)
 */
@property(nonatomic, assign) NSInteger vip;


@end

NS_ASSUME_NONNULL_END
