//
//  YoMessageSettgingCell.h
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YoMessageSettgingCell;
@protocol YoMessageSettgingCellDelegate <NSObject>
@optional
- (void)settingCell:(YoMessageSettgingCell *)cell switchValueChage:(BOOL)on;
@end

@interface YoMessageSettgingCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, weak) id<YoMessageSettgingCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
