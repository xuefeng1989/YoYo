//
//  YoMineUploadCollectionViewCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoMineUploadCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, assign) YoMineUploadCollectionViewCellType type;
@property (nonatomic,strong)YoImageModel *model;

@end

NS_ASSUME_NONNULL_END
