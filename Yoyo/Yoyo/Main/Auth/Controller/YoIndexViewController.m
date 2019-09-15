//
//  YoLoginViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoIndexViewController.h"
#import "YoCommonNavigationController.h"
#import "YoLoginViewController.h"
#import "YoRegisterViewController.h"
#import "YoTabBarViewController.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "YoTool.h"
#import "LoginService.h"
#import "CheckThirdRegService.h"
#import "YoChooseSexViewController.h"

@interface YoIndexViewController ()
@property(nonatomic, strong) UIImageView *backgroudView;
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIButton *loginBtn;
@property(nonatomic, strong) QMUIFillButton *registerBtn;

@property(nonatomic, strong) UIImageView *leftLineView;
@property(nonatomic, strong) UIImageView *rightLineView;
@property(nonatomic, strong) QMUILabel *introLabel;
@property(nonatomic, strong) QMUIButton *qqLoginBtn;
@end

@implementation YoIndexViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.backgroudView = [[UIImageView alloc] init];
//    self.backgroudView.backgroundColor = UIColorGray;
    self.backgroudView.image = UIImageMake(@"index_background");
    [self.view addSubview:self.backgroudView];
    
    
    self.titleLabel = [[QMUILabel alloc] init];
    self.titleLabel.text = @"yoyo哟哟";
    self.titleLabel.textColor = UIColorWhite;
    [self.view addSubview:self.titleLabel];

    
    self.loginBtn = [[QMUIButton alloc] init];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = UIFontMake(14);
    [self.loginBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(didClickLoginHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    
    self.registerBtn = [[QMUIFillButton alloc] initWithFillColor:UIColorWhite titleTextColor:UIColorGlobal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = UIFontMake(14);
    [self.registerBtn addTarget:self action:@selector(didClickRegisterHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    
    // 底部第三方登录
    self.leftLineView = [[UIImageView alloc] init];
    self.leftLineView.backgroundColor = UIColorMake(180, 180, 180);
    [self.view addSubview:self.leftLineView];
    
    self.rightLineView = [[UIImageView alloc] init];
    self.rightLineView.backgroundColor = UIColorMake(180, 180, 180);
    [self.view addSubview:self.rightLineView];
    
    self.introLabel = [[QMUILabel alloc] init];
    self.introLabel.text = @"快速登录";
    self.introLabel.font = UIFontMake(13);
    self.introLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.introLabel.textAlignment = NSTextAlignmentCenter;
    self.introLabel.textColor = UIColorGrayFont;
    [self.view addSubview:self.introLabel];
    
    self.qqLoginBtn = [[QMUIButton alloc] init];
    [self.qqLoginBtn setImage:UIImageMake(@"icon_qq_login") forState:UIControlStateNormal];
    [self.qqLoginBtn addTarget:self action:@selector(didClickQQLoginHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qqLoginBtn];
    
}

#pragma mark - event
- (void)didClickLoginHandler {
    YoLoginViewController *loginVc = [[YoLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (void)didClickRegisterHandler {
    YoRegisterViewController *registerVc = [[YoRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];

}

- (void)didClickQQLoginHandler {
    YoUserDefault.loginType = YoLoginTypeQQ;
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
                        EMError *error = [[EMClient sharedClient] loginWithUsername:userDict[@"imUsername"] password:userDict[@"imPassword"]];
                        if (!error) {
                            NSLog(@"登录成功");
                        }
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


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    [self.backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(RatioZoom(100));
        make.left.equalTo(self.view.mas_left).offset(40);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(RatioZoom(320));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(13);
    }];
    
    
    // qq登录
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.qqLoginBtn.mas_top).offset(-20);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.introLabel.mas_left);
        make.centerY.equalTo(self.introLabel);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.introLabel.mas_right);
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.introLabel);
    }];
    

    [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(RatioZoom(-50));
    }];
    
}



#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorClear];;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorClear size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}

- (UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoIndexViewController";
}


@end
