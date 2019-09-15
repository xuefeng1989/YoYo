//
//  YoBasePickerVIew.h
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoBasePickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

- (void)show;
- (void)dismiss;

/// 初始化方法
- (void)initPickerView;
/// 点击确定按钮
- (void)didClickComfirmHandler;
/// 点击取消按钮
- (void)didClickCancelHandler;
@end

NS_ASSUME_NONNULL_END
