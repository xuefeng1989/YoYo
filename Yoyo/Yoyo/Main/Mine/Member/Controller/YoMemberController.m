//
//  YoMemberController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMemberController.h"
#import "YoWalletViewController.h"
#import <Masonry.h>
#import "Const.h"
#import "YoMineMemberView.h"
#import "YoMemberBuyBottomView.h"
#import "YoVIPConfigService.h"
#import "YoConfigVipModel.h"
#import "UIView+Recognizer.h"
#import "YoCreatOrderService.h"

@interface YoMemberController ()

@property (nonatomic, strong) UIImageView *backgroudView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) QMUILabel *titleL;
@property (nonatomic, strong) UIView *sepV;
@property (nonatomic, strong) QMUILabel *descriptionLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *array;
/// 底部弹窗
@property (nonatomic, strong) YoMemberBuyBottomView *buyBottomView;
/// 选择将要续费的金额
@property(nonatomic, assign) CGFloat openingMoney;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableArray *netDataArray;
@end

@implementation YoMemberController
- (void)initSubviews {
    [super initSubviews];
    
    self.backgroudView = [[UIImageView alloc] init];
    self.backgroudView.image = UIImageMake(@"index_background");
    [self.view addSubview:self.backgroudView];
   
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.backgroundColor = UIColorClear;
    
    self.titleL = [[QMUILabel alloc] init];
    self.titleL.font = UIFontBoldMake(20);
    self.titleL.text = @"会员特权";
    self.titleL.textColor = [UIColor whiteColor];
    [self.tableView addSubview:self.titleL];
    
    self.sepV = [[UIView alloc] init];
    self.sepV.backgroundColor = UIColorSeparator;
    [self.tableView addSubview:self.sepV];
    
    self.descriptionLabel = [QMUILabel new];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textColor = UIColorWhite;
    self.descriptionLabel.font = UIFontMake(13);
    self.descriptionLabel.text = @"【高级玩家】进驻写真集，享受高级别待遇【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【【更久】专享优质女士 高颜值女士【无限】无限发广播【更久】看的更久，阅后即焚看的更久【更久】免费获取女士的联系方式或查\n\n看女士付费相册每天10次\n\n【更久】解锁女士私聊更久】专享优质女士 高颜值女士\n\n【更久】优先体【更久】专享优质女士 高颜值女士\n\n【更久】优先体【更久】专享优质女士 高颜值女士\n\n【更久】优先体【更久】专享优质女士 高颜值女士【更久】优先体【更久】专享优质女士 高颜值女士\n\n【更久】优先体【更久】专享优质女士 高颜值女士更久】优先体【更久】专享优质女士 高颜值女士\n\n【更久】优先体验新来";
    [self.tableView addSubview:self.descriptionLabel];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.buyBottomView];
}

- (void)setOrderType:(NSString *)orderType
{
    _orderType = orderType;
    YoVIPConfigService *service = [[YoVIPConfigService alloc] init];
    service.configType = orderType;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *dataList = data[@"list"];
        for (NSDictionary *dic  in dataList) {
            YoConfigVipModel *model = [[YoConfigVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.netDataArray addObject:model];
            if ([self.orderType isEqualToString:@"BUY_CONTACT"] || [self.orderType isEqualToString: @"BUY_PHOTO"]) {
                [self payRightNowWithMOdel:[self.netDataArray firstObject]];
            }else{
                [self prepareDataList];
            }
        }
    } failure:^(JSError *error) {
        NSLog(@" ***error %@  *** ",error);
    }];
}
- (void)payRightNowWithMOdel:(YoConfigVipModel *)model{
    self.buyBottomView.model = model;
    [self show: [NSString stringWithFormat:@"%@",model.itemModel.coin]];
    self.openingMoney = 300;
}
- (void)prepareDataList{
    self.array = [NSMutableArray array];
    for (int i = 0; i < self.netDataArray.count; i++) {
        YoMineMemberView *memberV = [[YoMineMemberView alloc] init];
        YoConfigVipModel *model = self.netDataArray[i];
        memberV.model = model;
        memberV.commitButton.tag = i;
        [memberV.commitButton addTarget:self action:@selector(openMemberEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:memberV];
        [self.array addObject:memberV];
        [self layoutSubviewForSelf];
    }
}

- (void)layoutSubviewForSelf{
    [self.backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView).offset(15);
        make.top.equalTo(self.tableView).offset(10);
    }];
    
    [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL.mas_bottom).offset(15);
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view).offset(-15);
        
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.sepV.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    
    CGFloat x = (SCREEN_WIDTH-RatioZoom(345))*0.5;
    CGFloat y = CGRectGetMaxY(self.descriptionLabel.frame) + 15;
    CGFloat w = RatioZoom(345);
    CGFloat h = 50;
    for (int i = 0; i < self.array.count; i++) {
        YoMineMemberView *memberView = self.array[i];
        memberView.frame = CGRectMake(x, y+i*(h+8), w, h);
    }
    self.tableView.contentSize = CGSizeMake(self.view.qmui_width, y+self.array.count*(h+8) + 20 );
}

