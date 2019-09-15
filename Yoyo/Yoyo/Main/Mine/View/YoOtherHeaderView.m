//
//  YoOtherHeaderView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherHeaderView.h"
#import "Const.h"
#import <Masonry.h>

@interface YoOtherHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *locationLabel;
@property (nonatomic, strong) QMUILabel *distanceLabel;
@property (nonatomic, strong) QMUILabel *dateLabel;
@property (nonatomic, strong) QMUIButton *authButton;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIImageView *corImageView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YoOtherHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backImageView];
        [self addSubview:self.avatarImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
        
//        [self.backImageView addSubview:self.backButton];
//        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(RatioZoom(15));
//            make.top.mas_equalTo(RatioZoom(35));
//        }];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(15));
            make.top.mas_equalTo(NORMAL_Y);
            make.width.mas_equalTo(RatioZoom(70));
            make.height.mas_equalTo(RatioZoom(70));
        }];
        
        [self.backImageView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(RatioZoom(15));
            make.top.mas_equalTo(self.avatarImageView);
        }];
        
        [self.backImageView addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backImageView).offset(-RatioZoom(15));
            make.centerY.mas_equalTo(self.nameLabel);
        }];
        
        [self.backImageView addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(RatioZoom(15));
        }];
        
        [self.backImageView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(RatioZoom(10));
        }];
        
        [self.backImageView addSubview:self.sepView];
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(RatioZoom(15));
            make.right.mas_equalTo(self.backImageView);
            make.height.mas_equalTo(1);
        }];
        
        [self.backImageView addSubview:self.authButton];
        [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.sepView.mas_bottom).offset(RatioZoom(15));
        }];
        
        [self.backImageView addSubview:self.corImageView];
        [self.corImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(self.backImageView);
            make.bottom.mas_equalTo(self.backImageView);
        }];
        
        [self.corImageView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.corImageView).offset(RatioZoom(20));
            make.left.mas_equalTo(self.corImageView).offset(RatioZoom(15));
            make.right.mas_equalTo(self.corImageView).offset(-RatioZoom(15));
            make.bottom.mas_equalTo(self.corImageView).offset(-RatioZoom(20));
        }];
        
        [self calculatorHeight];

        
    }
    return self;
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self calculatorHeight];
    [self.collectionView reloadData];
}

- (void)calculatorHeight {
    CGFloat h = RatioZoom(130);
    if(self.dataArray.count > 4) {
        h = RatioZoom(210);
    }
    UIImage *image = [UIImage qmui_imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, h) cornerRadiusArray:@[@(20), @(0), @(0), @(20)]];
    self.corImageView.image = image;
    
    
    [self.corImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
        make.left.right.mas_equalTo(self.backImageView);
        make.bottom.mas_equalTo(self.backImageView);
    }];
}

#pragma mark - UICollectionView Delegate and Datasource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoMineUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    YoOtherHeaderViewModel *model = self.dataArray[indexPath.row];
    cell.type = model.imageType;
    cell.imageV.image = model.photo;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(otherHeaderView:didClickedIndex:)]) {
        [self.delegate otherHeaderView:self didClickedIndex:indexPath.row];
    }
}

#pragma mark - lazy load

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        //        _backImageView.image = [UIImage imageNamed:@"index_background"];
        _backImageView.backgroundColor = UIColorGlobal;
        _backImageView.userInteractionEnabled = YES;

    }
    return _backImageView;
}

- (QMUIButton *)backButton {
    if (!_backButton) {
        _backButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = RatioZoom(35);
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (QMUILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [QMUILabel new];
        _nameLabel.text = @"慕言";
        _nameLabel.font = UIFontMake(20);
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (QMUILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [QMUILabel new];
        _distanceLabel.text = @"1.1km 当前在线";
        _distanceLabel.font = UIFontMake(11);
        _distanceLabel.textColor = [UIColor whiteColor];
    }
    return _distanceLabel;
}

- (QMUILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [QMUILabel new];
        _locationLabel.text = @"上海市 22岁 健身教练";
        _locationLabel.font = UIFontMake(13);
        _locationLabel.textColor = [UIColor whiteColor];
    }
    return _locationLabel;
}

- (QMUILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [QMUILabel new];
        _dateLabel.text = @"约会范围：昆明市";
        _dateLabel.font = UIFontMake(13);
        _dateLabel.textColor = [UIColor whiteColor];
    }
    return _dateLabel;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [UIView new];
        _sepView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    return _sepView;
}

- (QMUIButton *)authButton {
    if (!_authButton) {
        _authButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_authButton setTitle:@"他通过了官方的朋友圈认证" forState:UIControlStateNormal];
        _authButton.titleLabel.font = UIFontMake(11);
    }
    return _authButton;
}

- (UIImageView *)corImageView {
    if (!_corImageView) {
        _corImageView = [UIImageView new];
        _corImageView.userInteractionEnabled = YES;

    }
    return _corImageView;
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

@implementation YoOtherHeaderViewModel

- (instancetype)initWithType:(YoMineUploadCollectionViewCellType)type photo:(UIImage *)photo imageUrl:(NSString *)imageUrl {
    if (self = [super init]) {
        _imageType = type;
        _photo = photo;
        _imageUrl = imageUrl;
    }
    return self;
}

@end
