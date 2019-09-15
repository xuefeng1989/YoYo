//
//  YoPortraitCommentService.h
//  Yoyo
//
//  Created by yunxin bai on 2019/7/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

typedef NS_ENUM(NSUInteger, YoPortraitCommentServiceType) {
    YoPortraitCommentServiceTypeGetList = 1,  // 获取评论列表
    YoPortraitCommentServiceTypeCreate,  // 发布写真集
};

NS_ASSUME_NONNULL_BEGIN

@interface YoPortraitCommentService : BaseRequestService
- (instancetype)initWithAlbumId:(NSString *)albumId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(YoPortraitCommentServiceType)type;
- (instancetype)initWithAlbumId:(NSString *)albumId targetUserId:(NSString *)targetUserId comment:(NSString *)comment parentId:(NSString *)parentId type:(YoPortraitCommentServiceType)type;
@end

NS_ASSUME_NONNULL_END
