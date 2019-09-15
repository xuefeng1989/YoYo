//
//  YoPublishPickerCell.m
//  Yoyo
//
//  Created by ning on 2019/6/23.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPublishPickerCell.h"

#import "Const.h"
#import <Masonry.h>


@interface YoPublishPickerCell()
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUILabel *contentLabel;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation YoPublishPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.font = UIFontMake(16);
        self.titleLabel.textColor = UIColorBlackFont;
        [self addSubview:self.titleLabel];
        
        
        self.contentLabel = [[QMUILabel alloc] init];
        self.contentLabel.font = UIFontMake(16);
        self.contentLabel.textColor = UIColorGrayFont;
        [self addSubview:self.contentLabel];
        
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self addSubview:self.lineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)clickEvent {
    if ([self.delegate respondsToSelector:@selector(YoPublishPickerCell:didClickEvent:)]) {
        [self.delegate YoPublishPickerCell:self didClickEvent:self.contentLabel];
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    self.titleLabel.text = titleString;
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    
    self.contentLabel.text = contentString;
}

-(void)setHiddenSeparator:(BOOL)hiddenSeparator {
    _hiddenSeparator = hiddenSeparator;
    
    self.lineView.hidden = hiddenSeparator;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-PixelOne);
    }];
}



@end
