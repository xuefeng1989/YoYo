//
//  YoMineBindView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineBindView.h"


#import <Masonry.h>

@interface YoMineBindView()

@end
@implementation YoMineBindView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorWhite;
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.textField];
        [self addSubview:self.rightButton];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(85);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(175);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}



- (void)changedTextField:(QMUITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(bingView:changedTextField:)]) {
        [self.delegate bingView:self changedTextField:self.textField];
    }
}



- (QMUILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[QMUILabel alloc] init];
        _leftLabel.textColor = UIColorContentFont;
        _leftLabel.font = UIFontMake(16);
    }
    return _leftLabel;
}

- (QMUITextField *)textField {
    if (!_textField) {
        _textField = [[QMUITextField alloc] init];
        _textField.font = UIFontMake(16);
        [self.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (QMUIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[QMUIButton alloc] init];
        _rightButton.titleLabel.font = UIFontMake(16);
    }
    return _rightButton;
}
@end
