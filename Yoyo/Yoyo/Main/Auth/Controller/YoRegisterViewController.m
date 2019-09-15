//
//  YoRegisterViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoRegisterViewController.h"
#import "YoChooseSexViewController.h"
#import "YoInitUserInfoViewController.h"
#import "YoTabBarViewController.h"

#import "YoInputTextView.h"

#import <Masonry.h>
#import "NSString+Extension.h"
#import "AppDelegate+ShareSDK.h"
#import "YoTool.h"
#import "NSString+RegularExpression.h"

#import "SMSCodeService.h"
#import "CheckSMSCodeService.h"
#import "CheckThirdRegService.h"
#import "PhoneService.h"
#import "LoginService.h"

@interface YoRegisterViewController () <YoInputTextViewDelegate>
@property(nonatomic, strong) YoInputTextView *phoneView;
@property(nonatomic, strong) YoInputTextView *pwdView;
@property(nonatomic, strong) YoInputTextView *codeView;
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *pwdStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, strong) QMUIButton *nextBtn;

@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, strong) QMUILabel *introLabel;
@property(nonatomic, strong) QMUIButton *qqLoginBtn;

@property(nonatomic, strong) QMUILabel *tipsLabel;
@property(nonatomic, strong) QMUIButton *userPrivacyBtn;
@end

@implementation YoRegisterViewController

- (void)initSubviews {
    [super initSubviews];
    
    
    // 登录textField
    self.phoneView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePhone textViewTitle:@"+86"];
    self.phoneView.delegate = self;
    [self.view addSubview:self.phoneView];
    
    // 验证码textField
    self.codeView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypeCode textViewTitle:@"验证码"];
    self.codeView.delegate = self;
    [self.view addSubview:self.codeView];
    
    // 密码textField
    self.pwdView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePWD textViewTitle:@"设置密码"];
    self.pwdView.delegate = self;
    [self.view addSubview:self.pwdView];
    
    
    self.nextBtn = [[QMUIButton alloc] init];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = UIFontMake(14);
    [self.nextBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(didClickNextHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    

    // 底部第三方登录
    self.lineView = [[UIImageView alloc] init];
    self.lineView.backgroundColor = UIColorSeparator;
    [self.view addSubview:self.lineView];
    
    self.introLabel = [[QMUILabel alloc] init];
    self.introLabel.text = @"快速注册";
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
    self.tipsLabel.text = @"注册即代表你阅读且同意";
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


#pragma mark - YoInputTextViewDelegate
- (void)YoInputTextView:(YoInputTextView *)inputTextView textViewType:(YoInputTextViewType)type inputTextViewChanged:(NSString *)text {
    switch (type) {
        case YoInputTextViewTypePhone:
            self.phoneStr = text;
            break;
        case YoInputTextViewTypePWD:
            self.pwdStr = text;
            break;
        case YoInputTextViewTypeCode:
            self.codeStr = text;
            break;
        default:
            break;
    }
}

- (void)YoInputTextView:(YoInputTextView *)inputTextView clickDownBtn:(UIButton *)btn {
    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
        return;
    }
    
    [QMUITips showLoadingInView:self.view];
    SMSCodeService *smsApi = [[SMSCodeService alloc] initWithPhone:self.phoneStr sendType:YoSendSMSTypeRegister];
    [smsApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        [self startDown:btn];
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view];
    }];
    
}

- (void)_checkSMSCode {
    CheckSMSCodeService *checkApi = [[CheckSMSCodeService alloc] initWithPhone:self.phoneStr sendType:YoSendSMSTypeRegister code:self.codeStr];
    [checkApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        BOOL isOK = [request.responseJSONObject[@"result"][@"value"] boolValue];
        [QMUITips hideAllTipsInView:self.view];
        if (!isOK) {
            [QMUITips showError:@"验证码不正确" inView:self.view];
        } else {
            YoChooseSexViewController *sexVc = [[YoChooseSexViewController alloc] init];
            sexVc.phoneStr = self.phoneStr;
            sexVc.pwdStr = self.pwdStr;
            sexVc.codeStr = self.codeStr;
            sexVc.loginType = YoLoginTypePhone;
            [self.navigationController pushViewController:sexVc animated:YES];
        }
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view];
    }];
}

#pragma mark - event
- (void)didClickNextHandler {
    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
        return;
    }

    if (![self.phoneStr isValidNumber]) {
        [QMUITips showInfo:@"请输入正确的手机号" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.pwdStr)) {
        [QMUITips showInfo:@"请输入密码" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.codeStr)) {
        [QMUITips showInfo:@"请输入验证码" inView:self.view];
        return;
    }
    
    [QMUITips showLoadingInView:self.view];
    PhoneService *phoneApi = [[PhoneService alloc] initWithPhone:self.phoneStr];
    [phoneApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        BOOL isExist = [request.responseJSONObject[@"result"][@"value"] boolValue];
        if (isExist) {
            [QMUITips hideAllTipsInView:self.view];
            [QMUITips showError:@"该手机已经注册" inView:self.view];
        } else {
            [self _checkSMSCode];
        }
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view];
    }];
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
//                     YoInitUserInfoViewController *infoVc = [[YoInitUserInfoViewController alloc] init];
//                     infoVc.loginType = YoLoginTypeQQ;
//                     infoVc.isMan = user.gender ? 0 : 1;
//                     infoVc.uid = user.uid;
//                     infoVc.accessToken = user.credential.token;
//                     [self.navigationController pushViewController:infoVc animated:YES];
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
     

- (void)startDown:(UIButton *)btn {
    __block int timeout = countDownSeconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"获取"];
                [str addAttribute:NSForegroundColorAttributeName value:UIColorGlobal range:NSMakeRange(0, str.length)];
                [btn setAttributedTitle:str forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            if (seconds ==00) {
                seconds = 60;
            }
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@s",strTime]];
                [str addAttribute:NSForegroundColorAttributeName value:UIColorGlobal range:NSMakeRange(0, 2)];
                [str addAttribute:NSForegroundColorAttributeName value:UIColorGrayFont range:NSMakeRange(2, 1)];
                [btn setAttributedTitle:str forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat textFieldmargin = 0;

    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.view.mas_top).offset(20 + self.qmui_navigationBarMaxYInViewCoordinator);
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.phoneView.mas_bottom).offset(textFieldmargin);
    }];
    
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.codeView.mas_bottom).offset(textFieldmargin);
    }];
    
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.pwdView.mas_bottom).offset(RatioZoom(40));
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


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"注册";
}



@end
