//
//  YoNewsCell.h
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoNewsCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *logoName;

@end

NS_ASSUME_NONNULL_END
