//
//  YoNewDetailViewController.h
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonTableViewController.h"

#import "YoNewsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoNewDetailViewController : YoCommonTableViewController
@property(nonatomic, assign) YoNewsType newsType;
@end

NS_ASSUME_NONNULL_END
