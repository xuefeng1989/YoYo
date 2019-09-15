//
//  YoPhotoViewController.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YoPhotoViewControllerDelegate <NSObject>
- (void)pageViewControllerLeaveTop;
@end
typedef void(^YoPhotoViewControllerBlock)(NSString * text);
@interface YoPhotoViewController : YoCommonViewController
@property (nonatomic, copy) YoPhotoViewControllerBlock block;
@property (nonatomic, weak) id<YoPhotoViewControllerDelegate> delegate;
- (void)makePageViewControllerScroll:(BOOL)canScroll;
- (void)makePageViewControllerScrollToTop;
@end

NS_ASSUME_NONNULL_END
