//
//  YoSinglePickerView.h
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBasePickerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectedBlock)(NSString *string, NSInteger index);
/// 单列选择器
@interface YoSinglePickerView : YoBasePickerView

@property(nonatomic, copy) selectedBlock block;
+ (instancetype)showDataArray:(NSArray *)array block:(selectedBlock)block;

@end

NS_ASSUME_NONNULL_END
