//
//  YoHomeBaseTableViewController.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"
#import "HomeListService.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoHomeBaseTableViewController : YoCommonTableViewController
@property (nonatomic, assign)YoHomeType listDataType;
@end

NS_ASSUME_NONNULL_END
