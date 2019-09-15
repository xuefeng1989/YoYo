//
//  UIView+Recognizer.h
//  demo
//
//  Created by guzhichao on 2019/8/31.
//  Copyright © 2019 谷志超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^WhenTappedBlock)();
@interface UIView (Recognizer)
- (void)whenTapped:(WhenTappedBlock)block;
- (void)whenTwoFingerTapped:(WhenTappedBlock)block;
@end

NS_ASSUME_NONNULL_END

