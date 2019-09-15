//
//  YoPortraitCommentMultipleCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCommentMultipleCell.h"
#import <QMUIKit/QMUIKit.h>
#import "Const.h"
#import <Masonry.h>
#import "YoPortraitCommentModel.h"
#import <UIImageView+WebCache.h>

@interface YoPortraitCommentMultipleCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *timeLabel;
@property (nonatomic, strong) QMUILabel *contentLabel;
@property (nonatomic, strong) QMUIButton *likeButton;

@end


@implementation YoPortraitCommentMultipleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(RatioZoom(15));
            make.top.mas_equalTo(self.contentView).offset(RatioZoom(15));
            make.width.mas_equalTo(RatioZoom(46));
            make.height.mas_equalTo(RatioZoom(46));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(RatioZoom(15));
            make.top.mas_equalTo(self.avatarImageView);
        }];
        
        [self.contentView addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-RatioZoom(15));
            make.centerY.mas_equalTo(self.nameLabel);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(RatioZoom(9));
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.right.mas_equalTo(self.likeButton);
            make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(RatioZoom(15));
        }];
        
        
    }
    return self;
}


- (void)setModel:(YoPortraitCommentModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.nickName;
    self.timeLabel.text = model.createTime;
    self.contentLabel.text = model.comment;
    [self.likeButton setTitle:[NSString stringWithFormat:@" %zd",model.thumbsUp] forState:UIControlStateNormal];
}


#pragma mark - lazy load

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = RatioZoom(46)*0.5;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (QMUILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [QMUILabel new];
        _nameLabel.font = UIFontMake(16);
        _nameLabel.textColor = UIColorContentFont;
    }
    return _nameLabel;
}

- (QMUILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [QMUILabel new];
        _timeLabel.font = UIFontMake(11);
        _timeLabel.textColor = UIColorSUBContentFont;
        _timeLabel.text = @"03-14";
    }
    return _timeLabel;
}

- (QMUILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [QMUILabel new];
        _contentLabel.font = UIFontMake(16);
        _contentLabel.textColor = UIColorContentFont;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (QMUIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"portrait_collect"] forState:UIControlStateNormal];
        [_likeButton setTitle:@" 26" forState:UIControlStateNormal];
        _likeButton.titleLabel.font = UIFontMake(13);
        _likeButton.titleLabel.textColor = UIColorContentFont;
    }
    return _likeButton;
}

@end
