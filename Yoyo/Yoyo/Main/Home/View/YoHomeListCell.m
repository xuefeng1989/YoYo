//
//  YoHomeListCell.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeListCell.h"

#import "Const.h"
#import "YoHomeListModel.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "JSTool.h"

static CGFloat const kPortraitHeight = 60;

@interface YoHomeListCell()
@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) UIImageView *portraitTagView;
@property(nonatomic, strong) QMUILabel *nicknameLabel;
@property(nonatomic, strong) UIView *sexAgeView;
@property(nonatomic, strong) UIImageView *sexView;
@property(nonatomic, strong) QMUILabel *ageLabel;
@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) QMUILabel *picLabel;
@property(nonatomic, strong) QMUILabel *introLabel;
@property(nonatomic, strong) QMUILabel *areaLabel;
@property(nonatomic, strong) QMUILabel *distanceLabel;
@property(nonatomic, strong) QMUILabel *onlineLabel;

@property(nonatomic, strong) UIImageView *lineView;

@end

@implementation YoHomeListCell

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
        self.portraitView.contentMode = UIViewContentModeScaleAspectFill;
        self.portraitView.backgroundColor = UIColorRed;
        [self.contentView addSubview:self.portraitView];
        self.portraitTagView = [[UIImageView alloc] initWithImage:UIImageMake(@"")];
        [self.contentView addSubview:self.portraitTagView];
        self.portraitTagView.hidden = YES;
        self.nicknameLabel = [[QMUILabel alloc] init];
        self.nicknameLabel.textColor = UIColorBlackFont;
        self.nicknameLabel.font = UIFontMake(16);
        [self.contentView addSubview:self.nicknameLabel];
        
        self.sexAgeView = [[UIView alloc] init];
        [self.contentView addSubview:self.sexAgeView];
        
        self.sexView = [[UIImageView alloc] init];
        [self.sexAgeView addSubview:self.sexView];
        
        self.ageLabel = [[QMUILabel alloc] init];
        self.ageLabel.textColor = UIColorWhite;
        self.ageLabel.font = UIFontMake(11);
        [self.sexAgeView addSubview:self.ageLabel];
        
        
        self.picView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picView];
        
        self.picLabel = [[QMUILabel alloc] init];
        self.picLabel.textColor = UIColorBlackFont;
        self.picLabel.font = UIFontMake(11);
        [self.contentView addSubview:self.picLabel];
        
        
        self.introLabel = [[QMUILabel alloc] init];
        self.introLabel.textColor = UIColorBlackFont;
        self.introLabel.font = UIFontMake(13);
        [self.contentView addSubview:self.introLabel];
        
        
        self.areaLabel = [[QMUILabel alloc] init];
        self.areaLabel.textColor = UIColorBlackFont;
        self.areaLabel.font = UIFontMake(13);
        [self.contentView addSubview:self.areaLabel];
        
        
        self.distanceLabel = [[QMUILabel alloc] init];
        self.distanceLabel.textColor = UIColorGrayFont;
        self.distanceLabel.font = UIFontMake(12);
        [self.contentView addSubview:self.distanceLabel];
        
        self.onlineLabel = [[QMUILabel alloc] init];
        self.onlineLabel.textColor = UIColorGrayFont;
        self.onlineLabel.font = UIFontMake(12);
        [self.contentView addSubview:self.onlineLabel];
        
        
        self.lineView = [[UIImageView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}


- (void)setData:(NSString *)data {
    _data = [data copy];
    
    NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
    
    self.portraitTagView.image = UIImageMake(@"icon_pic_tag_reality");
    
    self.nicknameLabel.text = @"张东路";
    
    self.sexAgeView.backgroundColor = UIColorMake(255, 92, 131);
    self.sexView.image = UIImageMake(@"icon_tag_sex_man");
    self.ageLabel.text = @"32";
    
    self.picView.image = UIImageMake(@"icon_tag_photo");
    
    self.picLabel.text = @"16";
    
    self.introLabel.text = @"国企老总";
    
    self.areaLabel.text = @"北京";
    
    self.distanceLabel.text = @"2.1km";
    
    self.onlineLabel.text = @"当前在线";
}

- (void)setModel:(YoHomeListModel *)model {
    _model = model;
    
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
    
    if (model.authenticate == 1) {
        self.portraitTagView.image = UIImageMake(@"icon_pic_tag_reality");
        self.portraitTagView.hidden = NO;
    }
    
    if (model.vip == 1) {
        self.portraitTagView.image = UIImageMake(@"icon_pic_tag_vip");
        self.portraitTagView.hidden = NO;
    }
    
    self.nicknameLabel.text = model.userName;
    
    self.sexAgeView.backgroundColor = UIColorMake(255, 92, 131);
    self.sexView.image = UIImageMake(@"icon_tag_sex_man");
    if (model.gender == YoSexTypeWoman) {
        self.sexView.image = UIImageMake(@"icon_tag_sex_woman");
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",model.age];
    
    if (model.photoCount > 0) {
        self.picView.hidden = NO;
        self.picLabel.hidden = NO;
        self.picView.image = UIImageMake(@"icon_tag_photo");
        self.picLabel.text = [NSString stringWithFormat:@"%ld",model.photoCount];
    } else {
        self.picView.hidden = YES;
        self.picLabel.hidden = YES;
    }
    
    self.introLabel.text = model.job;
    
    self.areaLabel.text = model.location;
    
//    CGFloat dis = model.distance/1000;
//    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM",dis];
    double getDis = [JSTool distanceBetweenOrderBylongitude1:YoUserDefault.longitude latitude1:YoUserDefault.latitude
                                                  longitude2:model.longitude latitude2:model.latitude];
    if (getDis > 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",getDis/1000];
    } else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fm",getDis];
    }
    
    self.onlineLabel.text = @"当前离线";
    if (model.onlineStatus == YoOnlineStatusOn) {
        self.onlineLabel.text = @"当前在线";
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(kPortraitHeight, kPortraitHeight));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    
    [self.portraitTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.portraitView);
        make.centerY.equalTo(self.portraitView.mas_bottom);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitView.mas_top).offset(3);
        make.left.equalTo(self.portraitView.mas_right).offset(20);
    }];
    
    [self.sexAgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(31, 15));
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.nicknameLabel);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexAgeView);
        make.left.equalTo(self.sexAgeView).offset(3);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexAgeView);
        make.right.equalTo(self.sexAgeView).offset(-3);
    }];
    
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexAgeView);
        make.left.equalTo(self.sexAgeView.mas_right).offset(5);
    }];
    
    [self.picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexAgeView);
        make.left.equalTo(self.picView.mas_right).offset(5);
    }];
    
    
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexAgeView.mas_bottom).offset(10);
        make.left.equalTo(self.nicknameLabel);
    }];
    
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexAgeView.mas_bottom).offset(10);
        make.left.equalTo(self.introLabel.mas_right).offset(8);
    }];
    
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    
    
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nicknameLabel.mas_bottom);
        make.right.equalTo(self.onlineLabel.mas_left).offset(-5);
    }];
    

    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(PixelOne);
        make.left.equalTo(self.nicknameLabel);
        make.right.equalTo(self.contentView);
    }];
}

@end
