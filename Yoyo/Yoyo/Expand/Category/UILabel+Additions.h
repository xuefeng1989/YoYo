//
//  UILabel+Additions.h
//  DamaiHD
//
//  Created by lixiang on 13-11-5.
//  Copyright (c) 2013年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

- (void)adjustFontWithMaxSize:(CGSize)maxSize;

/**
 *  创建UIlabel
 *
 *  @param font  字体大小
 *  @param color 文本颜色
 *
 *  @return UIlabel
 */
+(UILabel *)createLabel:(UIFont *)font withColor:(UIColor *)color;

- (void)withAttributesForString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

@end
