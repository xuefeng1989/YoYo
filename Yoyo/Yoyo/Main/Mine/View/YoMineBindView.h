//
//  YoMineBindView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN

@class YoMineBindView;
@protocol YoMineBindViewDelegate <NSObject>
- (void)bingView:(YoMineBindView *)view changedTextField:(QMUITextField *)textField;
@end
@interface YoMineBindView : UIView

@property (nonatomic, strong) QMUILabel *leftLabel;
@property (nonatomic, strong) QMUITextField *textField;
@property (nonatomic, strong) QMUIButton *rightButton;
@property(nonatomic, weak) id<YoMineBindViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
