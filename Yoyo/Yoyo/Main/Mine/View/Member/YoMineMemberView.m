//
//  YoMineMemberView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineMemberView.h"
#import "Const.h"
#import <Masonry.h>

@implementation YoMineMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
        
        [self addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL.mas_right).offset(15);
            make.centerY.mas_equalTo(self);
        }];
        
        [self addSubview:self.commitButton];
        [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self);
        }];
        
        [self addSubview:self.sepV];
        [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.commitButton.mas_left).offset(-15);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setModel:(YoConfigVipModel *)model
{
    _model = model;
    self.titleL.text = model.dictLabel;
    self.contentL.text = [NSString stringWithFormat:@"%@ 云币",model.itemModel.coin];
}


- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = UIFontMake(16);
        _titleL.textColor = UIColorContentFont;
    }
    return _titleL;
}

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [UILabel new];
        _contentL.textColor = UIColorSUBContentFont;
        _contentL.font = UIFontMake(13);
    }
    return _contentL;
}

- (UIView *)sepV {
    if (!_sepV) {
        _sepV = [UIView new];
        _sepV.backgroundColor = [UIColorGray1 colorWithAlphaComponent:0.2];
    }
    return _sepV;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:@"开通" forState:UIControlStateNormal];
        _commitButton.titleLabel.font = UIFontBoldMake(15);
        [_commitButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
    }
    return _commitButton;
}

@end
