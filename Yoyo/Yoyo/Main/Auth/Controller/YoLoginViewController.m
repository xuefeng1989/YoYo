//
//  YoLoginViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoLoginViewController.h"
#import "YoForgetPwdController.h"
#import "YoTabBarViewController.h"
#import "YoChooseSexViewController.h"

#import "YoInputTextView.h"

#import "AppDelegate.h"
#import "AppDelegate+ShareSDK.h"
#import <Masonry.h>
#import "NSString+Extension.h"
#import "YoTool.h"
#import "LoginService.h"
#import "CheckThirdRegService.h"

@interface YoLoginViewController () <YoInputTextViewDelegate>
@property(nonatomic, strong) YoInputTextView *phoneView;
@property(nonatomic, strong) YoInputTextView *pwdView;
@property(nonatomic, strong) QMUIButton *loginBtn;
@property(nonatomic, strong) QMUIButton *forgetBtn;
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *pwdStr;

@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, strong) QMUILabel *introLabel;
@property(nonatomic, strong) QMUIButton *qqLoginBtn;

@property(nonatomic, strong) QMUILabel *tipsLabel;
@property(nonatomic, strong) QMUIButton *userPrivacyBtn;
@end

@implementation YoLoginViewController

- (void)initSubviews {
    [super initSubviews];
    
    
    // 登录textField
    self.phoneView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePhone textViewTitle:@"手机"];
    self.phoneView.delegate = self;
    [self.view addSubview:self.phoneView];
    
    // 密码textField
    self.pwdView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePWD textViewTitle:@"密码"];
    self.pwdView.delegate = self;
    [self.view addSubview:self.pwdView];
    
    
    self.loginBtn = [[QMUIButton alloc] init];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = UIFontMake(14);
    [self.loginBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(didClickLoginHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    
    self.forgetBtn = [[QMUIButton alloc] init];
    [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = UIFontMake(13);
    [self.forgetBtn addTarget:self action:@selector(didClickForgetHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetBtn];
    
    
    // 底部第三方登录
    self.lineView = [[UIImageView alloc] init];
    self.lineView.backgroundColor = UIColorSeparator;
    [self.view addSubview:self.lineView];
    
    self.introLabel = [[QMUILabel alloc] init];
    self.introLabel.text = @"快速登录";
    self.introLabel.font = UIFontMake(13);
    self.introLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.introLabel.textAlignment = NSTextAlignmentCenter;
    self.introLabel.backgroundColor = [UIColor whiteColor];
    self.introLabel.textColor = UIColorGrayFont;
    [self.view addSubview:self.introLabel];
    
    self.qqLoginBtn = [[QMUIButton alloc] init];
    [self.qqLoginBtn setImage:UIImageMake(@"icon_qq_login") forState:UIControlStateNormal];
    [self.qqLoginBtn addTarget:self action:@selector(didClickQQLoginHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qqLoginBtn];
    
    
    // 用户协议
    self.tipsLabel = [[QMUILabel alloc] init];
    self.tipsLabel.text = @"登录即代表你阅读且同意";
    self.tipsLabel.textColor = UIColorGrayFont;
    self.tipsLabel.font = UIFontMake(13);
    [self.view addSubview:self.tipsLabel];
    
    self.userPrivacyBtn = [[QMUIButton alloc] init];
    [self.userPrivacyBtn setTitle:@"《用户手册》" forState:UIControlStateNormal];
    [self.userPrivacyBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
    self.userPrivacyBtn.titleLabel.font = UIFontMake(13);
    [self.userPrivacyBtn addTarget:self action:@selector(didClickPrivacyHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userPrivacyBtn];
    
    
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"登录";
}

#pragma mark - event
- (void)didClickLoginHandler {
    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.pwdStr)) {
        [QMUITips showInfo:@"请输入密码" inView:self.view];
        return;
    }
    
    [QMUITips showLoadingInView:self.view];
    LoginService *loginApi = [[LoginService alloc] initWithPhone:self.phoneStr password:self.pwdStr openId:@"" accessToken:@""];
    [loginApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        NSDictionary *userDict = [request.responseJSONObject objectForKey:@"result"];
        [YoTool saveUserInfo:userDict];
        YoUserDefault.loginType = YoLoginTypePhone;

        YoTabBarViewController *tabBarViewController = [[YoTabBarViewController alloc] init];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = tabBarViewController;

    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
    
}

- (void)didClickForgetHandler {
    YoForgetPwdController *forgetVc = [[YoForgetPwdController alloc] init];
    [self.navigationController pushViewController:forgetVc animated:YES];
}


- (void)didClickPrivacyHandler {
    
}

- (void)didClickQQLoginHandler {
    [QMUITips showLoadingInView:self.view];
    [ShareSDK authorize:SSDKPlatformTypeQQ settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            CheckThirdRegService *checkApi = [[CheckThirdRegService alloc] initWithUid:user.uid];
            [checkApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                BOOL isExist = [request.responseJSONObject[@"result"][@"value"] boolValue];
                if (!isExist) {
                    [QMUITips hideAllTipsInView:self.view];
                    YoChooseSexViewController *sexVc = [[YoChooseSexViewController alloc] init];
                    sexVc.uid = user.uid;
                    sexVc.loginType = YoLoginTypeQQ;
                    sexVc.accessToken = user.credential.token;
                    [self.navigationController pushViewController:sexVc animated:YES];
                } else {
                    LoginService *loginApi = [[LoginService alloc] initWithPhone:@"" password:@"" openId:user.uid accessToken:user.credential.token];
                    [loginApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [QMUITips hideAllTipsInView:self.view];
                        NSDictionary *userDict = [request.responseJSONObject objectForKey:@"result"];
                        [YoTool saveUserInfo:userDict];
                        YoUserDefault.loginType = YoLoginTypeQQ;
                        
                        YoTabBarViewController *tabBarViewController = [[YoTabBarViewController alloc] init];
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        appDelegate.window.rootViewController = tabBarViewController;
                    } failure:^(JSError *error) {
                        [QMUITips hideAllTipsInView:self.view];
                        [QMUITips showError:error.errorDescription inView:self.view];
                    }];
                }
            } failure:^(JSError *error) {
                [QMUITips hideAllTipsInView:self.view];
                [QMUITips showError:error.errorDescription inView:self.view];
            }];
        } else if (state == SSDKResponseStateFail) {
            [QMUITips hideAllTipsInView:self.view];
        } else if (state == SSDKResponseStateCancel) {
            [QMUITips hideAllTipsInView:self.view];
        }
    }];
    
}


#pragma mark - YoInputTextViewDelegate
- (void)YoInputTextView:(YoInputTextView *)inputTextView textViewType:(YoInputTextViewType)type inputTextViewChanged:(NSString *)text {
    switch (type) {
        case YoInputTextViewTypePhone:
            self.phoneStr = text;
            break;
        case YoInputTextViewTypePWD:
            self.pwdStr = text;
            break;
        default:
            break;
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat textFieldmargin = 0;
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.view.mas_top).offset(20 + self.qmui_navigationBarMaxYInViewCoordinator);
    }];
    
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.phoneView.mas_bottom).offset(textFieldmargin);
    }];
    
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdView.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.pwdView.mas_bottom).offset(RatioZoom(80));
    }];
    
    
    
    // qq登录
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), PixelOne));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.qqLoginBtn.mas_top).offset(-20);
    }];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.lineView);
    }];
    
    [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(RatioZoom(-50));
    }];
    
    CGSize tipsLabelSize = [self.tipsLabel.text sizeWithFont:13 maxW:SCREEN_WIDTH];
    CGSize userPrivacyBtnSize = [self.userPrivacyBtn.titleLabel.text sizeWithFont:13 maxW:SCREEN_WIDTH];
    CGFloat width = tipsLabelSize.width + userPrivacyBtnSize.width;
    CGFloat margin = (self.view.qmui_width - width) / 2;
    // 用户隐私
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(RatioZoom(-30));
        make.left.equalTo(self.view).offset(margin);
    }];
    
    [self.userPrivacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipsLabel);
        make.left.equalTo(self.tipsLabel.mas_right);
    }];

}

@end
