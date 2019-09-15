//
//  YoImageModel.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YoMineUploadCollectionViewCellType) {
    YoMineUploadCollectionViewCellTypeNormal = 0,
    YoMineUploadCollectionViewCellTypeFire,//阅后即焚
    YoMineUploadCollectionViewCellTypePay,//付费
    YoMineUploadCollectionViewCellTypeFireReaded,//阅后即焚销毁
    YoMineUploadCollectionViewCellTypePayed,//付费 购买
    YoMineUploadCollectionViewCellTypeMore,//查看更多
    YoMineUploadCollectionViewCellTypeUpload,
    YoMineUploadCollectionViewCellTypeInviteUpload,//邀请上传
};

NS_ASSUME_NONNULL_BEGIN

@interface YoImageModel : NSObject
@property (nonatomic, assign) YoMineUploadCollectionViewCellType imageType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *imageId;
- (instancetype)initWithType:(YoMineUploadCollectionViewCellType)type photo:(UIImage *)photo imageUrl:(NSString *)imageUrl;
@end

NS_ASSUME_NONNULL_END
