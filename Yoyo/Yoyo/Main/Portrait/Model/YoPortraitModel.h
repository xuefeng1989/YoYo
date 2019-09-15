//
//  YoPortraitModel.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoImageModelIcon : NSObject

@property (nonatomic, assign) CGFloat imgWidth;
@property (nonatomic, assign) CGFloat imgHight;
@property (nonatomic, copy) NSString *url;

@end

@interface YoPortraitModel : NSObject

@property (nonatomic, strong) YoImageModelIcon *lastOneInstagram;
@property (nonatomic, assign) NSNumber *hot;
@property (nonatomic, assign) NSNumber *lng; //经度
@property (nonatomic, assign) NSNumber *lat; //纬度
/** 写真集id */
@property (nonatomic, copy) NSString *albumId;
/** 用户昵称 */
@property (nonatomic, copy) NSString *userName;
/** 作者ID */
@property (nonatomic, copy) NSString *userNo;
/** 作者头像 */
@property (nonatomic, copy) NSString *avatar;
/** 最近一张写真集标签 */
@property (nonatomic, copy) NSString *imageTags;
/** 最近一张写真集url */
@property (nonatomic, copy) NSString *picture;
/** 约会状态（0不可约 1可约 2在国外 3看礼物 4高素质） */
@property (nonatomic, assign) NSInteger datingStatus;
@property (nonatomic, copy) NSString *datingStatusString;
/** 发布内容 */
@property (nonatomic, copy) NSString *pushContent;
/** 距离 */
@property (nonatomic, copy) NSString *gap;
/** 点赞数 */
@property (nonatomic, assign) NSInteger praiseNum;
/** 收藏数 */
@property (nonatomic, assign) NSInteger collectNum;
/** 评论数 */
@property (nonatomic, assign) NSInteger commentNum;
/** 关注作者总人数 */
@property (nonatomic, assign) NSInteger relationNum;
/** 打赏写真集的云币总数 */
@property (nonatomic, assign) NSInteger totalBit;
/** 是否已关注作者 */
@property (nonatomic, assign) BOOL care;
/** 发布时间 */
@property (nonatomic, copy) NSString *createTime;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/// 是否点赞
@property (nonatomic, assign) BOOL isPraise;
/// 是否收藏
@property (nonatomic, assign) BOOL isCollect;

/// 图片c尺寸
@property (nonatomic, assign) CGSize imgSize;
@property (nonatomic,retain)NSNumber * height;
@property (nonatomic,retain)NSNumber * width;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double latitude;
@end

NS_ASSUME_NONNULL_END
