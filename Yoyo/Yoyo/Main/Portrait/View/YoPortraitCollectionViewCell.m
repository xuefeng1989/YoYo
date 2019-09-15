//
//  YoPortraitCollectionViewCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCollectionViewCell.h"
#import "YoPortraitModel.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import "Const.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface YoPortraitCollectionViewCell ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *hotLabel;

@end

@implementation YoPortraitCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.avatarImageView];
        [self.bottomView addSubview:self.nameLabel];
        [self.bottomView addSubview:self.hotLabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(RatioZoom(40));
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(RatioZoom(5));
    }];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-RatioZoom(10));
    }];
}
- (void)setPortrait:(YoPortraitModel *)portrait {
    _portrait = portrait;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:portrait.picture] placeholderImage:nil];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:portrait.avatar] placeholderImage:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",portrait.userName, portrait.gap];
    self.hotLabel.text = [NSString stringWithFormat:@"热度 %ld 万",portrait.hot.integerValue];
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [UIImageView new];
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
        _picImageView.clipsToBounds = YES;
    }
    return _picImageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _bottomView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.frame = CGRectMake(0, 0, 25, 25);
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 25 * 0.5;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImageView;
}

- (QMUILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [QMUILabel new];
        _nameLabel.textColor = [UIColor qmui_colorWithHexString:@"#F0F0F0"];
        _nameLabel.font = UIFontMake(11);
    }
    return _nameLabel;
}

- (QMUILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [QMUILabel new];
        _hotLabel.textColor = [UIColor qmui_colorWithHexString:@"#F0F0F0"];
        _hotLabel.font = UIFontMake(11);
    }
    return _hotLabel;
}

@end
