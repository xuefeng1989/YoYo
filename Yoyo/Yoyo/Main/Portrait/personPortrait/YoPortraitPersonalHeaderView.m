//
//  YoPortraitPersonalHeaderView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitPersonalHeaderView.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import "Const.h"
#import "YoDataItem.h"
#import "YoPortraitModel.h"
@interface YoPortraitPersonalHeaderView ()

@property (nonatomic, strong) QMUILabel *namaLabel;
@property (nonatomic, strong) QMUILabel *hotLabel;
@property (nonatomic, strong) QMUILabel *fansLabel;
@property (nonatomic, strong) QMUIButton *moneyButton;
@property (nonatomic, strong) QMUIButton *statusButton;
@property (nonatomic, strong) UIView *sepView;

@end

@implementation YoPortraitPersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.namaLabel];
        [self.namaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(15));
            make.top.mas_equalTo(RatioZoom(20));
        }];
        
        [self addSubview:self.hotLabel];
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.namaLabel);
            make.top.mas_equalTo(self.namaLabel.mas_bottom).offset(RatioZoom(16));
        }];
        
        [self addSubview:self.fansLabel];
        [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hotLabel.mas_right).offset(RatioZoom(17));
            make.centerY.mas_equalTo(self.hotLabel);
        }];
        
        [self addSubview:self.moneyButton];
        [self.moneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(12));
            make.centerY.mas_equalTo(self.namaLabel);
        }];
        
        [self addSubview:self.statusButton];
        [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.moneyButton);
            make.centerY.mas_equalTo(self.hotLabel);
        }];
        
        [self addSubview:self.sepView];
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.namaLabel);
            make.bottom.mas_equalTo(-1);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setPortrait:(YoPortraitModel *)portrait {
    _portrait = portrait;
    self.namaLabel.text = [NSString stringWithFormat:@"%@写真集",portrait.userName];
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝：%zd人",portrait.relationNum];
    [self.moneyButton setTitle:[NSString stringWithFormat:@"  %zd 云币",portrait.totalBit] forState:UIControlStateNormal];
    [self.statusButton setTitle:[NSString stringWithFormat:@" %@",portrait.datingStatusString] forState:UIControlStateNormal];
    if (portrait.hot.intValue > 9999) {
        self.hotLabel.text = [NSString stringWithFormat:@"此集热度 %d 万",portrait.hot.intValue / 10000];
    }else{
         self.hotLabel.text = [NSString stringWithFormat:@"此集热度 %@ ",portrait.hot];
    }
}

- (QMUILabel *)namaLabel {
    if (!_namaLabel) {
        _namaLabel = [QMUILabel new];
        _namaLabel.font = UIFontMake(20);
        _namaLabel.textColor = DEFAULT_CONTENT_COLOR;
        _namaLabel.text = @"木兮写真集";
    }
    return _namaLabel;
}

- (QMUILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [QMUILabel new];
        _hotLabel.font = UIFontMake(13);
        _hotLabel.textColor = DEFAULT_SUBTITLE_COLOR;
        _hotLabel.text = @"此集热度 3.6 万";
    }
    return _hotLabel;
}

- (QMUILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [QMUILabel new];
        _fansLabel.font = UIFontMake(13);
        _fansLabel.textColor = DEFAULT_SUBTITLE_COLOR;
        _fansLabel.text = @"粉丝：1029人";
    }
    return _fansLabel;
}

- (QMUIButton *)moneyButton {
    if (!_moneyButton) {
        _moneyButton = [QMUIButton buttonWithType:UIButtonTypeCustom];

        [_moneyButton setImage:[UIImage imageNamed:@"portrait_money"] forState:UIControlStateNormal];
        [_moneyButton setTitle:@"  600.00 云币" forState:UIControlStateNormal];
        [_moneyButton setTitleColor:UIColorMake(255, 125, 0) forState:UIControlStateNormal];
        _moneyButton.titleLabel.font = UIFontMake(13);
//        [_moneyButton addTarget:self action:@selector(didClickComfirmHandler) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moneyButton;
}

- (QMUIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setImage:[UIImage imageNamed:@"portrait_free"] forState:UIControlStateNormal];
        [_statusButton setTitle:@" 可约" forState:UIControlStateNormal];
        [_statusButton setTitleColor:UIColorMake(255, 38, 27) forState:UIControlStateNormal];
        _statusButton.titleLabel.font = UIFontMake(13);
        //        [_statusButton addTarget:self action:@selector(didClickComfirmHandler) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _statusButton;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [UIView new];
        _sepView.backgroundColor = UIColorMake(240, 240, 240);
    }
    return _sepView;
}

@end
