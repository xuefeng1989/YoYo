//
//  YoMineFooterView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineFooterView.h"
#import "Const.h"
#import <Masonry.h>

@implementation YoMineFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        self.exitButton = [[QMUIFillButton alloc] init];
        self.exitButton.fillColor = UIColorWhite;
        [self.exitButton setTitle:@"安全退出" forState:UIControlStateNormal];
        [self.exitButton setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        self.exitButton.titleLabel.font = UIFontMake(14);
        [self.exitButton addTarget:self action:@selector(didClickForgetHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.exitButton];
        
        
        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(RatioZoom(340), 50));
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
        }];
        
    
        [self addSubview:self.versionLabel];
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.exitButton.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = UIColorSUBContentFont;
        _versionLabel.font = UIFontMake(11);
        _versionLabel.numberOfLines = 0;
        _versionLabel.text = @"当前版本1.0.11\n请勿上传裸露低俗照片，严重者将做封号处理";
    }
    return _versionLabel;
}


- (void)didClickForgetHandler {
    
    
}
@end
