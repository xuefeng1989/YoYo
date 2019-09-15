//
//  YoWalletViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoWalletViewController.h"
#import "YoAuthenticationViewController.h"
#import "YoWithDrawRulesViewController.h"
#import "RechargeVC.h"

#import "YoDialogViewController.h"

#import <Masonry.h>

@interface YoWalletViewController ()
{
     QMUIModalPresentationViewController *modalViewController;
}
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) QMUILabel *descriptionLabel;
@property (nonatomic, strong) UIView *buyView;
@property (nonatomic, strong) QMUIFillButton *buyButton;
@property (nonatomic, strong) QMUILabel *balanceTitleL;
@property (nonatomic, strong) QMUILabel *balanceLabel;
@property (nonatomic, strong) UIView *sepV;

@property (nonatomic, strong) QMUILabel *rateTitleL;
@property (nonatomic, strong) QMUIButton *rate1;
@property (nonatomic, strong) QMUIButton *rate2;

@property(nonatomic, strong) QMUILabel *withDrawTitleLabel;
@property(nonatomic, strong) UIView *withDrawBackgroundView;
@property(nonatomic, strong) QMUIButton *ruleBtn;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UITextField *withDrawField;
@property (nonatomic, strong) QMUIFillButton *withDrawBtn;

@property(nonatomic, strong) QMUITextField *accountField;
@property(nonatomic, strong) QMUITextField *nameField;
@property (nonatomic, strong) QMUIFillButton *commitBtn;
@end

