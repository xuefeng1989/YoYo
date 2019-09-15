//
//  YoMineMemberView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoConfigVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoMineMemberView : UIView

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *sepV;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) YoConfigVipModel *model;
@end

NS_ASSUME_NONNULL_END
