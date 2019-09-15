//
//  YoPortraitAddTagController.h
//  Yoyo
//
//  Created by yunxin bai on 2019/7/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YoPortraitAddTagControllerBlock)(NSString *title);

@interface YoPortraitAddTagController : YoCommonViewController

@property (nonatomic, copy) YoPortraitAddTagControllerBlock block;

@end

NS_ASSUME_NONNULL_END
