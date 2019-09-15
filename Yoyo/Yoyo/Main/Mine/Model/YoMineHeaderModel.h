//
//  YoMineHeaderModel.h
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YoImageModel.h"
#import "YoMinePhotoOnce.h"
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN


@interface YoMineHeaderModel : NSObject
/// 距离
@property(nonatomic, copy) NSString *distanceString;
/// 在线状态
@property(nonatomic, assign) YoOnlineStatus onlineStatus;
/// 身份认证状态
@property(nonatomic, assign) YoAuthStatus authStatus;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) BOOL isMan;


// 数据解析
@property(nonatomic, retain)NSNumber *accountBalances;
@property(nonatomic, retain)NSNumber *age;
@property(nonatomic, retain)NSNumber *authenticate;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *chest;
@property(nonatomic, copy) NSString *dateCondition;
@property(nonatomic, copy) NSString *dateRange;
@property(nonatomic, copy) NSString *dateShow;
@property(nonatomic, retain)NSNumber *dateStatus;
@property(nonatomic, copy) NSString *dressStyle;
@property(nonatomic, copy) NSString *feeling;
@property(nonatomic, retain)NSNumber *gender;
@property(nonatomic, copy) NSString *getAppFrom;
@property(nonatomic, copy) NSString *hight;
@property(nonatomic, copy) NSString *introduce;
@property(nonatomic, copy) NSString *job;
@property(nonatomic, copy) NSString *language;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic,retain) NSArray <YoImageModel *> *photos;
@property(nonatomic, copy) NSString *qq;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, retain)NSNumber *userNo;
@property(nonatomic, assign)BOOL vip;
@property(nonatomic, assign)NSInteger vipCounter;
@property(nonatomic, copy) NSString *vipExpire;
@property(nonatomic, copy) NSString *weight;
@property (nonatomic,copy)NSString *weixin;
@property(nonatomic, retain)NSNumber *follow;
@property(nonatomic, retain)YoMinePhotoOnce *  photoOnce;
@property(nonatomic, retain)NSNumber *lookPermission;
@property(nonatomic, assign)BOOL buyContact;
@property(nonatomic, assign)BOOL buyedContact;
@property(nonatomic, copy)NSString *imUsername;
@property(nonatomic, copy)NSString *imPassword;
@end
NS_ASSUME_NONNULL_END
