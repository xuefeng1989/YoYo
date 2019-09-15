//
//  UIColor+YoHEX.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YoHEX)
+ (UIColor *)jk_colorWithHex:(UInt32)hex;
+ (UIColor *)jk_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)jk_colorWithHexString:(NSString *)hexString;
- (NSString *)jk_HEXString;
///值不需要除以255.0
+ (UIColor *)jk_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)jk_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;
@end

NS_ASSUME_NONNULL_END
