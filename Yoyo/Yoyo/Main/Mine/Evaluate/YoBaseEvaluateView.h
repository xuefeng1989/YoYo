//
//  YoBaseEvaluateView.h
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YoBaseEvaluateViewDelegate <NSObject>
- (void)YoBaseEvaluateViewSelectedEvaluateTagArray:(NSArray *)array;
@end


@interface YoBaseEvaluateView : UIView
@property(nonatomic, copy) NSString *nicknameString;
@property(nonatomic, copy) NSString *titleString;
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) NSArray *dataArray;
/// 是否展示评价按钮
@property(nonatomic, assign) BOOL isShowEvaluateBtn;

@property(nonatomic, weak) id<YoBaseEvaluateViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
