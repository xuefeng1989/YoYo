//
//  YoPortraitPersonalModel.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface YoPortraitPersonalPictureModel  : NSObject
@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) BOOL first;
@property (nonatomic,retain)NSNumber * height;
@property (nonatomic,retain)NSNumber * width;
@property (nonatomic, copy) NSString * picture;
@property (nonatomic, copy) NSArray *tags;
@end


@interface YoPortraitPersonalModel : NSObject
@property (nonatomic, assign) BOOL praise;

@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, assign) BOOL collect;

@property (nonatomic, retain) NSNumber * countAlbumComment;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger heatNum;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) BOOL isFocus;
@property (nonatomic, assign) BOOL isAlreadMore;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL like;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSNumber *countAlbumLike;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *albumId;// id
@property (nonatomic, retain) NSNumber *likeCount;//喜欢
@property (nonatomic, retain) NSNumber *spaceId;
@property (nonatomic, retain) NSNumber *userNo;
@property (nonatomic, copy) NSArray<YoPortraitPersonalPictureModel *> *pictures;
@end

NS_ASSUME_NONNULL_END
