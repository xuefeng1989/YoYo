//
//  GVUserDefaults+JSProperties.h
//  LGRestaurant
//
//  Created by ning on 2019/3/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "GVUserDefaults.h"
#import "Const.h"

#define YoUserDefault [GVUserDefaults standardUserDefaults]

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoOnlineStatus) {  // 在线状态
    YoOnlineStatusOn = 1,
    YoOnlineStatusOff = 0
};

typedef NS_ENUM(NSUInteger, YoAuthStatus) {  // 认证状态
    YoAuthStatusFail = 0,
    YoAuthStatusSuccess = 1,
    YoAuthStatusRunning = 2,
    YoAuthStatusNo = 3,
};

typedef NS_ENUM(NSUInteger, YoLoginType) {
    YoLoginTypePhone = 0,
    YoLoginTypeQQ
};

typedef NS_ENUM(NSUInteger, YoSexType) {
    YoSexTypeUnknow = 0,
    YoSexTypeMan,
    YoSexTypeWoman
};

typedef NS_ENUM(NSUInteger, YoLookPermissionStatus) {
    YoLookPermissionStatusOpen = 1, // 公开
    YoLookPermissionStatusHidden,   // 隐藏
    YoLookPermissionStatusHiddenPhone  // 手机号隐藏
};


@interface GVUserDefaults (JSProperties)
/// 登录类型
@property(nonatomic, assign) YoLoginType loginType;
/// 当前位置纬度
@property(nonatomic, assign) double latitude;
/// 当前位置经度
@property(nonatomic, assign) double longitude;
/// 当前城市
@property(nonatomic, copy) NSString *city;


/// 头像
@property(nonatomic, copy) NSString *avatar;
/// 性别
@property(nonatomic, assign) YoSexType sex;
/// 电话
@property(nonatomic, copy) NSString *mobile;
/// token
@property(nonatomic, copy) NSString *token;
/// tokenHead
@property(nonatomic, copy) NSString *tokenHead;
/// userID
@property(nonatomic, copy) NSString *userNo;
/// 账户余额
@property(nonatomic, assign) CGFloat balance;
/// 权限设置
@property(nonatomic, assign) YoLookPermissionStatus lookPermissionStatus;
/// 在线状态
@property(nonatomic, assign) YoOnlineStatus onlineStatus;

/// vip （1vip 0普通用户）
@property(nonatomic, assign) BOOL isVip;
/// vip特权次数
@property(nonatomic, assign) NSInteger vipCounter;



/// 约会状态(高素质:4 看礼物:3 在国外:2 不可约:0 可约:1)
@property(nonatomic, assign) NSInteger appointmentStatus;
/// 身份认证状态
@property(nonatomic, assign) YoAuthStatus authStatus;


/// 昵称
@property(nonatomic, copy) NSString *nickName;
/// 年龄
@property(nonatomic, copy) NSString *ageString;
/// 职业
@property(nonatomic, copy) NSString *professionString;
/// 身高
@property(nonatomic, copy) NSString *heightString;
/// 体重
@property(nonatomic, copy) NSString *weightString;
/// 胸围
@property(nonatomic, copy) NSString *sizeString;
/// 打扮风格
@property(nonatomic, copy) NSString *styleString;
/// 语言
@property(nonatomic, copy) NSString *languageString;
/// 感情状态
@property(nonatomic, copy) NSString *statusString;
/// 约会项目
@property(nonatomic, copy) NSString *appointmentItemString;
/// 约会条件
@property(nonatomic, copy) NSString *appointmentConditString;
/// qq
@property(nonatomic, copy) NSString *qqString;
/// 微信
@property(nonatomic, copy) NSString *wxString;
/// 从哪里知道的
@property(nonatomic, copy) NSString *fromString;
/// 个人介绍标签
@property(nonatomic, copy) NSString *tagString;
/// 约会城市，用英文逗号分隔
@property(nonatomic, copy) NSString *appointmentAreaCodeString;

@property(nonatomic, copy)NSString *imUsername;

@property(nonatomic, copy)NSString *imPassword;
@end

NS_ASSUME_NONNULL_END
