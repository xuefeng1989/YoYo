//
//  YoForgetPwdController.m
//  Yoyo
//
//  Created by ning on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoForgetPwdController.h"

#import "YoInputTextView.h"

#import <Masonry.h>
#import "SMSCodeService.h"
#import "ForgetPwdService.h"

@interface YoForgetPwdController () <YoInputTextViewDelegate>
@property(nonatomic, strong) YoInputTextView *phoneView;
@property(nonatomic, strong) YoInputTextView *pwdView;
@property(nonatomic, strong) YoInputTextView *codeView;
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *pwdStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, strong) QMUIButton *nextBtn;
@end

@implementation YoForgetPwdController
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
    self.pwdView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePWD textViewTitle:@"密码"];
    self.pwdView.delegate = self;
    [self.view addSubview:self.pwdView];
    
    
    self.nextBtn = [[QMUIButton alloc] init];
    [self.nextBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = UIFontMake(14);
    [self.nextBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(didClickNextHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    
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
    SMSCodeService *smsApi = [[SMSCodeService alloc] initWithPhone:self.phoneStr sendType:YoSendSMSTypeForget];
    [smsApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        [self startDown:btn];
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view];
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


#pragma mark - event
- (void)didClickNextHandler {
    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
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
    ForgetPwdService *forgetApi = [[ForgetPwdService alloc] initWithPhone:self.phoneStr password:self.pwdStr smsCode:self.codeStr];
    [forgetApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        BOOL isSuccess = [request.responseJSONObject[@"result"][@"value"] boolValue];
        [QMUITips hideAllTipsInView:self.view];
        if (!isSuccess) {
            [QMUITips showError:@"重置密码失败" inView:self.view];
        } else {
            QMUITips *tips = [QMUITips showSucceed:@"重置密码成功" inView:self.view hideAfterDelay:1.5];
            tips.didHideBlock = ^(UIView *hideInView, BOOL animated) {
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
    
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"找回密码";
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
    
    
}



@end
