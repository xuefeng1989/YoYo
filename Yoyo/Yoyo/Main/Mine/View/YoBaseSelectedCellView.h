//
//  YoBaseSelectedCellView.h
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN

@class YoBaseSelectedCellView;
@protocol YoBaseSelectedCellViewDelegate <NSObject>
- (void)YoBaseSelectedCellView:(YoBaseSelectedCellView *)view didSelect:(BOOL)selected;
@end

@interface YoBaseSelectedCellView : UIView
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, assign, readwrite) BOOL selected;
@property(nonatomic, weak) id<YoBaseSelectedCellViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
