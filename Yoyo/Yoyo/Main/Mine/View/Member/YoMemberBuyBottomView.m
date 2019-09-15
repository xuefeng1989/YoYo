//
//  YoMemberBuyBottomView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMemberBuyBottomView.h"
#import <Masonry.h>
#import "Const.h"

@interface YoMemberBuyBottomView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *sepV1;
@property (nonatomic, strong) UIView *sepV2;
@property (nonatomic, strong) UILabel *title1;
@property (nonatomic, strong) UILabel *title2;
@end

@implementation YoMemberBuyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(70);
        }];
        
        [self addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self);
        }];
        
        [self addSubview:self.sepV1];
        [self.sepV1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(PixelOne);
        }];
        
        [self addSubview:self.title1];
        [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.sepV1.mas_bottom).offset(15);
        }];
        
        [self addSubview:self.buyButton];
        [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.title1);
        }];
        
        [self addSubview:self.sepV2];
        [self.sepV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self.title1.mas_bottom).offset(15);
            make.height.mas_equalTo(PixelOne);
        }];

        
        [self addSubview:self.title2];
        [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.sepV2.mas_bottom).offset(15);
        }];
        
        [self addSubview:self.walletButton];
        [self.walletButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.title2);
        }];
        
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title2.mas_bottom).offset(15);
            make.left.right.bottom.mas_equalTo(self);
        }];
        
        UIImageView *bottomPayLogo = [[UIImageView alloc] init];
        bottomPayLogo.image = UIImageMake(@"icon_pay_bottom");
        [self.bottomView addSubview:bottomPayLogo];
        [bottomPayLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomView);
            make.centerY.equalTo(self.bottomView);
        }];

    }
    return self;
}

- (void)setModel:(YoConfigVipModel *)model
{
    _model = model;
    [self.buyButton setTitle:model.dictLabel forState:UIControlStateNormal];
}
- (void)setMoneyString:(NSString *)moneyString {
    _moneyString = [moneyString copy];
    
    _moneyLabel.text = moneyString;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 35;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.image = UIImageMake(@"icon_pay_logo");
    }
    return _iconImageView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.text = @"YB 350.00";
        _moneyLabel.textColor = UIColorGlobal;
        _moneyLabel.font = UIFontBoldMake(20);
    }
    return _moneyLabel;
}

- (UIView *)sepV1 {
    if (!_sepV1) {
        _sepV1 = [UIView new];
        _sepV1.backgroundColor = UIColorSeparator;
    }
    return _sepV1;
}

- (UIView *)sepV2 {
    if (!_sepV2) {
        _sepV2 = [UIView new];
        _sepV2.backgroundColor = UIColorSeparator;
    }
    return _sepV2;
}

- (UILabel *)title1 {
    if (!_title1) {
        _title1 = [UILabel new];
        _title1.text = @"我公开的资料";
        _title1.textColor = UIColorContentFont;
        _title1.font = UIFontBoldMake(16);
    }
    return _title1;
}

- (UILabel *)title2 {
    if (!_title2) {
        _title2 = [UILabel new];
        _title2.text = @"付款方式";
        _title2.textColor = UIColorContentFont;
        _title2.font = UIFontBoldMake(16);
    }
    return _title2;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"开通会员" forState:UIControlStateNormal];
        [_buyButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        _buyButton.titleLabel.font = UIFontMake(16);
    }
    return _buyButton;
}

- (UIButton *)walletButton {
    if (!_walletButton) {
        _walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_walletButton setTitle:@"我的钱包" forState:UIControlStateNormal];
        [_walletButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        _walletButton.titleLabel.font = UIFontMake(16);
    }
    return _walletButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = UIColorContentFont;
    }
    return _bottomView;
}

@end
