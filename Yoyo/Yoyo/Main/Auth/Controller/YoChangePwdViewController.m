//
//  YoChangePwdViewController.m
//  Yoyo
//
//  Created by ningcol on 2019/7/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoChangePwdViewController.h"

#import "YoInputTextView.h"
#import <Masonry.h>
#import "ChangePwdService.h"

@interface YoChangePwdViewController () <YoInputTextViewDelegate>
@property(nonatomic, strong) YoInputTextView *oldPwdView;
@property(nonatomic, strong) YoInputTextView *pwdView;
@property(nonatomic, copy) NSString *oldPwdStr;
@property(nonatomic, copy) NSString *pwdStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, strong) QMUIButton *nextBtn;

@end

@implementation YoChangePwdViewController
- (void)initSubviews {
    [super initSubviews];
    
    // 旧密码 textField
    self.oldPwdView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePWD textViewTitle:@"旧密码"];
    self.oldPwdView.delegate = self;
    [self.view addSubview:self.oldPwdView];
    
    // 密码textField
    self.pwdView = [[YoInputTextView alloc] initWithFrame:CGRectZero textViewType:YoInputTextViewTypePWD textViewTitle:@"新密码"];
    self.pwdView.delegate = self;
    [self.view addSubview:self.pwdView];
    
    
    self.nextBtn = [[QMUIButton alloc] init];
    [self.nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = UIFontMake(14);
    [self.nextBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(didClickNextHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    
}



#pragma mark - YoInputTextViewDelegate
- (void)YoInputTextView:(YoInputTextView *)inputTextView textViewType:(YoInputTextViewType)type inputTextViewChanged:(NSString *)text {
    if (inputTextView == self.oldPwdView) {
        self.oldPwdStr = text;
    }
    if (inputTextView == self.pwdView) {
        self.pwdStr = text;
    }
}


#pragma mark - event
- (void)didClickNextHandler {
    if (StringIsEmpty(self.oldPwdStr)) {
        [QMUITips showInfo:@"请原密码" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.pwdStr)) {
        [QMUITips showInfo:@"请输入密码" inView:self.view];
        return;
    }
    
    [QMUITips showLoadingInView:self.view];
    ChangePwdService *changeApi = [[ChangePwdService alloc] initWithOldPwd:self.oldPwdStr password:self.pwdStr];
    [changeApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
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
    self.title = @"修改密码";
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat textFieldmargin = 0;
    
    [self.oldPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.view.mas_top).offset(20 + self.qmui_navigationBarMaxYInViewCoordinator);
    }];
    
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(self.view.qmui_width, 60));
        make.top.equalTo(self.oldPwdView.mas_bottom).offset(textFieldmargin);
    }];
    
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.pwdView.mas_bottom).offset(RatioZoom(40));
    }];
    
    
}


@end
