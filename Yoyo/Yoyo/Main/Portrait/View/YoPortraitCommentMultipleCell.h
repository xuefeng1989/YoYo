//
//  YoPortraitCommentMultipleCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YoPortraitCommentModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^YoPortraitCommentMultipleCellBlock)(YoPortraitCommentModel *);

@interface YoPortraitCommentMultipleCell : UITableViewCell

@property (nonatomic, strong) YoPortraitCommentModel *model;

@property (nonatomic, copy) YoPortraitCommentMultipleCellBlock moreBlock;

@end

NS_ASSUME_NONNULL_END
