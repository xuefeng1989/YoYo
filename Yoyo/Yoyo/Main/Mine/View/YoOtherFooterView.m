//
//  YoOtherFooterView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherFooterView.h"
#import "Const.h"
#import <Masonry.h>

@implementation YoOtherFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor qmui_colorWithHexString:@"#F0F0F0"];
        [self addSubview:self.commentButton];
        [self addSubview:self.chatButton];
        [self addSubview:self.relationButton];
        [self addSubview:self.tipLabel];
        
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(20));
            make.right.mas_equalTo(-RatioZoom(20));
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(RatioZoom(50));
        }];
        
        [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(20));
            make.right.mas_equalTo(-RatioZoom(20));
            make.top.mas_equalTo(self.commentButton.mas_bottom).offset(RatioZoom(10));
            make.height.mas_equalTo(RatioZoom(50));
        }];
        
        [self.relationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(20));
            make.right.mas_equalTo(-RatioZoom(20));
            make.top.mas_equalTo(self.chatButton.mas_bottom).offset(RatioZoom(10));
            make.height.mas_equalTo(RatioZoom(50));
        }];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.relationButton.mas_bottom).offset(RatioZoom(20));
            make.centerX.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setIsHiddenRelationButton:(BOOL)isHiddenRelationButton {
    _isHiddenRelationButton = isHiddenRelationButton;
    if (isHiddenRelationButton) {
        self.relationButton.hidden = YES;
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chatButton.mas_bottom).offset(RatioZoom(20));
            make.centerX.mas_equalTo(self);
        }];
    }

}


- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = [UIColor whiteColor];
        _commentButton.layer.cornerRadius = RatioZoom(25);
        [_commentButton setTitle:@" 评价他" forState:UIControlStateNormal];
        [_commentButton setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"mine_comment_other"] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = UIFontMake(14);
    }
    return _commentButton;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatButton.backgroundColor = [UIColor whiteColor];
        _chatButton.layer.cornerRadius = RatioZoom(25);
        [_chatButton setTitle:@" 私聊" forState:UIControlStateNormal];
        [_chatButton setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"mine_chat"] forState:UIControlStateNormal];
        _chatButton.titleLabel.font = UIFontMake(14);
    }
    return _chatButton;
}

- (UIButton *)relationButton {
    if (!_relationButton) {
        _relationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _relationButton.backgroundColor = [UIColor whiteColor];
        _relationButton.layer.cornerRadius = RatioZoom(25);
        [_relationButton setTitle:@" 联系方式" forState:UIControlStateNormal];
        [_relationButton setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        [_relationButton setImage:[UIImage imageNamed:@"mine_phone"] forState:UIControlStateNormal];
        _relationButton.titleLabel.font = UIFontMake(14);
    }
    return _relationButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
        _tipLabel.font = UIFontMake(11);
        _tipLabel.textColor = UIColorSUBContentFont;
    }
    return _tipLabel;
}
@end
