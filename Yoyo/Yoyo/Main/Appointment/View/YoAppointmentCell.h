//
//  YoAppointmentCell.h
//  Yoyo
//
//  Created by ning on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YoAppointmentCell;
@protocol YoAppointmentCellDelegate <NSObject>

- (void)YoAppointmentCell:(YoAppointmentCell *)cell didClickJoinBtn:(NSInteger)appointmentId;

@end
@interface YoAppointmentCell : UITableViewCell
@property(nonatomic, weak) id<YoAppointmentCellDelegate> delegate;
@property(nonatomic, strong) NSArray *picArray;
@property(nonatomic, copy) NSString *contentLabelString;

@end

NS_ASSUME_NONNULL_END
