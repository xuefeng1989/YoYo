//
//  UIImageView+Extension.h
//  QiJi
//
//  Created by ningcol on 9/8/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)


/**
 *  裁剪六边形
 *
 *  @param lineWidth      边框宽度
 *  @param sides          几条边
 *  @param cornerRadius   弧度
 *  @param rotationOffset 旋转角度
 */
-(void)getHexagonImageViewWithLineWidth:(CGFloat)lineWidth Side:(NSInteger)sides CornerRadius:(CGFloat)cornerRadius RotationOffset:(CGFloat)rotationOffset;
@end
