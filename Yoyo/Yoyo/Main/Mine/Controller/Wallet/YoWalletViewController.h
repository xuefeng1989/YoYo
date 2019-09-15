//
//  YoWalletViewController.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 钱包控制器
@interface YoWalletViewController : YoCommonTableViewController
@property (nonatomic,strong)NSNumber *accountBalances;
@end

NS_ASSUME_NONNULL_END