@implementation YoWalletViewController
- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorGrayBackGround;
    
    [self.tableView addSubview:self.iconImageView];
    [self.tableView addSubview:self.descriptionLabel];
    [self.tableView addSubview:self.buyView];
    [self.buyView addSubview:self.balanceTitleL];
    [self.buyView addSubview:self.sepV];
    [self.buyView addSubview:self.balanceLabel];
    
    self.buyButton = [[QMUIFillButton alloc] init];
    self.buyButton.fillColor = UIColorGlobal;
    [self.buyButton setTitle:@"充值" forState:UIControlStateNormal];
    self.buyButton.titleLabel.font = UIFontMake(14);
    [self.buyButton addTarget:self action:@selector(rechargeClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.buyView addSubview:self.buyButton];
    
    
    // 提现
    self.withDrawBackgroundView = [[UIView alloc] init];
    self.withDrawBackgroundView.backgroundColor = UIColorWhite;
    self.withDrawBackgroundView.layer.cornerRadius = 3;
    [self.tableView addSubview:self.withDrawBackgroundView];
    
    self.withDrawTitleLabel = [[QMUILabel alloc] init];
    self.withDrawTitleLabel.text = @"提现金额";
    self.withDrawTitleLabel.textColor = UIColorBlackFont;
    self.withDrawTitleLabel.font = UIFontBoldMake(16);
    [self.withDrawBackgroundView addSubview:self.withDrawTitleLabel];
    
    self.ruleBtn = [[QMUIButton alloc] init];
    [self.ruleBtn setTitle:@"提现规则?" forState:UIControlStateNormal];
    [self.ruleBtn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
    self.ruleBtn.titleLabel.font = UIFontBoldMake(14);
    [self.ruleBtn addTarget:self action:@selector(didClickRuleEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.withDrawBackgroundView addSubview:self.ruleBtn];
   
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorSeparator;
    [self.withDrawBackgroundView addSubview:self.lineView];
    
    self.withDrawField = [[QMUITextField alloc] init];
    self.withDrawField.placeholder = @"输入金额";
    self.withDrawField.textColor = UIColorGlobal;
    self.withDrawField.font = UIFontBoldMake(20);
    [self.withDrawBackgroundView addSubview:self.withDrawField];

    self.withDrawBtn = [[QMUIFillButton alloc] init];
    self.withDrawBtn.fillColor = UIColorGlobal;
    [self.withDrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    self.withDrawBtn.titleLabel.font = UIFontMake(14);
    [self.withDrawBtn addTarget:self action:@selector(didClickWithDrawEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.withDrawBackgroundView addSubview:self.withDrawBtn];
    
    
    [self.tableView addSubview:self.rateTitleL];
    [self.tableView addSubview:self.rate1];
    [self.tableView addSubview:self.rate2];
    
    
}

- (void)setAccountBalances:(NSNumber *)accountBalances
{
    _accountBalances = accountBalances;
    _balanceLabel.text = [NSString stringWithFormat:@"%.2f", accountBalances.floatValue];
}
#pragma mark - Event
- (void)rechargeClickEvent {
    [self presentChargeView];
}

- (void)didClickCharageMoneyBtn:(QMUIButton *)btn {
    // 点击充值具体金额
    [modalViewController hideWithAnimated:YES completion:^(BOOL finished) {
        
    }];
    RechargeVC *vc = [[RechargeVC alloc] init];
    vc.orderType = @"BUY_COIN";
    [self.navigationController pushViewController:vc animated:YES];
    [vc buy:@"com.wjw.smsq.yunbi_1"];
}

- (void)didClickCommitBtnEvent {
    JSLogInfo(@"money:%@  %@  %@", self.withDrawField.text, self.accountField.text, self.nameField.text);
}

- (void)didClickRuleEvent {
    YoWithDrawRulesViewController *ruleVC = [[YoWithDrawRulesViewController alloc] init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (void)didClickWithDrawEvent {
    NSString *stringRegex = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";
    NSPredicate *money = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    BOOL flag = [money evaluateWithObject:self.withDrawField.text];
    if (flag) {
        JSLogInfo(@"%f", [self.withDrawField.text floatValue]);
        if (YoUserDefault.authStatus == YoAuthStatusSuccess) {
            // 开放日才可以提现
            BOOL isWithDrawDate = YES;
            if (isWithDrawDate) {
                [self presentWithdrawView];
            } else {
                YoDialogViewController *dialogViewController = [[YoDialogViewController alloc] init];
                dialogViewController.title = @"提示";
                dialogViewController.titleTintColor = UIColorGlobal;
                dialogViewController.contentLabelString = @"提现还未到开放日，详细规则请到\n提现规则中查看";
                [dialogViewController addCancelButtonWithText:@"取消" block:nil];
                [dialogViewController addSubmitButtonWithText:@"去查看" block:^(QMUIDialogViewController *aDialogViewController) {
                    YoWithDrawRulesViewController *ruleVC = [[YoWithDrawRulesViewController alloc] init];
                    [self.navigationController pushViewController:ruleVC animated:YES];
                    [aDialogViewController hide];
                }];
                [dialogViewController show];
            }
        } else {
            YoDialogViewController *dialogViewController = [[YoDialogViewController alloc] init];
            dialogViewController.title = @"提示";
            dialogViewController.titleTintColor = UIColorGlobal;
            dialogViewController.contentLabelString = @"你还没有认证，不可以提现";
            [dialogViewController addCancelButtonWithText:@"取消" block:nil];
            [dialogViewController addSubmitButtonWithText:@"去认证" block:^(QMUIDialogViewController *aDialogViewController) {
                YoAuthenticationViewController *authVC = [[YoAuthenticationViewController alloc] init];
                [self.navigationController pushViewController:authVC animated:YES];
                [aDialogViewController hide];
            }];
            [dialogViewController show];
        }
    } else {
        [QMUITips showError:@"请输入正确的金额" inView:self.view hideAfterDelay:1.5];
    }
}


- (void)presentChargeView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275)];
    contentView.backgroundColor = UIColorWhite;
    
    CGFloat headerHeight = 55;
    QMUILabel *titleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.bounds), headerHeight)];
    titleLabel.text = @"购买云币";
    titleLabel.font = UIFontBoldMake(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerHeight - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
    lineView.layer.backgroundColor = UIColorSeparator.CGColor;
    [contentView addSubview:lineView];
    
    for (int i=1; i <= 4; i++) {
        QMUILabel *nameLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(15, headerHeight * i, CGRectGetWidth(contentView.bounds), headerHeight)];
        nameLabel.text = @"购买数量";
        [contentView addSubview:nameLabel];
        
        QMUIButton *moneyBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(contentView.qmui_width - 120, headerHeight * i, 120, headerHeight)];
        moneyBtn.titleLabel.text = @"购买数量";
        [moneyBtn setTitle:@"YB 100.00" forState:UIControlStateNormal];
        [moneyBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [moneyBtn addTarget:self action:@selector(didClickCharageMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:moneyBtn];
        
        
        UIImageView *sepView = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight * i - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
        sepView.backgroundColor = UIColorSeparator;
        [contentView addSubview:sepView];
    }
    

    modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), CGRectGetHeight(containerBounds) - CGRectGetHeight(contentView.frame));
    };
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}

