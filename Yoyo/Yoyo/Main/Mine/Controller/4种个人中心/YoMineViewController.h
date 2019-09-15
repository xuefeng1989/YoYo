//
//  YoMineViewController.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonViewController.h"
#import "GKPhotoBrowser.h"

typedef NS_ENUM(NSUInteger, YoMineViewControllerType) {
    YoMineViewControllerTypeMineAndSexTypeMale = 0,
    YoMineViewControllerTypeMineAndSexTypeFemale,
    YoMineViewControllerTypeOtherAndSexTypeMale,
    YoMineViewControllerTypeOtherAndSexTypeFemale,
};
NS_ASSUME_NONNULL_BEGIN

@interface YoMineViewController : YoCommonViewController

- (instancetype)initWithType:(YoMineViewControllerType)type;
- (void)goToauthenticate;
@end

NS_ASSUME_NONNULL_END
