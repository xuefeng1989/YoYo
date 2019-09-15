//
//  UIView+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NOTIFIER_LABEL_FONT ([UIFont fontWithName:@"HelveticaNeue-Light" size:18])
#define NOTIFIER_CANCEL_FONT ([UIFont fontWithName:@"HelveticaNeue" size:13])

static const NSInteger kTagMJAlertView = 1812;
static const NSInteger xPadding = 18.0;
static const CGFloat kLabelHeight = 45.0f;
static const CGFloat kCancelButtonHeight = 30.0f;
static const CGFloat kSeparatorHeight = 1.0f;
static const CGFloat kHeightFromBottom = 70.f;
static const CGFloat kMaxWidth = 290.0f;



@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}








-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}


-(BOOL) containsSubViewOfClassType:(Class)aClass
{
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:aClass]) {
            return YES;
        }
    }
    return NO;
}




/**
 *  X
 */
-(CGFloat) originX
{
    return self.frame.origin.x;
}

-(void) setOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}


/**
 *  Y
 */

-(CGFloat)originY
{
    return self.frame.origin.y;
}

-(void)setOriginY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
}


/**
 *  右
 */

-(CGFloat)frameRight
{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setFrameRight:(CGFloat)newRight
{
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

/**
 *  底
 */
-(CGFloat)frameBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setFrameBottom:(CGFloat)newBottom
{
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

/**
 *  宽
 */
-(CGFloat)frameWidth
{
    return self.frame.size.width;
}

-(void)setFrameWidth:(CGFloat)newWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

/**
 *  高
 */

-(CGFloat)frameHeight
{
    return self.frame.size.height;
}

-(void)setFrameHeight:(CGFloat)newHeight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}


/*****************************************************************************************/

+ (void) addMJNotifierWithText : (NSString* ) text dismissAutomatically : (BOOL) shouldDismiss {
    //get screen area
    CGRect screenBounds = APPDELEGATE.window.bounds;
    
    //get width for given text
    NSDictionary *attributeDict = @{NSFontAttributeName : NOTIFIER_LABEL_FONT};
    CGFloat height = kLabelHeight;
    CGFloat width = CGFLOAT_MAX;
    CGRect notifierRect = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:NULL];
    
    //get xoffset width for the notifier view
    CGFloat notifierWidth = MIN(CGRectGetWidth(notifierRect) + 2*xPadding, kMaxWidth);
    CGFloat xOffset = (CGRectGetWidth(screenBounds) - notifierWidth)/2;
    
    //get height for notifier view.. Add cancel button height if not dismissing automatically
    NSInteger notifierHeight = kLabelHeight;
    if(!shouldDismiss) {
        notifierHeight += (kCancelButtonHeight+kSeparatorHeight);
    }
    
    //get yOffset for notifier view
    CGFloat yOffset = CGRectGetHeight(screenBounds) - notifierHeight - kHeightFromBottom;
    
    CGRect finalFrame = CGRectMake(xOffset, yOffset, notifierWidth, notifierHeight);
    
    UIView* notifierView = [self checkIfNotifierExistsAlready];
    if(notifierView) {
        //update the existing notification here
        [self updateNotifierWithAnimation:notifierView withText:text completion:^(BOOL finished) {
            CGRect atLastFrame = finalFrame;
            atLastFrame.origin.y = finalFrame.origin.y + 8;
            notifierView.frame = atLastFrame;
            
            //get the label and update its text and frame!
            UILabel* textLabel = nil;
            for (UIView* subview in notifierView.subviews) {
                if([subview isKindOfClass:[UILabel class]]) {
                    textLabel = (UILabel* ) subview;
                }
                
                //also remove separator and "cancel" button.. we may add it later if necessary
                if([subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UIButton class]]) {
                    [subview removeFromSuperview];
                }
            }
            textLabel.text = text;
            textLabel.frame = CGRectMake(xPadding, 0.0, notifierWidth - 2*xPadding, kLabelHeight);
            
            //if not dismissing
            if(!shouldDismiss) {
                //first show a separator
                UIImageView* separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(textLabel.frame), CGRectGetWidth(notifierView.frame), kSeparatorHeight)];
                [separatorImageView setBackgroundColor:UIColorFromRGB(0xF94137)];
                [notifierView addSubview:separatorImageView];
                
                //now add that cancel button
                UIButton* buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonCancel.frame = CGRectMake(0.0, CGRectGetMaxY(separatorImageView.frame), CGRectGetWidth(notifierView.frame), kCancelButtonHeight);
                [buttonCancel setBackgroundColor:UIColorFromRGB(0x000000)];
                [buttonCancel addTarget:self action:@selector(buttonCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
                [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
                buttonCancel.titleLabel.font = NOTIFIER_CANCEL_FONT;
                [notifierView addSubview:buttonCancel];
            }
            
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                notifierView.alpha = 1;
                notifierView.frame = finalFrame;
            } completion:^(BOOL finished) {
            }];
        }];
        
        if(shouldDismiss) {
            [self performSelector:@selector(dismissMJNotifier) withObject:nil afterDelay:2.0];
        }
    }
    else {
        notifierView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, CGRectGetHeight(screenBounds), notifierWidth, notifierHeight)];
        //notifierView.backgroundColor = UIColorFromRGB(0xF94137);
        notifierView.backgroundColor = [UIColor whiteColor];
        notifierView.tag = kTagMJAlertView;
        notifierView.clipsToBounds = YES;
        notifierView.layer.cornerRadius = 5.0;
        [APPDELEGATE.window addSubview:notifierView];
        [APPDELEGATE.window bringSubviewToFront:notifierView];
        
        //create label which holds text inside the notifier view
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, 0.0, notifierWidth - 2*xPadding, kLabelHeight)];
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        //textLabel.textColor = UIColorFromRGB(0xFFFFFF);
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = NOTIFIER_LABEL_FONT;
        textLabel.minimumScaleFactor = 0.7;
        textLabel.text = text;
        [notifierView addSubview:textLabel];
        
        if(shouldDismiss) {
            [self performSelector:@selector(dismissMJNotifier) withObject:nil afterDelay:2.0];
        }
        else {
            //not dismissng automatically... show cancel button to dismiss this alert
            
            //first show a separator
            UIImageView* separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(textLabel.frame), notifierWidth, kSeparatorHeight)];
            [separatorImageView setBackgroundColor:UIColorFromRGB(0xF94137)];
            [notifierView addSubview:separatorImageView];
            
            //now add that cancel button
            UIButton* buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonCancel.frame = CGRectMake(0.0, CGRectGetMaxY(separatorImageView.frame), notifierWidth, kCancelButtonHeight);
            [buttonCancel setBackgroundColor:UIColorFromRGB(0x000000)];
            [buttonCancel addTarget:self action:@selector(buttonCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            buttonCancel.titleLabel.font = NOTIFIER_CANCEL_FONT;
            [notifierView addSubview:buttonCancel];
        }
        
        [self startEntryAnimation:notifierView withFinalFrame:finalFrame];
    }
}

