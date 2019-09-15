//
//  YoDialogViewController.h
//  Yoyo
//
//  Created by ning on 2019/6/6.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "QMUIDialogViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 弹窗组件
@interface YoDialogViewController : QMUIDialogViewController

/// cancel和submit只能统一设置颜色（QMUI不支持）
@property(nonatomic, strong) UIColor *buttonTitleColor;

/// content内的文字
@property(nonatomic, copy) NSString *contentLabelString;

@end

NS_ASSUME_NONNULL_END
