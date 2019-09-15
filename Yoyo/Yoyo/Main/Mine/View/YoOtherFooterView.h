//
//  YoOtherFooterView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoOtherFooterView : UIView

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *relationButton;
@property (nonatomic, strong) UILabel *tipLabel;
/// 是否隐藏联系方式按钮
@property(nonatomic, assign) BOOL isHiddenRelationButton;
@end

NS_ASSUME_NONNULL_END
