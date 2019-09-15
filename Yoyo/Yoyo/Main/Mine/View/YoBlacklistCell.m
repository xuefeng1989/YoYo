//
//  YoBlacklistCell.m
//  Yoyo
//
//  Created by ningcol on 2019/7/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBlacklistCell.h"

#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "YoBlacklistModel.h"


static CGFloat const kPortraitHeight = 60;

@interface YoBlacklistCell()
@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) QMUILabel *nicknameLabel;
@property(nonatomic, strong) QMUIButton *cancelBtn;
@property(nonatomic, strong) UIImageView *lineView;

@end
@implementation YoBlacklistCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = nil;
    if (CellIdentifier == nil) {
        CellIdentifier = [NSString stringWithFormat:@"%@CellIdentifier", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.portraitView = [[UIImageView alloc] init];
        self.portraitView.frame = CGRectMake(0, 0, kPortraitHeight, kPortraitHeight);
        self.portraitView.layer.cornerRadius = kPortraitHeight / 2;
        self.portraitView.layer.masksToBounds = YES;
        self.portraitView.backgroundColor = UIColorRed;
        [self.contentView addSubview:self.portraitView];
        
        self.nicknameLabel = [[QMUILabel alloc] init];
        self.nicknameLabel.textColor = UIColorBlackFont;
        self.nicknameLabel.font = UIFontBoldMake(16);
        [self.contentView addSubview:self.nicknameLabel];
        
        self.cancelBtn = [[QMUIButton alloc] init];
        [self.cancelBtn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = UIFontMake(15);
        [self.cancelBtn addTarget:self action:@selector(didClickCancelEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        
        
        self.lineView = [[UIImageView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}



- (void)setModel:(YoBlacklistModel *)model {
    _model = model;
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
    self.nicknameLabel.text = model.userName; 
}

#pragma mark - Event
- (void)didClickCancelEvent {
    if ([self.delegate respondsToSelector:@selector(blacklistCell:didClickCancelUserNo:)]) {
        [self.delegate blacklistCell:self didClickCancelUserNo:_model.userNo];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(kPortraitHeight, kPortraitHeight));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.portraitView.mas_right).offset(20);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 60));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(PixelOne);
        make.left.equalTo(self.nicknameLabel);
        make.right.equalTo(self.contentView);
    }];
    
    
    
}


@end
