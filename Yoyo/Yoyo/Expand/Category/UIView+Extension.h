//
//  UIView+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameBottom;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
- (BOOL) containsSubView:(UIView *)subView;
- (BOOL) containsSubViewOfClassType:(Class)aClass;



+ (void) addMJNotifierWithText : (NSString* ) text dismissAutomatically : (BOOL) shouldDismiss;
+ (void) dismissMJNotifier;

@end
