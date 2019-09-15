//
//  YoPublishPickerCell.h
//  Yoyo
//
//  Created by ning on 2019/6/23.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YoPublishPickerCell,QMUILabel;
@protocol YoPublishPickerCellDelegate <NSObject>

- (void)YoPublishPickerCell:(YoPublishPickerCell *)cell didClickEvent:(QMUILabel *)contentLabel;

@end

@interface YoPublishPickerCell : UIView

@property(nonatomic, weak) id<YoPublishPickerCellDelegate> delegate;
@property(nonatomic, copy) NSString *titleString;
@property(nonatomic, copy) NSString *contentString;
/// 隐藏分割线
@property(nonatomic, assign) BOOL hiddenSeparator;

@end

NS_ASSUME_NONNULL_END
