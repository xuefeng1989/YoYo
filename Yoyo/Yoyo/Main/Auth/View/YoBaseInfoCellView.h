//
//  YoBaseInfoCellView.h
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YoBaseInfoCellViewType){
    YoBaseInfoCellViewTypeTextField,
    YoBaseInfoCellViewTypeLabel
};

typedef void(^cellViewTypeLabelBlock)(UILabel *label);
typedef void(^cellViewTypeTextFieldBlock)(NSString *string, UITextField *textField);
typedef void(^cellViewTypeTextFieldEndEditBlock)(NSString *string);

@interface YoBaseInfoCellView : UIView
- (instancetype)initWithFrame:(CGRect)frame viewType:(YoBaseInfoCellViewType)type title:(nonnull NSString *)titleString;

@property(nonatomic, copy) NSString *textFieldString;
@property(nonatomic, copy) NSString *textLabelString;


@property(nonatomic, copy) cellViewTypeLabelBlock didClickLabelblock;
@property(nonatomic, copy) cellViewTypeTextFieldBlock didChangeTextFieldblock;
@property(nonatomic, copy) cellViewTypeTextFieldEndEditBlock didEndEditTextFieldblock;


@end

NS_ASSUME_NONNULL_END
