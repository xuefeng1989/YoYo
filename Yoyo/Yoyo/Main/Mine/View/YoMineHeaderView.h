//
//  YoMineHeaderView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/5/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Const.h"

NS_ASSUME_NONNULL_BEGIN
@class YoMineHeaderModel;
@interface YoMineHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame isSelf:(BOOL)isSelf;
/// 头像imageView
@property (nonatomic, strong) UIImageView *backImageView;
@property(nonatomic, strong) UIView *maskView;
// 关注按钮
@property(nonatomic, strong) QMUIGhostButton *focusBtn;


@property(nonatomic, assign) CGFloat offset;
@property(nonatomic, assign) CGFloat ya;

@property(nonatomic, strong) YoMineHeaderModel *model;




@end

NS_ASSUME_NONNULL_END
