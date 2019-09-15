//
//  UIImage+Extension.h
//
//
//  Created by ningcol on 8/13/16.
//  Copyright © ningcol. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)clipImage:(UIImage *)image
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    //画圆：正切于上下文
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //设为裁剪区域
    [path addClip];
    //画图片
    [image drawAtPoint:CGPointZero];
    //生成一个新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)clipHexagonImage:(UIImage *)image
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    //六边形：正切于上下文
    float viewWidth = image.size.width;
    
    float circleRect = viewWidth / 60;
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(circleRect, circleRect, image.size.width-circleRect*2, image.size.width-circleRect*2)] addClip];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
//    path.lineCapStyle = kCGLineCapRound;
//    path.lineJoinStyle = kCGLineJoinRound;

    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    //闭合线
    [path closePath];
  
    //设为裁剪区域
    [path addClip];
    // 设置填充颜色
//    UIColor *fillColor = [UIColor greenColor];
//    [fillColor set];
//    [path fill];
//    UIColor *strokeColor = [UIColor blueColor];
//    [strokeColor set];
    // 根据我们设置的各个点连线
    [path stroke];
    //画图片
 //   [image drawAtPoint:CGPointMake(viewWidth, viewWidth)];
    [image drawAtPoint:CGPointZero];
    //生成一个新的图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}



+ (UIImage *)creatHexagonImage:(CGSize)size;
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    //六边形：正切于上下文
    float viewWidth = size.width;
    
    float circleRect = viewWidth / 60;
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(circleRect, circleRect,size.width-circleRect*2, size.width-circleRect*2)] addClip];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    //    path.lineCapStyle = kCGLineCapRound;
    //    path.lineJoinStyle = kCGLineJoinRound;
    
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    //闭合线
    [path closePath];
    
    //设为裁剪区域
    [path addClip];
    // 设置填充颜色
//        UIColor *fillColor = [UIColor greenColor];
//        [fillColor set];
//        [path fill];
        UIColor *strokeColor = [UIColor whiteColor];
        [strokeColor set];
    // 根据我们设置的各个点连线
    [path stroke];
    //画图片
    UIImage *image;
    [image drawAtPoint:CGPointMake(viewWidth, viewWidth)];
    
    //生成一个新的图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}
- (UIImage *)scaleToWidth:(CGFloat)width{
    
    // 如果传入的宽度比当前宽度还要大,就直接返回
    if (width > self.size.width) {
        return  self;
    }
    
    // 计算缩放之后的高度
    CGFloat height = (width / self.size.width) * self.size.height;
    
    // 初始化要画的大小
    CGRect  rect = CGRectMake(0, 0, width, height);
    
    // 1. 开启图形上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    [self drawInRect:rect];
    
    // 3. 取到图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 5. 返回
    return image;
    
}


@end
