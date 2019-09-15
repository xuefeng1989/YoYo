//
//  YoChooseSexViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoChooseSexViewController.h"
#import "YoInitUserInfoViewController.h"

#import <Masonry.h>
@interface YoChooseSexViewController ()
@property(nonatomic, strong) QMUIButton *manBtn;
@property(nonatomic, strong) UIImageView *manTickIcon;
@property(nonatomic, strong) QMUIButton *womanBtn;
@property(nonatomic, strong) UIImageView *womanTickIcon;


@property(nonatomic, strong) QMUIButton *registerBtn;
@property(nonatomic, assign) BOOL isMan;
@end

@implementation YoChooseSexViewController

- (void)initSubviews {
    [super initSubviews];
    
    _isMan = YES;
    
    self.manBtn = [[QMUIButton alloc] init];
    [self.manBtn setImage:UIImageMake(@"icon_auth_man") forState:UIControlStateNormal];
    [self.manBtn setTitle:@"男" forState:UIControlStateNormal];
    [self.manBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    self.manBtn.imagePosition = QMUIButtonImagePositionTop;
    self.manBtn.spacingBetweenImageAndTitle = 8;
    self.manBtn.adjustsButtonWhenHighlighted = NO;
    [self.manBtn addTarget:self action:@selector(didClickSexHandler:) forControlEvents:UIControlEventTouchUpInside];

    self.manTickIcon = [[UIImageView alloc] init];
    self.manTickIcon.image = UIImageMake(@"icon_tick_confirm");
    [self.manBtn addSubview:self.manTickIcon];
    [self.view addSubview:self.manBtn];
    
    
    self.womanBtn = [[QMUIButton alloc] init];
    [self.womanBtn setImage:UIImageMake(@"icon_auth_woman") forState:UIControlStateNormal];
    [self.womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [self.womanBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    self.womanBtn.imagePosition = QMUIButtonImagePositionTop;
    self.womanBtn.spacingBetweenImageAndTitle = 8;
    self.womanBtn.adjustsButtonWhenHighlighted = NO;
    [self.womanBtn addTarget:self action:@selector(didClickSexHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.womanTickIcon = [[UIImageView alloc] init];
    self.womanTickIcon.image = UIImageMake(@"icon_tick_confirm");
    [self.womanBtn addSubview:self.womanTickIcon];
    [self.view addSubview:self.womanBtn];
    self.womanTickIcon.hidden = YES;
    
    
    
    self.registerBtn = [[QMUIButton alloc] init];
    [self.registerBtn setTitle:@"注册登录" forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = UIFontMake(14);
    [self.registerBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(didClickRegisterHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    
}

- (void)didClickSexHandler:(QMUIButton *)btn {
    if (self.manBtn == btn) {
        self.manTickIcon.hidden = NO;
        self.womanTickIcon.hidden = YES;
        _isMan = YES;
    }
    if (self.womanBtn == btn) {
        self.manTickIcon.hidden = YES;
        self.womanTickIcon.hidden = NO;
        _isMan = NO;
    }
}


- (void)didClickRegisterHandler {
    YoInitUserInfoViewController *infoVc = [[YoInitUserInfoViewController alloc] init];
    infoVc.loginType = self.loginType;
    infoVc.isMan = _isMan;
    infoVc.phoneStr = _phoneStr;
    infoVc.pwdStr = _pwdStr;
    infoVc.codeStr = _codeStr;
    infoVc.uid = self.uid;
    infoVc.accessToken = self.accessToken;
    [self.navigationController pushViewController:infoVc animated:YES];
}



- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"你是?";
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = 140;
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(width, width));
        make.top.equalTo(self.view.mas_top).offset(20 + self.qmui_navigationBarMaxYInViewCoordinator);
        make.right.equalTo(self.view.mas_centerX).offset(-4);
    }];
    
    [self.manTickIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.manBtn.imageView);
        make.right.equalTo(self.manBtn.imageView);
    }];
    
    
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(width, width));
        make.top.equalTo(self.view.mas_top).offset(20 + self.qmui_navigationBarMaxYInViewCoordinator);
        make.left.equalTo(self.view.mas_centerX).offset(4);
    }];
    
    [self.womanTickIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.womanBtn.imageView);
        make.right.equalTo(self.womanBtn.imageView);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.womanBtn.mas_bottom).offset(RatioZoom(40));
    }];
    
}


@end
