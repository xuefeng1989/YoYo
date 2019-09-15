//
//  YoMessageSettgingCell.m
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMessageSettgingCell.h"

#import "Const.h"
#import <Masonry.h>

@interface YoMessageSettgingCell()
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) UISwitch *switchView;
@end

@implementation YoMessageSettgingCell

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
        
        
        
        self.switchView = [[UISwitch alloc] init];
        self.switchView.onTintColor = UIColorGlobal;
        [self.switchView addTarget:self action:@selector(clickSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.switchView];
        
        
    }
    return self;
}



- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    
    JSLogInfo(@"%d",isOpen);
    
    self.switchView.on = isOpen;
}

- (void)clickSwitchEvent:(UISwitch *)switchView {
    if ([self.delegate respondsToSelector:@selector(settingCell:switchValueChage:)]) {
        [self.delegate settingCell:self switchValueChage:switchView.on];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
   
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
   
    
}


@end
