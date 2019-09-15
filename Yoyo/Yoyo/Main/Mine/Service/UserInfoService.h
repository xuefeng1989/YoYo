//
//  UserInfoService.h
//  Yoyo
//
//  Created by ningcol on 2019/8/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoService : BaseRequestService
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
@end

NS_ASSUME_NONNULL_END
