//
//  RechargeVC.h
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"

#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeVC : YoCommonTableViewController

@property (nonatomic,copy) NSString *orderType;
-(void)buy:(NSString *)productIdentifier;

@end

NS_ASSUME_NONNULL_END
