//
//  YoChooseSexViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoChooseSexViewController : YoCommonTableViewController
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *pwdStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, assign) YoLoginType loginType;
/// 第三登录UID
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *accessToken;
@end

NS_ASSUME_NONNULL_END
