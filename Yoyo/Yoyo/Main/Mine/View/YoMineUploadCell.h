//
//  YoMineUploadCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoMineUploadCollectionViewCell.h"
#import "YoImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@class YoMineUploadCell;

@protocol YoMineUploadCellDelegate <NSObject>

- (void)mineUploadCell:(YoMineUploadCell *)cell DeleteIndex:(NSInteger)index;
- (void)mineUploadCell:(YoMineUploadCell *)cell setConfigIndex:(NSInteger)configIndex cellIndex:(NSInteger)cellIndex;
- (void)mineUploadCell:(YoMineUploadCell *)cell didSelectedIndex:(NSInteger)index;
- (void)mineUploadCellDidClickedAddPhotoView:(YoMineUploadCell *)cell;
@end

@interface YoMineUploadCell : UITableViewCell

@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *longTapLabel;
@property (nonatomic, strong) UILabel *tipLbel;

@property (nonatomic, strong) NSMutableArray<YoImageModel *> *dataArray;

@property (nonatomic, weak) id<YoMineUploadCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
