//
//  YoPortraitCommentNormalCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YoPortraitCommentModel;
typedef void(^YoPortraitCommentNormalCellBlock)(YoPortraitCommentModel *);
typedef void(^YoLikeBlock)(YoPortraitCommentModel *);
NS_ASSUME_NONNULL_BEGIN

@interface YoPortraitCommentNormalCell : UITableViewCell

@property (nonatomic, strong) YoPortraitCommentModel *model;
@property (nonatomic, copy) YoPortraitCommentNormalCellBlock moreBlock;
@property (nonatomic, copy) YoLikeBlock likeBlock;
@end

NS_ASSUME_NONNULL_END
