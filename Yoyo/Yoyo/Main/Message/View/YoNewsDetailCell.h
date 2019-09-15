//
//  YoNewsDetailCell.h
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YoNewsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YoNewsDetailCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, assign) YoNewsType type;
@property(nonatomic, strong) YoNewsDetailModel *model;

@end

NS_ASSUME_NONNULL_END
