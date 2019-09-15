//
//  YoPortraitCommentModel.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoPortraitCommentModel : NSObject
/** 写真集id */
@property (nonatomic, copy) NSString *albumId;
/** 评论id */
@property (nonatomic, copy) NSString *ID;
/** 发表评论者id */
@property (nonatomic, copy) NSString *userNo;
/** 父级评论id */
@property (nonatomic, copy) NSString *parentId;
/** 被评论的人id */
@property (nonatomic, copy) NSString *targetUserId;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 评论时间 */
@property (nonatomic, copy) NSString *createTime;
/** 昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 评论内容 */
@property (nonatomic, copy) NSString *comment;
/** 评论点赞数 */
@property (nonatomic, assign) NSInteger thumbsUp ;
/** 是否点赞 */
@property (nonatomic, assign) BOOL isThumbsUp;
/** 头像 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 二级评论 */
@property (nonatomic, strong) NSArray<YoPortraitCommentModel *> *childrenList;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic,strong)NSNumber *likeCount;
@property (nonatomic,strong)NSNumber *replyId;
@end

NS_ASSUME_NONNULL_END
