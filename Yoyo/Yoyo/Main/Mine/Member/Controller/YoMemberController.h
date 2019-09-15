//
//  YoMemberController.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"
typedef void (^OrderedSuccessBlock)();
NS_ASSUME_NONNULL_BEGIN
/// 会员
@interface YoMemberController : YoCommonTableViewController
@property (nonatomic,copy) NSString *orderType;
@property (nonatomic,copy) NSString *userNo;
@property (nonatomic,copy) NSString *imageId;
@property(nonatomic, copy) OrderedSuccessBlock block;
@end

NS_ASSUME_NONNULL_END
