//
//  YoAddTagTableViewCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAddTagTableViewCell.h"
#import "Const.h"
#import <Masonry.h>

@interface YoAddTagTableViewCell ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *addTitleL;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subTitleL;

@end

@implementation YoAddTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.locationImageView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.subTitleL];
        [self.backView addSubview:self.addTitleL];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(RatioZoom(15));
            make.right.mas_equalTo(-RatioZoom(15));
            make.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.addTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(25));
            make.centerY.mas_equalTo(self.backView);
        }];
        
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(20));
            make.centerY.mas_equalTo(self.backView);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.locationImageView.mas_top).mas_offset(RatioZoom(5));
            make.left.mas_equalTo(self.locationImageView.mas_right).offset(RatioZoom(5));
        }];
        
        [self.subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationImageView.mas_bottom).mas_offset(-RatioZoom(5));
            make.left.mas_equalTo(self.titleL);
        }];
    }
    return self;
}

- (void)setModel:(YoPortraitTagModel *)model {
    if (model.type == YoAddTagTableViewCellTypeAdd) {
        self.locationImageView.hidden = YES;
        self.titleL.hidden = YES;
        self.subTitleL.hidden = YES;
        self.addTitleL.hidden = NO;
    }else {
        self.locationImageView.hidden = NO;
        self.titleL.hidden = NO;
        self.subTitleL.hidden = NO;
        self.addTitleL.hidden = YES;
    }
    self.titleL.text = model.title;
    self.subTitleL.text = model.subTitle;
}


- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [UIImageView new];
        
        _locationImageView.image = [[UIImage imageNamed:@"btn_nav_location"] qmui_imageWithTintColor:UIColorWhite];
    }
    return _locationImageView;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.text = @"昆明 海天国际";
        _titleL.textColor = UIColorWhite;
        _titleL.font = UIFontMake(16);
    }
    return _titleL;
}

- (UILabel *)subTitleL {
    if (!_subTitleL) {
        _subTitleL = [UILabel new];
        _subTitleL.text = @"云南省昆明市盘龙区海天国际 200 米";
        _subTitleL.textColor = [UIColor qmui_colorWithHexString:@"#999999"];;
        _subTitleL.font = UIFontMake(13);
    }
    return _subTitleL;
}

- (UILabel *)addTitleL {
    if (!_addTitleL) {
        _addTitleL = [UILabel new];
        _addTitleL.text = @"+  添加自定义（限 8 个字）";
        _addTitleL.textColor = UIColorWhite;
        _addTitleL.font = UIFontMake(16);
    }
    return _addTitleL;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _backView.layer.cornerRadius = RatioZoom(10);
    }
    return _backView;
}
@end
