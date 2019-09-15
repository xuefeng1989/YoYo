//
//  YoOtherTableViewCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherTableViewCell.h"
#import "Const.h"
#import <Masonry.h>

@interface YoOtherTableViewCell ()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *sepV;
@end

@implementation YoOtherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.sepV];
        [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(PixelOne);
        }];
        
        
    }
    return self;
}

- (void)setConfig:(YoOtherTableViewCellConfig *)config {
    _config = config;
    self.itemLabel.text = config.title;
    self.rightImageView.image = [UIImage imageNamed:config.rightImageString];
    self.rightLabel.text = config.rightTitle;
    self.rightLabel.textColor = config.rightTitleColor;
    self.rightImageView.hidden = config.hideRightImage;
    if (config.hideRightImage) {
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }else {
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightImageView.mas_left).offset(-2);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = UIFontMake(16);
        _itemLabel.textColor = UIColorContentFont;
    }
    return _itemLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"mine_arrow"];
    }
    return _rightImageView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = UIFontMake(16);
    }
    return _rightLabel;
}

- (UIView *)sepV {
    if (!_sepV) {
        _sepV = [[UIView alloc] init];
        _sepV.backgroundColor = UIColorSeparator;
    }
    return _sepV;
}


@end

@implementation YoOtherTableViewCellConfig

- (instancetype)initWithTitle:(NSString *)title rightImageString:(NSString *)rightImageString rightTitle:(NSString *)rightTitle rightTitleColor:(UIColor *)rightTitleColor hideRightImage:(BOOL)hideRightImage {
    if (self = [super init]) {
        _title = title;
        _rightImageString = rightImageString;
        _rightTitle = rightTitle;
        _rightTitleColor = rightTitleColor;
        _hideRightImage = hideRightImage;
    }
    return self;
}

@end
