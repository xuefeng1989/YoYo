//
//  YoMineHeaderView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/5/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineHeaderView.h"

#import "YoMineHeaderModel.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"
#import "UIImageEffects.h"
#import "FollowHandlerService.h"
@interface YoMineHeaderView ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *distanceLabel;
@property (nonatomic, strong) QMUILabel *onlineStatusLabel;

@property (nonatomic, strong) QMUILabel *locationLabel;
@property (nonatomic, strong) QMUILabel *ageLabel;
@property (nonatomic, strong) QMUILabel *jobLabel;

@property (nonatomic, strong) QMUILabel *dateLabel;
@property (nonatomic, strong) QMUIButton *authButton;
@property (nonatomic, strong) UIView *sepView;
@property(nonatomic, assign) BOOL isSelf;
@property(nonatomic, assign) FollowHandlerType handlerType;

@end

@implementation YoMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame isSelf:(BOOL)isSelf {
    if (self = [super initWithFrame:frame]) {
        
        _isSelf = isSelf;
       
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:YoUserDefault.avatar] placeholderImage:nil];
        [self addSubview:self.backImageView];
        self.backImageView.frame = self.bounds;
       
        
        self.maskView = [[UIView alloc] init];
        self.maskView.backgroundColor = UIColorMakeWithRGBA(102, 69, 251, 0.93);
        [self addSubview:self.maskView];
        self.maskView.frame = self.bounds;
        
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.layer.cornerRadius = 70/2;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(55);
        }];
        
        
        self.nameLabel = [[QMUILabel alloc] init];
        self.nameLabel.text = @"慕言";
        self.nameLabel.font = UIFontBoldMake(20);
        self.nameLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(15);
            make.top.mas_equalTo(self.avatarImageView).offset(8);
        }];
        
        
        self.distanceLabel = [[QMUILabel alloc] init];
        self.distanceLabel.text = @"1.1km";
        self.distanceLabel.font = UIFontMake(13);
        self.distanceLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.maskView.mas_right).offset(-65);
            make.bottom.mas_equalTo(self.nameLabel);
        }];
        
        self.onlineStatusLabel = [[QMUILabel alloc] init];
        self.onlineStatusLabel.text = @"当前在线";
        self.onlineStatusLabel.font = UIFontMake(12);
        self.onlineStatusLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.onlineStatusLabel];
        [self.onlineStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.distanceLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.distanceLabel);
        }];
        
    
        
        self.locationLabel = [[QMUILabel alloc] init];
        self.locationLabel.text = @"上海市";
        self.locationLabel.font = UIFontMake(13);
        self.locationLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        
        self.ageLabel = [[QMUILabel alloc] init];
        self.ageLabel.text = @"22岁";
        self.ageLabel.font = UIFontMake(13);
        self.ageLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.ageLabel];
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.locationLabel);
        }];
        
        
        self.jobLabel = [[QMUILabel alloc] init];
        self.jobLabel.text = @"健身教练";
        self.jobLabel.font = UIFontMake(13);
        self.jobLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.jobLabel];
        [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.locationLabel);
        }];
        
        self.focusBtn = [[QMUIGhostButton alloc] init];
        [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.focusBtn.ghostColor = UIColorWhite;
        self.focusBtn.titleLabel.font = UIFontMake(12);
        self.focusBtn.adjustsButtonWhenDisabled = NO;
        self.focusBtn.hidden = YES;
        [self.maskView addSubview:self.focusBtn];
        [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 35));
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(self.distanceLabel.mas_bottom).offset(15);
        }];
        [self.focusBtn addTarget:self action:@selector(addFocusAction) forControlEvents:UIControlEventTouchUpInside];
        // 约会范围
        self.dateLabel = [QMUILabel new];
        self.dateLabel.text = @"约会范围：昆明市";
        self.dateLabel.font = UIFontMake(13);
        self.dateLabel.textColor = UIColorWhite;
        [self.maskView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.right.mas_equalTo(self.focusBtn.mas_left).offset(-10);
            make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(10);
            
        }];
        
        // 分割线
        self.sepView = [[UIView alloc] init];
        self.sepView.backgroundColor = UIColorSeparator;
        [self.maskView addSubview:self.sepView];
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.focusBtn.mas_bottom).offset(15);
            make.right.mas_equalTo(self.maskView);
            make.height.mas_equalTo(PixelOne);
        }];
        NSString *imgStr = @"";
        NSString *introStr = @"";
        self.authButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [self.authButton setImage:UIImageMake(imgStr) forState:UIControlStateNormal];
        
        if (!isSelf) {
            introStr = [NSString stringWithFormat:@"他%@", introStr];
        }
        [self.authButton setTitle:introStr forState:UIControlStateNormal];
        self.authButton.titleLabel.font = UIFontMake(11);
        self.authButton.adjustsButtonWhenDisabled = NO;
        self.authButton.spacingBetweenImageAndTitle = 10;
        [self.maskView addSubview:self.authButton];
        [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.sepView.mas_bottom).offset(15);
        }];
        
    
        if (isSelf) {
            self.distanceLabel.hidden = YES;
            self.onlineStatusLabel.hidden = YES;
            self.focusBtn.hidden = YES;
        }
        
        
    }
    return self;
}
- (void)addFocusAction{
    if (_model.follow && [_model.follow isEqual:@1]) {
        _handlerType = FollowHandlerTypeRemove;
    }else{
        _handlerType = FollowHandlerTypeAdd;
    }
      __weak __typeof(self)weakSelf = self;
    FollowHandlerService *service = [[FollowHandlerService alloc] initWithUserNo:_model.userNo.integerValue handler:_handlerType];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf.model.follow isEqual:@1]) {
            weakSelf.model.follow = @0;
            [weakSelf.focusBtn setTitle:@"收藏" forState:UIControlStateNormal];
        }else{
             weakSelf.model.follow = @1;
            [weakSelf.focusBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        }
    } failure:^(JSError *error) {
        
    }];
}
- (void)setModel:(YoMineHeaderModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.nameLabel.text = model.userName;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.locationLabel.text = model.location;
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
    self.jobLabel.text = [NSString stringWithFormat:@"%@", model.job];
    double getDis = [JSTool distanceBetweenOrderBylongitude1:YoUserDefault.longitude latitude1:YoUserDefault.latitude
                                                  longitude2:model.longitude latitude2:model.latitude];
    if (getDis > 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",getDis/1000];
    } else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fm",getDis];
    }
    self.dateLabel.text = [NSString stringWithFormat:@"约会范围：%@", model.dateRange];
    
    if (model.onlineStatus == YoOnlineStatusOn) {
        self.onlineStatusLabel.text = @"当前在线";
    } else {
        self.onlineStatusLabel.text = @"当前离线";
    }
    
    
    NSString *imgStr = @"";
    NSString *introStr = @"";
    switch (model.authStatus) {
        case YoAuthStatusSuccess:
            imgStr = @"icon_auth_status_success";
            introStr = @"通过了官方认证";
            break;
        case YoAuthStatusFail:
            imgStr = @"icon_auth_status_fail";
            introStr = @"未通过官方认证";
            break;
        case YoAuthStatusRunning:
            imgStr = @"icon_auth_status_run";
            introStr = @"正在进行官方认证";
            break;
        case YoAuthStatusNo:
            imgStr = @"icon_auth_status_no";
            introStr = @"未进行官方认证";
            break;
        default:
            break;
    }
    if (!_isSelf) {
        introStr = [NSString stringWithFormat:@"他%@", introStr];
        self.focusBtn.hidden = NO;
    }
    if (model.vip) {
        imgStr = @"icon_auth_status_vip";
        introStr = @"vip 用户";
    }
    
    [self.authButton setImage:UIImageMake(imgStr) forState:UIControlStateNormal];
    [self.authButton setTitle:introStr forState:UIControlStateNormal];

    if (model.follow && [model.follow isEqual:@1]) {
        [self.focusBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }else{
        [self.focusBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
}



- (UIImage *)tg_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (image == nil) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //设置模糊程度
    [filter setValue:@(blur) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    // 高度就增加多少
    self.backImageView.height = offset;
    
    self.maskView.height = offset;
}

- (void)setYa:(CGFloat)ya {
    _ya = ya;
    
    self.backImageView.y = ya;
    
    self.maskView.y = ya;
}


@end
