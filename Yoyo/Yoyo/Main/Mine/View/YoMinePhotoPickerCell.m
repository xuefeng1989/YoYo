//
//  YoMinePhotoPickerCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePhotoPickerCell.h"
#import "Const.h"
#import <Masonry.h>

@interface YoMinePhotoPickerCell ()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YoMinePhotoPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.rightImageView];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(15));
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.itemLabel.mas_right);
            make.centerY.mas_equalTo(self.itemLabel);
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-RatioZoom(15));
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setConfig:(NSDictionary *)config {
    _config = config;
    self.itemLabel.text = config[@"item"];
    self.subLabel.text = config[@"sub"];
    self.rightImageView.image = [config[@"selected"] isEqualToString:@"true"] ? [UIImage imageNamed:@"mine_photo_selected"] : [UIImage imageNamed:@"mine_photo_unselected"];
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.font = UIFontMake(16);
        _itemLabel.textColor = UIColorContentFont;
    }
    return _itemLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.font = UIFontMake(16);
        _subLabel.textColor = UIColorSUBContentFont;
    }
    return _subLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
    }
    return _rightImageView;
}
@end
