//
//  YoCityPickerView.h
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBasePickerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^cityCodeselectedBlock)(NSString *provinceName, NSString *cityName, NSString *cityCode);
/// 单个城市选择器
@interface YoCityPickerView : YoBasePickerView
@property(nonatomic, copy) cityCodeselectedBlock block;
+ (instancetype)showWithblock:(cityCodeselectedBlock)block;
@end

NS_ASSUME_NONNULL_END
