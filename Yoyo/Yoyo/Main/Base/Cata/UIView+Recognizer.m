//
//  UIView+Recognizer.m
//  demo
//
//  Created by guzhichao on 2019/8/31.
//  Copyright © 2019 谷志超. All rights reserved.
//

#import "UIView+Recognizer.h"
#import <objc/runtime.h>
@interface UIView (Recognizer_private) <UIGestureRecognizerDelegate>

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(WhenTappedBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger) taps touches:(NSUInteger) touches selector:(SEL) selector;
- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer;
- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer;

@end
@implementation UIView (Recognizer)
static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

#pragma mark -
#pragma mark Set blocks

- (void)runBlockForKey:(void *)blockKey {
    WhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block();
}

- (void)setBlock:(WhenTappedBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark -
#pragma mark When Tapped

- (void)whenTapped:(WhenTappedBlock)block {
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    [self addRequiredToDoubleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}
/*
 - (void)whenDoubleTapped:(WhenTappedBlock)block {
 UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
 [self addRequirementToSingleTapsRecognizer:gesture];
 
 [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
 }*/

- (void)whenTwoFingerTapped:(WhenTappedBlock)block {
    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
    
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}
/*
 - (void)whenTouchedDown:(WhenTappedBlock)block {
 [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
 }
 
 - (void)whenTouchedUp:(WhenTappedBlock)block {
 [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
 }*/

#pragma mark -
#pragma mark Callbacks

- (void)viewWasTapped {
    [self runBlockForKey:&kWhenTappedBlockKey];
}

- (void)viewWasDoubleTapped {
    [self runBlockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)viewWasTwoFingerTapped {
    [self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
}

#pragma mark -
#pragma mark Helpers

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}
@end
