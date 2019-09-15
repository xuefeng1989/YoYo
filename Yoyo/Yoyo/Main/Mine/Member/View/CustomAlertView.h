//
//  CustomAlertView.h
//  AlertViewDemo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 guzhichao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelctBtnBlock)(NSInteger, NSString* _Nullable);

@interface CustomAlertView : UIView
/** title背景颜色 */
@property (nonatomic, strong) UIColor *titleBackgroundColor;
/** title字体颜色 */
@property (nonatomic, strong) UIColor *titleTextColor;
/** title字体大小 */
@property (nonatomic, strong) UIFont *titleTextFont;
/** message字体颜色 */
@property (nonatomic, strong) UIColor *messageTextColor;
/** message字体大小 */
@property (nonatomic, strong) UIFont *messageTextFont;
/** cancel Button 字体颜色 */
@property (nonatomic, strong) UIColor *cancelBtnTextColor;
/** cancel Button 字体大小 */
@property (nonatomic, strong) UIFont *cancelBtnTextFont;
/** other Button 字体颜色 */
@property (nonatomic, strong) UIColor *otherBtnTextColor;
/** other Button 字体大小 */
@property (nonatomic, strong) UIFont *otherBtnTextFont;

@property (nonatomic, copy) SelctBtnBlock _Nullable selctBtnBlock;

- (instancetype _Nullable )initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;


@end

NS_ASSUME_NONNULL_END
