//
//  YoOtherPhotoCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherPhotoCell.h"
#import "Const.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface YoOtherPhotoCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIVisualEffectView *blurEffect;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation YoOtherPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(RatioZoom(15));
            make.bottom.right.mas_equalTo(-RatioZoom(15));
        }];
        
        [self.contentView addSubview:self.blurEffect];
        [self.blurEffect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegate and Datasource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoMineUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    YoImageModel *model = self.dataArray[indexPath.row];
    if (model.imageType != YoMineUploadCollectionViewCellTypeInviteUpload) {
        if (model.photo && model.photo.length > 0) {
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
        }else{
            [cell.imageV setImage:model.image];
        }
    }else{
        
    }
    cell.type = model.imageType;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(otherPhotoCell:didSelectedIndex:)]) {
        [self.delegate otherPhotoCell:self didSelectedIndex:indexPath.row];
    }
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
        
    }
    return _collectionView;
}
@end
