//
//  YoPortraitPersonalCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YoDataItem,YoPortraitPersonalModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^YoCommentBlock)(YoPortraitPersonalModel *);
typedef void(^YoLikeBlock)(YoPortraitPersonalModel *);
typedef void(^YoCollectBlock)(YoPortraitPersonalModel *);
typedef void(^YoMoreBlock)(YoPortraitPersonalModel *);


@interface YoPortraitPersonalCell : UITableViewCell

@property (nonatomic, strong) YoDataItem *userInfo;
@property (nonatomic, strong) YoPortraitPersonalModel *model;
@property (nonatomic, copy) YoCommentBlock commentBlock;
@property (nonatomic, copy) YoLikeBlock likeBlock;
@property (nonatomic, copy) YoCollectBlock collectBlock;
@property (nonatomic, copy) YoMoreBlock moreBlock;


@end

NS_ASSUME_NONNULL_END
