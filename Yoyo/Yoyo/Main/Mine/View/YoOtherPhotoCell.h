//
//  YoOtherPhotoCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoMineUploadCollectionViewCell.h"
#import "YoImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@class YoOtherPhotoCell;

@protocol YoOtherPhotoCellDelegate <NSObject>

@optional
- (void)otherPhotoCell:(YoOtherPhotoCell *)cell didSelectedIndex:(NSInteger)index;

@end

@interface YoOtherPhotoCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<YoOtherPhotoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