+ (UIView* ) checkIfNotifierExistsAlready {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissMJNotifier) object:nil];
    
    UIView* notifier = nil;
    for (UIView* subview in [APPDELEGATE.window subviews]) {
        if(subview.tag == kTagMJAlertView && [subview isKindOfClass:[UIView class]]) {
            notifier = subview;
        }
    }
    
    return notifier;
}

+ (void) dismissMJNotifier {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissMJNotifier) object:nil];
    
    UIView* notifier = nil;
    
    for (UIView* subview in [APPDELEGATE.window subviews]) {
        if(subview.tag == kTagMJAlertView && [subview isKindOfClass:[UIView class]]) {
            notifier = subview;
        }
    }
    
    [self startExitAnimation:notifier];
}

+ (void) buttonCancelClicked : (id) sender {
    [self dismissMJNotifier];
}

#pragma mark - Animation part
+ (void) updateNotifierWithAnimation : (UIView* ) notifierView withText : (NSString* ) text completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = notifierView.frame;
    finalFrame.origin.y = finalFrame.origin.y + 8;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        notifierView.alpha = 0;
        notifierView.frame = finalFrame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void) startEntryAnimation : (UIView* ) notifierView withFinalFrame : (CGRect) finalFrame {
    
    CGFloat finalYOffset = finalFrame.origin.y;
    finalFrame.origin.y = finalFrame.origin.y - 15;
    
    CATransform3D transform = [self transformWithXAxisValue:-0.1 andAngle:45];
    notifierView.layer.zPosition = 400;
    notifierView.layer.transform = transform;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        notifierView.frame = finalFrame;
        
        CATransform3D transform = [self transformWithXAxisValue:0.1 andAngle:15];
        notifierView.layer.zPosition = 400;
        notifierView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect atLastFrame = finalFrame;
            atLastFrame.origin.y = finalYOffset;
            notifierView.frame = atLastFrame;
            
            CATransform3D transform = [self transformWithXAxisValue:0.0 andAngle:90];
            notifierView.layer.zPosition = 400;
            notifierView.layer.transform = transform;
            
        } completion:^(BOOL finished) {
        }];
    }];
}

+ (void) startExitAnimation : (UIView* ) notifierView {
    
    //get screen area
    CGRect screenBounds = APPDELEGATE.window.bounds;
    
    CGRect notifierFrame = notifierView.frame;
    CGFloat finalYOffset = notifierFrame.origin.y - 12;
    notifierFrame.origin.y = finalYOffset;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        notifierView.frame = notifierFrame;
        
        CATransform3D transform = [self transformWithXAxisValue:0.1 andAngle:30];
        notifierView.layer.zPosition = 400;
        notifierView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect atLastFrame = notifierView.frame;
            atLastFrame.origin.y = CGRectGetHeight(screenBounds);
            notifierView.frame = atLastFrame;
            
            CATransform3D transform = [self transformWithXAxisValue:-1 andAngle:90];
            notifierView.layer.zPosition = 400;
            notifierView.layer.transform = transform;
            
        } completion:^(BOOL finished) {
            [notifierView removeFromSuperview];
        }];
    }];
}

+ (CATransform3D) transformWithXAxisValue : (CGFloat) xValue  andAngle : (CGFloat) valueOfAngle {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1000;
    //this would rotate object on an axis of x = 0, y = 1, z = -0.3f. It is "Z" here which would
    transform = CATransform3DRotate(transform, valueOfAngle * M_PI / 180.0f, xValue, 0.0, 0.);
    return transform;
}

@end