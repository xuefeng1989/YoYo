//
//  YoAlbumService.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoAlbumType) {
    YoAlbumTypePraise = 1,  /// 点赞
    YoAlbumTypeCollect, /// 收藏
    YoAlbumTypeRelation,   /// 关注
    YoAlbumTypeCommentPraise, /// 评论的点赞
    YoAlbumTypeCreate,  /// 发布写真集
    YoAlbumTypePraiseCancel,  /// 取消点赞
    YoAlbumTypeCollectCancel, /// 取消收藏
    YoAlbumTypeRelationCancel,   /// 取消关注
    YoAlbumTypeCommentPraiseCancel, /// 取消评论的点赞
};

@interface YoAlbumService : BaseRequestService
- (instancetype)initWithPushContent:(NSString *)pushContent images:(NSArray*)images type:(YoAlbumType)type;
- (instancetype)initWithAlbumId:(NSString *)albumId authorId:(NSString *)authorId sendType:(YoAlbumType)type;

@end

NS_ASSUME_NONNULL_END
