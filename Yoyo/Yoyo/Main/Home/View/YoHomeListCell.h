//
//  YoHomeListCell.h
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YoHomeListModel;
@interface YoHomeListCell : UITableViewCell

@property(nonatomic, strong) NSString *data;
@property(nonatomic, strong) YoHomeListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
