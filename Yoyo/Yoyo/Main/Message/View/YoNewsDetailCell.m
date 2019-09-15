//
//  YoNewsDetailCell.m
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoNewsDetailCell.h"

#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


static CGFloat const kLogoHeight = 55;
@interface YoNewsDetailCell()
@property(nonatomic, strong) UIImageView *logoView;
@property(nonatomic, strong) QMUILabel *titleLabel;
//@property(nonatomic, strong) QMUILabel *jointLabel;
//@property(nonatomic, strong) QMUILabel *secondPartLabel;
//@property(nonatomic, strong) QMUILabel *contentLabel;

@property(nonatomic, strong) QMUILabel *timeLabel;
@property(nonatomic, strong) UIView *lineView;
@end

@implementation YoNewsDetailCell

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
        
        // 头像，logo
        self.logoView = [[UIImageView alloc] init];
        self.logoView.frame = CGRectMake(0, 0, kLogoHeight, kLogoHeight);
        self.logoView.layer.cornerRadius = kLogoHeight/2;
        self.logoView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.logoView];
        
        // 主要内容，操作角色
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.textColor = UIColorGlobal;
        self.titleLabel.font = UIFontBoldMake(16);
        self.titleLabel.numberOfLines = 3;
        [self.contentView addSubview:self.titleLabel];
        
//        // 连接字符串
//        self.jointLabel = [[QMUILabel alloc] init];
//        self.jointLabel.textColor = UIColorGrayFont;
//        self.jointLabel.font = UIFontBoldMake(16);
//        [self.contentView addSubview:self.jointLabel];
//
//        // 第二个角色，城市，第二个角色等
//        self.secondPartLabel = [[QMUILabel alloc] init];
//        self.secondPartLabel.textColor = UIColorGlobal;
//        self.secondPartLabel.font = UIFontBoldMake(16);
//        [self.contentView addSubview:self.secondPartLabel];
//
//        // 内容
//        self.contentLabel = [[QMUILabel alloc] init];
//        self.contentLabel.textColor = UIColorGrayFont;
//        self.contentLabel.font = UIFontBoldMake(16);
//        [self.contentView addSubview:self.contentLabel];
       
        
        // 时间
        self.timeLabel = [[QMUILabel alloc] init];
        self.timeLabel.textColor = UIColorGrayFont;
        self.timeLabel.font = UIFontBoldMake(12);
        [self.contentView addSubview:self.timeLabel];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

- (void)setType:(YoNewsType)type {
    _type = type;
}

- (void)setModel:(YoNewsDetailModel *)model {
    _model = model;
    
    
    if (_type == YoNewsTypeSystem) {
        self.logoView.image = UIImageMake(@"icon_news_system");
//        self.titleLabel.text = @"【咯吱咯吱】本平台于2019年6月29日4:30分系统维护，届时将无法使用！5:00准时恢复使用。";
        
        NSAttributedString *stringOne =  [[NSMutableAttributedString alloc] initWithString:@"【咯吱咯吱】本平台于2019年6月29日4:30分系统维护，届时将无法使用！5:00准时恢复使用。"
                                                                             attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
//        NSAttributedString *stringTwo =  [[NSMutableAttributedString alloc] initWithString:@"咯吱咯吱】本平台于2019年6月29日4:30分系统维护，届时将无法使用！5:00准时恢复使用。"
//                                                                             attributes:@{NSForegroundColorAttributeName : UIColorRed}];
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:stringOne];
//        [contentString appendAttributedString:stringTwo];
        self.titleLabel.attributedText = contentString;


    }
    
    if (_type == YoNewsTypeAppointment) {
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        
        
        NSAttributedString *stringOne =  [[NSMutableAttributedString alloc] initWithString:@"蔡徐坤"
                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
        NSAttributedString *stringTwo =  [[NSMutableAttributedString alloc] initWithString:@"在"
                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
        
        NSAttributedString *stringThree =  [[NSMutableAttributedString alloc] initWithString:@"北京"
                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
        NSAttributedString *stringFour =  [[NSMutableAttributedString alloc] initWithString:@"发布了一条约会"
                                                                                  attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:stringOne];
        [contentString appendAttributedString:stringTwo];
        [contentString appendAttributedString:stringThree];
        [contentString appendAttributedString:stringFour];
        self.titleLabel.attributedText = contentString;
        
    }
    
    if (_type == YoNewsTypePortrait) {
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        
        
        NSAttributedString *stringOne =  [[NSMutableAttributedString alloc] initWithString:@"嘻嘻哈哈"
                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
//        NSAttributedString *stringTwo =  [[NSMutableAttributedString alloc] initWithString:@"在"
//                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
//
//        NSAttributedString *stringThree =  [[NSMutableAttributedString alloc] initWithString:@"北京"
//                                                                                  attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
        NSAttributedString *stringFour =  [[NSMutableAttributedString alloc] initWithString:@"更新了一集写真集"
                                                                                 attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:stringOne];
//        [contentString appendAttributedString:stringTwo];
//        [contentString appendAttributedString:stringThree];
        [contentString appendAttributedString:stringFour];
        self.titleLabel.attributedText = contentString;
    }
    
    if (_type == YoNewsTypeReward) {
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        
        NSAttributedString *stringOne =  [[NSMutableAttributedString alloc] initWithString:@"周杰伦"
                                                                                attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
        NSAttributedString *stringTwo =  [[NSMutableAttributedString alloc] initWithString:@"给我的写真集打赏了"
                                                                                        attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
        
        NSAttributedString *stringThree =  [[NSMutableAttributedString alloc] initWithString:@"告白气球（收入300云币）"
                                                                                          attributes:@{NSForegroundColorAttributeName : UIColorGlobal}];
        
//        NSAttributedString *stringFour =  [[NSMutableAttributedString alloc] initWithString:@""
//                                                                                 attributes:@{NSForegroundColorAttributeName : UIColorGrayFont}];
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:stringOne];
        [contentString appendAttributedString:stringTwo];
        [contentString appendAttributedString:stringThree];
//        [contentString appendAttributedString:stringFour];
        self.titleLabel.attributedText = contentString;
    }
    
    if (_type == YoNewsTypeWallet) {
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        self.titleLabel.text = @"格式化";
    }
    
    if (_type == YoNewsTypeEvaluate) {
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        self.titleLabel.text = @"哈哈哈";
    }
    
    self.timeLabel.text = @"2019/06/02 12.09";
   

}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kLogoHeight, kLogoHeight));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.logoView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);

    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.logoView.mas_right).offset(5);
        make.right.equalTo(self.contentView);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoView.mas_right).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    
    
}


@end
