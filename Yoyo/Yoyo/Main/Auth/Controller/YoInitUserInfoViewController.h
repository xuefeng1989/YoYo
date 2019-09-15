//
//  YoInitUserInfoViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^YoMineViewUpdateBlock)();

@interface YoInitUserInfoViewController : YoCommonTableViewController
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *pwdStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, assign) YoLoginType loginType;
@property(nonatomic, assign) BOOL isMan;
/// 第三登录UID
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *accessToken;
/// 是不是更新用户信息
@property(nonatomic, assign) BOOL isUpdateUserInfo;

@property (nonatomic, copy) YoMineViewUpdateBlock block;
@end

NS_ASSUME_NONNULL_END
