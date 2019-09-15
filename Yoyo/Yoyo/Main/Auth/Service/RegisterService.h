//
//  RegisterService.h
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN
/// 注册
@interface RegisterService : BaseRequestService
@property(nonatomic, copy) NSString *avatarUrlString;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *ageString;
@property(nonatomic, copy) NSString *professionString;
@property(nonatomic, copy) NSString *heightString;
@property(nonatomic, copy) NSString *weightString;
@property(nonatomic, copy) NSString *sizeString;
@property(nonatomic, copy) NSString *styleString;
@property(nonatomic, copy) NSString *languageString;
@property(nonatomic, copy) NSString *statusString;
@property(nonatomic, copy) NSString *appointmentItemString;
@property(nonatomic, copy) NSString *appointmentConditString;
@property(nonatomic, copy) NSString *qqString;
@property(nonatomic, copy) NSString *wxString;
@property(nonatomic, copy) NSString *fromString;
@property(nonatomic, copy) NSString *tagString;
/// 城市码code，用英文逗号分隔
@property(nonatomic, copy) NSString *appointmentAreaCodeString;
/// 第三方登录才有,openId,token
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *accessToken;



- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)code isMan:(BOOL)isMan;

@end

NS_ASSUME_NONNULL_END
