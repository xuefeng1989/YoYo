//
//  YoConversationCell.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "IConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoConversationCell : UITableViewCell

//@property(nonatomic, strong) id<IConversationModel> model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
