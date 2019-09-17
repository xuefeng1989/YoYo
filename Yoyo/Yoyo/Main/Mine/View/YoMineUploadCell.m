//
//  YoMineUploadCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineUploadCell.h"
#import "Const.h"
#import <Masonry.h>
#import "YoMinePhotoPickerView.h"
#import <UIImageView+WebCache.h>

@interface YoMineUploadCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) YoMinePhotoPickerView *pickerView;

@end

@implementation YoMineUploadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.tipLbel];
        [self.tipLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(-RatioZoom(10));
        }];
        
        [self.contentView addSubview:self.longTapLabel];
        [self.longTapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.tipLbel.mas_top).offset(-RatioZoom(10));
        }];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(RatioZoom(15));
            make.right.mas_equalTo(-RatioZoom(15));
            make.bottom.mas_equalTo(self.longTapLabel.mas_top).offset(-RatioZoom(20));
        }];
        
        [self.contentView addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.longTapLabel.mas_top).offset(-RatioZoom(20));
        }];

    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (dataArray.count == 1) {
        self.emptyView.hidden = NO;
        self.collectionView.hidden = YES;
        self.longTapLabel.text = @"上传我的第一张照片";
        self.tipLbel.text = @"照片可以让女士对派对更有安全感哦";
        
    } else {
        self.emptyView.hidden = YES;
        self.collectionView.hidden = NO;
        self.longTapLabel.text = @"长按照片设置照片";
        self.tipLbel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
    }
    [self.collectionView reloadData];
}

#pragma mark - method
- (void)addPhoto {
    if ([self.delegate respondsToSelector:@selector(mineUploadCellDidClickedAddPhotoView:)]) {
        [self.delegate mineUploadCellDidClickedAddPhotoView:self];
    }
}

#pragma mark - UICollectionView Delegate and Datasource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoMineUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    YoImageModel *model = self.dataArray[indexPath.row];
    cell.isSelf = YES;
    cell.model = model;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mineUploadCell:didSelectedIndex:)]) {
        [self.delegate mineUploadCell:self didSelectedIndex:indexPath.row];
    }
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p=[gestureRecognizer locationInView:self.collectionView];
    NSIndexPath*indexPath =[self.collectionView indexPathForItemAtPoint:p];
    YoImageModel *model = self.dataArray[indexPath.row];
    if(indexPath == nil || model.imageType == YoMineUploadCollectionViewCellTypeMore || model.imageType == YoMineUploadCollectionViewCellTypeUpload ){
        JSLogInfo(@"couldn't find index path");
    }else{
        __weak __typeof(self)weakSelf = self;
        if (model.imageType == YoMineUploadCollectionViewCellTypeFire) {
            [self.pickerView setSelectIndex:1];
        }else if (model.imageType == YoMineUploadCollectionViewCellTypeNormal){
            [self.pickerView setSelectIndex:0];
        }else if (model.imageType == YoMineUploadCollectionViewCellTypePay){
            [self.pickerView setSelectIndex:2];
        }
        [self.pickerView show];
        self.pickerView.commitBlock = ^(NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(mineUploadCell:setConfigIndex:cellIndex:)]) {
                [weakSelf.delegate mineUploadCell:weakSelf setConfigIndex:index cellIndex:indexPath.row];
            }
        };
        self.pickerView.deleteBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(mineUploadCell:DeleteIndex:)]) {
                [weakSelf.delegate mineUploadCell:weakSelf DeleteIndex:indexPath.row];
            }
        };
    }
}
#pragma mark - lazy load
- (UIImageView *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIImageView new];
        _emptyView.image = [UIImage imageNamed:@"mine_photo_white_add"];
        _emptyView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto)];
        [_emptyView addGestureRecognizer:tap];
    }
    return _emptyView;
}


- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = RatioZoom(4);
        layout.minimumInteritemSpacing = RatioZoom(4);
        CGFloat width = (SCREEN_WIDTH-RatioZoom(45))/4;
        CGFloat height = width;
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YoMineUploadCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
        
        UILongPressGestureRecognizer *longPressGr =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        longPressGr.minimumPressDuration=1.0;
//        longPressGr.delaysTouchesBegan=YES;
        [_collectionView addGestureRecognizer:longPressGr];

    }
    return _collectionView;
}

- (UILabel *)longTapLabel {
    if (!_longTapLabel) {
        _longTapLabel = [UILabel new];
        _longTapLabel.textColor = UIColorGlobal;
        _longTapLabel.font = UIFontMake(13);
        _longTapLabel.text = @"长按照片设置照片";
    }
    return _longTapLabel;
}

- (UILabel *)tipLbel {
    if (!_tipLbel) {
        _tipLbel = [UILabel new];
        _tipLbel.textColor = UIColorSUBContentFont;
        _tipLbel.font = UIFontMake(11);
        _tipLbel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
    }
    return _tipLbel;
}

- (YoMinePhotoPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[YoMinePhotoPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _pickerView;
}
@end
