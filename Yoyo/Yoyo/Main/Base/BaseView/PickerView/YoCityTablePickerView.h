//
//  YoCityTablePickerView.h
//  Yoyo
//
//  Created by ning on 2019/6/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^cityCodeMulSelectedBlock)(NSArray *selectedCitys, NSArray *selectedCityCodes);
typedef void(^seletedMaxCountBlock)(BOOL isMax);

/// 多列城市选择器，多选
@interface YoCityTablePickerView : UIView 
@property(nonatomic, copy) cityCodeMulSelectedBlock block;
+ (instancetype)showWithblock:(cityCodeMulSelectedBlock)block;

@property(nonatomic, copy) seletedMaxCountBlock maxBlock;
/// 设置最大选择数量的block
- (void)seletedMaxCount:(NSInteger)maxCount block:(seletedMaxCountBlock)maxBlock;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
