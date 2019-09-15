//
//  YoInputTextView.h
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//  登录注册输入框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YoInputTextViewType){
    YoInputTextViewTypePhone,
    YoInputTextViewTypePWD,
    YoInputTextViewTypeCode
};

@class YoInputTextView;
@protocol YoInputTextViewDelegate <NSObject>
@required
- (void)YoInputTextView:(YoInputTextView *)inputTextView textViewType:(YoInputTextViewType)type inputTextViewChanged:(NSString *)text;
@optional
- (void)YoInputTextView:(YoInputTextView *)inputTextView clickDownBtn:(UIButton *)btn;

@end
@interface YoInputTextView : UIView
@property(nonatomic, weak) id<YoInputTextViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame textViewType:(YoInputTextViewType)type textViewTitle:(NSString *)titleString;
@end

NS_ASSUME_NONNULL_END
