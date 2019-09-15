//
//  YoMineBindPhoneController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineBindPhoneController.h"
#import "YoMineBindView.h"

#import <Masonry.h>
#import "SMSCodeService.h"
#import "BindMoblieService.h"

@interface YoMineBindPhoneController () <YoMineBindViewDelegate>
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) QMUIButton *tipButton;
@property (nonatomic, strong) YoMineBindView *phoneV;
@property(nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YoMineBindView *smsV;
@property (nonatomic, strong) QMUIButton *sureButton;

@property(nonatomic, strong) NSString *phoneStr;
@property(nonatomic, strong) NSString *codeStr;


@end

@implementation YoMineBindPhoneController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorGrayBackGround;
    
    [self.tableView addSubview:self.logoImageView];
    [self.tableView addSubview:self.tipButton];
    [self.tableView addSubview:self.phoneV];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorSeparator;
    [self.tableView addSubview:self.lineView];
    
    [self.tableView addSubview:self.smsV];
    [self.tableView addSubview:self.sureButton];
    

}

#pragma mark - Event
- (void)clickCommitEvent {
    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.codeStr)) {
        [QMUITips showInfo:@"请输入验证码" inView:self.view];
        return;
    }
    BindMoblieService *bindApi = [[BindMoblieService alloc] initWithPhone:self.phoneStr smsCode:self.codeStr];
    [bindApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        BOOL isSuccess = [request.responseJSONObject[@"result"][@"value"] boolValue];
        if (!isSuccess) {
            [QMUITips showError:@"绑定失败" inView:self.view];
        } else {
            QMUITips *tips = [QMUITips showSucceed:@"绑定成功" inView:self.view hideAfterDelay:1.5];
            tips.didHideBlock = ^(UIView *hideInView, BOOL animated) {
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];

}

- (void)clickCodeEvent:(UIButton *)btn {

    if (StringIsEmpty(self.phoneStr)) {
        [QMUITips showInfo:@"请输入手机号" inView:self.view];
        return;
    }
    
    [QMUITips showLoadingInView:self.view];
    SMSCodeService *smsApi = [[SMSCodeService alloc] initWithPhone:self.phoneStr sendType:YoSendSMSTypeBanding];
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

#pragma mark - YoMineBindViewDelegate
- (void)bingView:(YoMineBindView *)view changedTextField:(nonnull QMUITextField *)textField {
    if (view == self.phoneV) {
        self.phoneStr = textField.text;
    }
    if (view == self.smsV) {
        self.codeStr = textField.text;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(33);
    }];
    
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(20);
    }];
    
    [self.phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipButton.mas_bottom).offset(50);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneV.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(PixelOne);
    }];
    
    [self.smsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smsV.mas_bottom).offset(8);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];

}

#pragma mark - lazy load
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"mine_bind_phone"];
    }
    return _logoImageView;
}

- (QMUIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [[QMUIButton alloc] init];
        [_tipButton setImage:[UIImage imageNamed:@"mine_bind_tip"] forState:UIControlStateNormal];
        [_tipButton setTitle:@"绑定手机号让你的账号更安全" forState:UIControlStateNormal];
        [_tipButton setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        _tipButton.titleLabel.font = UIFontBoldMake(13);
        _tipButton.spacingBetweenImageAndTitle = 8;
        _tipButton.adjustsButtonWhenHighlighted = NO;
    }
    return _tipButton;
}


- (YoMineBindView *)phoneV {
    if (!_phoneV) {
        _phoneV = [[YoMineBindView alloc] init];
        _phoneV.delegate = self;
        _phoneV.leftLabel.text = @"+ 86";
        _phoneV.leftLabel.font = UIFontBoldMake(16);
        _phoneV.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _phoneV.textField.placeholder = @"请输入手机号";
    }
    return _phoneV;
}

- (YoMineBindView *)smsV {
    if (!_smsV) {
        _smsV = [[YoMineBindView alloc] init];
        _smsV.delegate = self;
        _smsV.leftLabel.text = @"验证码";
        _smsV.textField.placeholder = @"请输入验证码";
        _smsV.leftLabel.font = UIFontBoldMake(16);
        _smsV.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        [_smsV.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_smsV.rightButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [_smsV.rightButton addTarget:self action:@selector(clickCodeEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _smsV;
}

- (QMUIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[QMUIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        _sureButton.titleLabel.font = UIFontBoldMake(16);
        _sureButton.backgroundColor = UIColorWhite;
        [_sureButton addTarget:self action:@selector(clickCommitEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