- (NSMutableArray *)netDataArray
{
    if (!_netDataArray) {
        _netDataArray = [NSMutableArray array];
    }
    return _netDataArray;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutSubviewForSelf];

}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"会员中心";
}

#pragma mark - Event
/// 点击开通按钮
- (void)openMemberEvent:(UIButton *)button {
    YoConfigVipModel *model = self.netDataArray[button.tag];
     [self payRightNowWithMOdel:model];
}

/// 点击底部弹窗我的钱包按钮
- (void)walletClickEvent {
//    YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
//    [self.navigationController pushViewController:walletVC animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismiss];
//    });
}

/// 点击底部弹窗我的钱包按钮
- (void)signMemberClickEvent {
//    if (YoUserDefault.balance < self.openingMoney) {
//        QMUITips *tips = [QMUITips showError:@"账户余额不足,请充值后操作" inView:self.view];
//        tips.didHideBlock = ^(UIView * _Nonnull hideInView, BOOL animated) {
//            YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
//            [self.navigationController pushViewController:walletVC animated:YES];
//        };
//    } else {
//        // 充值请求
//    }
}
#pragma mark - present view
- (void)show:(NSString *)money {
    self.coverView.hidden = NO;
    self.buyBottomView.hidden = NO;
    self.buyBottomView.moneyString = money;
    [UIView animateWithDuration:0.2 animations:^{
        self.buyBottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.buyBottomView.transform = CGAffineTransformMakeTranslation(0, 310);
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.buyBottomView.hidden = YES;
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
    return [UIColor whiteColor];
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoMemberController";
}


#pragma mark - lazy load
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.frame = self.view.bounds;
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _coverView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (YoMemberBuyBottomView *)buyBottomView {
    if (!_buyBottomView) {
        _buyBottomView = [[YoMemberBuyBottomView alloc] init];
        _buyBottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-310, SCREEN_WIDTH, 310);
        _buyBottomView.hidden = YES;
        _buyBottomView.transform = CGAffineTransformMakeTranslation(0, 310);
//        [_buyBottomView.walletButton addTarget:self action:@selector(walletClickEvent) forControlEvents:UIControlEventTouchUpInside];
//        [_buyBottomView.buyButton addTarget:self action:@selector(signMemberClickEvent) forControlEvents:UIControlEventTouchUpInside];
        __weak __typeof(self)weakSelf = self;
        [_buyBottomView.bottomView whenTapped:^{
            [weakSelf orderAction:weakSelf.buyBottomView.model];
        }];
    }
    return _buyBottomView;
}
- (void)orderAction:(YoConfigVipModel *)model{
    YoCreatOrderService *service = [[YoCreatOrderService alloc] init];
    service.requestType = YoCreatOrderServiceOrderCreate;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userNo forKey:@"toUserNo"];
    [dic setObject:self.orderType forKey:@"orderType"];
    [dic setObject:model.dictCode forKey:@"dictCode"];
    if ([self.orderType isEqualToString:@"BUY_PHOTO"]) {
         [dic setObject:self.imageId forKey:@"data"];
    }
    service.params = dic;
    __weak __typeof(self)weakSelf = self;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        weakSelf.block();
        [QMUITips showSucceed:@"支付成功"];
        if ([self.orderType isEqualToString:@"BUY_VIP"]) {
            YoUserDefault.isVip = true;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(JSError *error) {
        [QMUITips showError:[NSString stringWithFormat:@"%@",error]];
    }];
}
@end
