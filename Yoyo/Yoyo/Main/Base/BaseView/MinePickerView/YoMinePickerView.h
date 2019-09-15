//
//  YoMinePickerView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YoMinePickerViewBlock)(NSInteger index);

@interface YoMinePickerView : UIView

+ (instancetype)pickerViewWithItem:(NSArray *)item;
- (void)show;
- (void)hide;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, copy) YoMinePickerViewBlock block;

@end

NS_ASSUME_NONNULL_END
