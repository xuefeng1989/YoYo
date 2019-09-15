//
//  YoNewsCell.m
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoNewsCell.h"

#import "Const.h"
#import <Masonry.h>

@interface YoNewsCell()
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) UIImageView *logoView;
@property(nonatomic, strong) UIView *lineView;
@end

@implementation YoNewsCell

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
        
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.textColor = UIColorBlackFont;
        self.titleLabel.font = UIFontBoldMake(16);
        [self.contentView addSubview:self.titleLabel];
        
        self.logoView = [[UIImageView alloc] init];
        self.logoView.image = UIImageMake(@"icon_address_arrows");
        [self.contentView addSubview:self.logoView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setLogoName:(NSString *)logoName {
    _logoName = logoName;
    
    self.logoView.image = UIImageMake(logoName);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.logoView.mas_right).offset(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);

        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.logoView.mas_right).offset(5);
        make.right.equalTo(self.contentView);

    }];
}


@end
