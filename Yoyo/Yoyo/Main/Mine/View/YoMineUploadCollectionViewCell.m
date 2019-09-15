//
//  YoMineUploadCollectionViewCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineUploadCollectionViewCell.h"
#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface YoMineUploadCollectionViewCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIVisualEffectView *blurEffect;
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation YoMineUploadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.imageV addSubview:self.blurEffect];
        [self.blurEffect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setType:(YoMineUploadCollectionViewCellType)type {
    _type = type;
    switch (type) {
        case YoMineUploadCollectionViewCellTypePay:
            self.blurEffect.hidden = NO;
            self.titleL.hidden = NO;
            self.coverImageView.hidden = YES;
            self.titleL.text = @"付费照片";
            self.titleL.textColor = UIColorWhite;
            break;
        case YoMineUploadCollectionViewCellTypeFire:
            self.blurEffect.hidden = NO;
            self.titleL.hidden = NO;
            self.coverImageView.hidden = YES;
            self.titleL.text = @"阅后即焚";
            self.titleL.textColor = UIColorWhite;
            break;
        case YoMineUploadCollectionViewCellTypeFireReaded:
            self.blurEffect.hidden = NO;
            self.titleL.hidden = NO;
            self.coverImageView.hidden = YES;
            self.titleL.text = @"已销毁";
            self.titleL.textColor = UIColorWhite;
            break;
        case YoMineUploadCollectionViewCellTypePayed:
            self.blurEffect.hidden = NO;
            self.titleL.hidden = NO;
            self.coverImageView.hidden = YES;
            self.titleL.text = @"已付款";
            self.titleL.textColor = UIColorWhite;
            break;
        case YoMineUploadCollectionViewCellTypeNormal:
            self.blurEffect.hidden = YES;
            self.titleL.hidden = YES;
            self.coverImageView.hidden = YES;
            break;
        case YoMineUploadCollectionViewCellTypeMore:
            self.blurEffect.hidden = YES;
            self.titleL.hidden = NO;
            self.titleL.text = @"更多照片\n...";
            self.contentView.backgroundColor = UIColorGray9;
            self.titleL.textColor = UIColorSUBContentFont;
            self.coverImageView.hidden = YES;
            break;
        case YoMineUploadCollectionViewCellTypeUpload:
            self.blurEffect.hidden = YES;
            self.titleL.hidden = YES;
            self.coverImageView.hidden = NO;
            break;
        case YoMineUploadCollectionViewCellTypeInviteUpload:
            self.blurEffect.hidden = NO;
            self.titleL.hidden = NO;
            self.contentView.backgroundColor = UIColorGray9;
            self.coverImageView.hidden = YES;
            self.titleL.text = @"邀请上传";
            self.titleL.textColor = [UIColor colorWithRed:102/255.0 green:69/255.0 blue:251/255.0 alpha:1.0];
            break;
    }
}
- (void)setModel:(YoImageModel *)model
{
    _model = model;
    _imageV.image = nil;
    if (model.photo && model.photo.length > 0) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    }else{
        [self.imageV setImage:model.image];
    }
    self.type = model.imageType;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [UIImageView new];
        _imageV.layer.cornerRadius = 3;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.image = [UIImage imageNamed:@"mine_photo_white_add"];
    }
    return _coverImageView;
}

- (UIVisualEffectView *)blurEffect {
    if (!_blurEffect) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _blurEffect = blurEffectView;
            _blurEffect.hidden = YES;
    }
    return _blurEffect;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = UIFontMake(13);
        _titleL.text = @"阅后即焚";
        _titleL.textColor = [UIColor whiteColor];
        _titleL.hidden = YES;
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

@end
