//
//  UIImageView+Extension.m
//  QiJi
//
//  Created by ningcol on 9/8/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

-(void)getHexagonImageViewWithLineWidth:(CGFloat)lineWidth Side:(NSInteger)sides CornerRadius:(CGFloat)cornerRadius RotationOffset:(CGFloat)rotationOffset{
    
    CGRect rect = self.bounds;
    
    UIBezierPath*path = [[UIBezierPath alloc]init];
    CGFloat theta = (CGFloat)2*M_PI/(CGFloat)sides;//多边形外角和2π  这里得到的每条边转的角度。这里是60度
    //    CGFloat offset = cornerRadius * tan(theta / 2.0);
    CGFloat width = rect.size.width<rect.size.height?rect.size.height:rect.size.width;
    CGPoint center = CGPointMake( width / 2.0, width / 2.0);
    CGFloat radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0;
    CGFloat angle = rotationOffset;
    CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
    [path moveToPoint:CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta))];
    
    for (int i =0; i<sides; i++) {
        angle += theta;
        CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
        CGPoint tip = CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
        CGPoint start = CGPointMake(corner.x + cornerRadius * cos(angle - theta), corner.y + cornerRadius * sin(angle - theta));
        CGPoint end = CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta));
        [path addLineToPoint:start];
        [path addQuadCurveToPoint:end controlPoint:tip];
        
    }
    
    [path closePath];
    
    CGRect bounds = path.bounds;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-bounds.origin.x + rect.origin.x + lineWidth / 2.0, -bounds.origin.y + rect.origin.y + lineWidth / 2.0);
    [path applyTransform:transform];
    
    //
    
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    mask.lineWidth       = lineWidth;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
    self.layer.mask = mask;
    //
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path          = path.CGPath;
    border.lineWidth     = lineWidth;
    border.strokeColor   = [UIColor whiteColor].CGColor;
    border.fillColor     = [UIColor clearColor].CGColor;
    [self.layer addSublayer:border];
    
}

@end
