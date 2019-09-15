//
//  YoMemberBuyBottomView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoConfigVipModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 支付底部弹窗
@interface YoMemberBuyBottomView : UIView

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *walletButton;

@property(nonatomic, copy) NSString *moneyString;
@property (nonatomic, strong) YoConfigVipModel *model;
@property (nonatomic, strong) UIView *bottomView;
@end

NS_ASSUME_NONNULL_END
