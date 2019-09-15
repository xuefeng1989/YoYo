//
//  YoDatePickerView.h
//  Yoyo
//
//  Created by ning on 2019/6/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBasePickerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^dateSelectedBlock)(NSInteger year, NSInteger month, NSInteger day);
/// 时间选择器
@interface YoDatePickerView : YoBasePickerView
@property(nonatomic, copy) dateSelectedBlock block;
/// endYear结束的年份 （endYear传-1，代表结束年份为明年）
+ (instancetype)showEndYear:(NSInteger)year block:(dateSelectedBlock)block;

@end

NS_ASSUME_NONNULL_END
