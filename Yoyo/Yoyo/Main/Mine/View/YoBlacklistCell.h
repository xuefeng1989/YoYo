//
//  YoBlacklistCell.h
//  Yoyo
//
//  Created by ningcol on 2019/7/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YoBlacklistModel, YoBlacklistCell;
@protocol YoBlacklistCellDelegate <NSObject>
- (void)blacklistCell:(YoBlacklistCell *)cell didClickCancelUserNo:(NSInteger)userNo;
@end

@interface YoBlacklistCell : UITableViewCell
@property(nonatomic, strong) YoBlacklistModel *model;
@property(nonatomic, weak) id<YoBlacklistCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