// 提现 底部弹窗
- (void)presentWithdrawView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275)];
    contentView.backgroundColor = UIColorWhite;
    
    CGFloat headerHeight = 55;
    QMUILabel *titleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.bounds), headerHeight)];
    titleLabel.text = @"购买提现";
    titleLabel.font = UIFontBoldMake(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerHeight - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
    lineView.layer.backgroundColor = UIColorSeparator.CGColor;
    [contentView addSubview:lineView];
    
    // 金额
    QMUILabel *moneyTitleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(15, headerHeight, CGRectGetWidth(contentView.bounds), headerHeight)];
    moneyTitleLabel.text = @"提现金额:";
    [contentView addSubview:moneyTitleLabel];
    
    QMUIButton *moneyBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(contentView.qmui_width - 120, headerHeight, 120, headerHeight)];
    NSString *moneyStr = [NSString stringWithFormat:@"YB %.2f", [self.withDrawField.text floatValue]];
    [moneyBtn setTitle:moneyStr forState:UIControlStateNormal];
    [moneyBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
    [moneyBtn addTarget:self action:@selector(didClickCharageMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:moneyBtn];
    
    UIImageView *sepView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
    sepView1.backgroundColor = UIColorSeparator;
    [contentView addSubview:sepView1];
    
    // 账号
    QMUILabel *accountTitleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(15, headerHeight * 2, CGRectGetWidth(contentView.bounds), headerHeight)];
    accountTitleLabel.text = @"支付宝账号:";
    [contentView addSubview:accountTitleLabel];
    
    self.accountField = [[QMUITextField alloc] initWithFrame:CGRectMake(contentView.qmui_width - 200 - 15, headerHeight * 2, 200, headerHeight)];
    self.accountField.placeholder = @"请输入账号";
    self.accountField.textColor = UIColorGlobal;
    self.accountField.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:self.accountField];
    
    UIImageView *sepView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight * 2 - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
    sepView2.backgroundColor = UIColorSeparator;
    [contentView addSubview:sepView2];
    
    // 姓名
    QMUILabel *nameTitleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(15, headerHeight * 3, CGRectGetWidth(contentView.bounds), headerHeight)];
    nameTitleLabel.text = @"姓名:";
    [contentView addSubview:nameTitleLabel];
    
    self.nameField  = [[QMUITextField alloc] initWithFrame:CGRectMake(contentView.qmui_width - 200 - 15, headerHeight * 3, 200, headerHeight)];
    self.nameField.placeholder = @"姓名保密，防止汇错";
    self.nameField.textColor = UIColorGlobal;
    self.nameField.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:self.nameField];
    
    UIImageView *sepView3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight * 3 - PixelOne, CGRectGetWidth(contentView.bounds), PixelOne)];
    sepView3.backgroundColor = UIColorSeparator;
    [contentView addSubview:sepView3];
    
    // 提现按钮
    self.commitBtn = [[QMUIFillButton alloc] initWithFrame:CGRectMake(0, headerHeight * 4, CGRectGetWidth(contentView.bounds), headerHeight)];
    self.commitBtn.fillColor = UIColorGlobal;
    self.commitBtn.cornerRadius = 0;
    [self.commitBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = UIFontBoldMake(16);
    [self.commitBtn addTarget:self action:@selector(didClickCommitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.commitBtn];
    
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), CGRectGetHeight(containerBounds) - CGRectGetHeight(contentView.frame));
    };
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}




- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(70);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(15);
    }];
    CGFloat margin = 20;
    CGSize viewSize = CGSizeMake(self.view.bounds.size.width - margin * 2, 126);
    // 充值
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(viewSize);
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(35);
        make.centerX.equalTo(self.view);
    }];
    
    [self.balanceTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
    }];
    
    [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balanceTitleL.mas_bottom).offset(15);
        make.right.mas_equalTo(self.buyView);
        make.left.mas_equalTo(self.balanceTitleL);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceTitleL);
        make.top.mas_equalTo(self.sepV.mas_bottom).offset(25);
    }];

    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 35));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.balanceLabel);
    }];
    
    if (YoUserDefault.sex == YoSexTypeWoman) {
        // 提现
        [self.withDrawBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(viewSize);
            make.top.equalTo(self.buyView.mas_bottom).offset(3);
            make.centerX.equalTo(self.view);
        }];
        
        [self.withDrawTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
        }];
        
        [self.ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.withDrawTitleLabel);
            make.right.equalTo(self.withDrawBackgroundView).offset(-15);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.withDrawTitleLabel.mas_bottom).offset(15);
            make.right.mas_equalTo(self.withDrawBackgroundView);
            make.left.mas_equalTo(self.withDrawTitleLabel);
            make.height.mas_equalTo(PixelOne);
        }];
        
        [self.withDrawField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(150);
            make.left.mas_equalTo(self.withDrawTitleLabel);
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(25);
        }];
        
        [self.withDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 35));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.withDrawField);
        }];
        
        // 汇率小知识
        [self.rateTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.withDrawBackgroundView.mas_bottom).offset(50);
            make.left.mas_equalTo(20);
        }];

    } else {
        // 汇率小知识
        [self.rateTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buyView.mas_bottom).offset(50);
            make.left.mas_equalTo(20);
        }];
    }
    
    

    [self.rate1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateTitleL);
        make.top.mas_equalTo(self.rateTitleL.mas_bottom).offset(15);
    }];

    [self.rate2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateTitleL);
        make.top.mas_equalTo(self.rate1.mas_bottom).offset(0);
    }];
    
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"钱包";
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 35;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.image = UIImageMake(@"icon_pay_logo");
    }
    return _iconImageView;
}

- (QMUILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [QMUILabel new];
        _descriptionLabel.text = @"在【哟哟APP】里面所有的收益\n都会进入这里，你可以向我们提交申请处理\n这些云币";
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = UIColorSUBContentFont;
        _descriptionLabel.font = UIFontMake(13);
        
    }
    return _descriptionLabel;
}

- (UIView *)buyView {
    if (!_buyView) {
        _buyView = [[UIView alloc] init];
        _buyView.backgroundColor = UIColorWhite;
        _buyView.layer.cornerRadius = 3;
    }
    return _buyView;
}

- (QMUILabel *)balanceTitleL {
    if (!_balanceTitleL) {
        _balanceTitleL = [[QMUILabel alloc] init];
        _balanceTitleL.text = @"账户余额";
        _balanceTitleL.textColor = UIColorBlackFont;
        _balanceTitleL.font = UIFontBoldMake(16);
    }
    return _balanceTitleL;
}

- (UIView *)sepV {
    if (!_sepV) {
        _sepV = [[UIView alloc] init];
        _sepV.backgroundColor = UIColorSeparator;
    }
    return _sepV;
}

- (QMUILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[QMUILabel alloc] init];
        _balanceLabel.text = [NSString stringWithFormat:@"%.2f", YoUserDefault.balance];
        _balanceLabel.textColor = UIColorGlobal;
        _balanceLabel.font = UIFontBoldMake(30);
    }
    return _balanceLabel;
}

- (QMUILabel *)rateTitleL {
    if (!_rateTitleL) {
        _rateTitleL = [[QMUILabel alloc] init];
        _rateTitleL.text = @"汇率小知识";
        _rateTitleL.textColor = UIColorBlackFont;
        _rateTitleL.font = UIFontBoldMake(16);
    }
    return _rateTitleL;
}

- (QMUIButton *)rate1 {
    if (!_rate1) {
        _rate1 = [[QMUIButton alloc] init];
        [_rate1 setTitle:@"1.00 人民币 = 1.00 云币" forState:UIControlStateNormal];
        [_rate1 setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [_rate1 setImage:[UIImage imageNamed:@"icon_wallet_dollar"] forState:UIControlStateNormal];
        _rate1.titleLabel.font = UIFontBoldMake(14);
        _rate1.spacingBetweenImageAndTitle = 5;
        _rate1.adjustsButtonWhenHighlighted = NO;

    }
    return _rate1;
}

- (QMUIButton *)rate2 {
    if (!_rate2) {
        _rate2 = [[QMUIButton alloc] init];
        [_rate2 setTitle:@"提示：云币仅限呦呦APP内使用" forState:UIControlStateNormal];
        [_rate2 setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [_rate2 setImage:[UIImage imageNamed:@"icon_wallet_tips"] forState:UIControlStateNormal];
        _rate2.titleLabel.font = UIFontBoldMake(14);
        _rate2.spacingBetweenImageAndTitle = 5;
        _rate2.adjustsButtonWhenHighlighted = NO;
    }
    return _rate2;
}
@end
