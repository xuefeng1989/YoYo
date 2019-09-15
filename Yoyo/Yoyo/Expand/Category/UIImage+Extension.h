//
//  UIImage+Extension.h
//  
//
//  Created by ningcol on 7/13/16.
//  Copyright © ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;
/* 裁剪六边形图片 */
+ (UIImage *)clipHexagonImage:(UIImage *)image;


+ (UIImage *)creatHexagonImage:(CGSize)size;

/**
 *  返回颜色图片
 *
 *  @param color 颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  裁剪图片
 *
 *  @param targetSize 图片CGSize
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;



/**
 等比压缩图片

 @param width 宽度
 */
- (UIImage *)scaleToWidth:(CGFloat)width;

@end
