//
//  YoOtherFemaleViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherFemaleViewController.h"
#import "YoOtherHeaderView.h"
#import "YoOtherTableViewCell.h"
#import "YoOtherFooterView.h"
#import "YoMineHeaderView.h"
#import "YoMineNormalCell.h"
#import "YoMineUploadCell.h"
#import "YoMemberController.h"
#import "YoMineBindPhoneController.h"
#import "YoWalletViewController.h"
#import "YoMineFansViewController.h"

#import "YoMinePickerView.h"
#import "YoMinePickerViewManager.h"
#import "YoMinePhotoController.h"
#import "YoMineFemaleTableViewCell.h"
#import "YoOtherPhotoCell.h"
#import "YoReportViewController.h"

#import "YoBaseEvaluateView.h"
#import "YoDialogViewController.h"
#import "YoMineHeaderModel.h"
#import "UIView+Extension.h"
#import "YoUserInfoNetrequestService.h"
#import "YoImageModel.h"

#import "BlackHandlerService.h" // 拉黑用户
#import "GKPhotoBrowser.h"
#import "YoDataingAndNotificationController.h"
#import "CustomAlertView.h"
#import "EvaluateService.h"
#import "YoEvaluateModel.h"
#import "YoOrderModel.h"
#import "YoVIPConfigService.h"
#import "YoConfigVipModel.h"
#import "YoCreatOrderService.h"
#import "YoAuthenticationViewController.h"
#import "YoSingleChatViewController.h"

@interface YoOtherFemaleViewController ()<UITableViewDataSource, UITableViewDelegate, YoOtherPhotoCellDelegate, YoBaseEvaluateViewDelegate>
{
    QMUIModalPresentationViewController *modalViewController;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YoMineHeaderView *headerView;
@property (nonatomic, strong) YoOtherFooterView *footerView;
@property (nonatomic, strong) YoMinePickerView *authPickerView;
@property (nonatomic, strong) NSArray *itemArray;
@property(nonatomic, strong) NSMutableArray *photoArray;
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
@property(nonatomic, strong) YoMineHeaderModel *userModel;
@property(nonatomic, assign) NSInteger vipCount;
@property(nonatomic, strong) YoConfigVipModel *configModel;// 购买联系方式model
@property(nonatomic, strong) YoOtherTableViewCellConfig *wenxinConfig;
@end

@implementation YoOtherFemaleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YoUserInfoNetrequestService *service = [[YoUserInfoNetrequestService alloc] initWithUserNo:self.userNo.integerValue];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        self.userModel = [[YoMineHeaderModel alloc] init];
        [self.userModel setValuesForKeysWithDictionary:data];
        self.footerView.isHiddenRelationButton = self.userModel.isMan;
        [self verbDataSource];
    } failure:^(JSError *error) {
        
    }];
}
- (void)verbDataSource{
    self.headerView.model = self.userModel;
    
    if (self.userModel.buyContact) {
        _wenxinConfig = [[YoOtherTableViewCellConfig alloc] initWithTitle:@"微信" rightImageString:@"mine_arrow" rightTitle:self.userModel.weixin rightTitleColor:[UIColor qmui_colorWithHexString:@"#FF001F"] hideRightImage:YES];
    }else {
        _wenxinConfig = [[YoOtherTableViewCellConfig alloc] initWithTitle:@"微信" rightImageString:@"mine_eye" rightTitle:@"已填写，点击查看" rightTitleColor:[UIColor qmui_colorWithHexString:@"#FF001F"] hideRightImage:NO];
    }
    
    if (self.userModel.isMan) {
        self.itemArray = @[
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的写真集" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的广播" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的介绍" rightImageString:@"mine_arrow" rightTitle:self.userModel.introduce rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                           ];
    } else {
        self.itemArray = @[
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"她的写真集" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"她的广播" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"她的介绍" rightImageString:@"mine_arrow" rightTitle:self.userModel.introduce rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"她会节目" rightImageString:@"mine_arrow" rightTitle:@"收费约会" rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"约会条件" rightImageString:@"mine_arrow" rightTitle:@"收费约会" rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                          _wenxinConfig,
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"语言" rightImageString:@"mine_arrow" rightTitle:self.userModel.language rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                           [[YoOtherTableViewCellConfig alloc] initWithTitle:@"情感" rightImageString:@"mine_arrow" rightTitle:@"单身" rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                           ];
    }
    
    [self prepareImageArr];//
    [self.tableView reloadData];
}
- (void)prepareImageArr{
    NSMutableArray *imageArr = [NSMutableArray array];
    NSInteger photoArrCount = (self.userModel.photos.count > 7 )? 7 :(self.userModel.photos.count);
    [imageArr addObjectsFromArray:[self.userModel.photos subarrayWithRange:NSMakeRange(0, photoArrCount)]];
    YoImageModel *model = [[YoImageModel alloc] initWithType:YoMineUploadCollectionViewCellTypeInviteUpload photo:[UIImage imageNamed:@"mine_photo_white_add"] imageUrl:@""];
    [imageArr addObject:model];
    self.photoArray = imageArr;
}
- (void)initSubviews {
    [super initSubviews];
    [self initNavigationPopView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.authPickerView];
}
- (void)initNavigationPopView {
    __weak __typeof(self)weakSelf = self;
    self.popupAtBarButtonItem = [[QMUIPopupMenuView alloc] init];
    self.popupAtBarButtonItem.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupAtBarButtonItem.maximumWidth = 180;
    self.popupAtBarButtonItem.shouldShowItemSeparator = YES;
    self.popupAtBarButtonItem.itemTitleFont = UIFontMake(16);
    self.popupAtBarButtonItem.itemTitleColor = UIColorBlackFont;
    self.popupAtBarButtonItem.items = @[
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"") title:@"拉黑用户" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            [weakSelf popBlack];
                                        }],
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"") title:@"举报用户" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            YoReportViewController *reportVc = [[YoReportViewController alloc] init];
                                            reportVc.title = @"举报用户";
                                            reportVc.userNo =[NSString stringWithFormat:@"%@",self.userModel.userNo] ;
                                            [weakSelf.navigationController pushViewController:reportVc animated:YES];
                                        }]
                                        ];
    
}
- (void)popBlack{
    BlackHandlerService *serVer = [[BlackHandlerService alloc] initWithUserNo:self.userModel.userNo.integerValue handler:BlackHandlerTypeAdd];
    [serVer js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips showInfo:@"拉黑成功"];
    } failure:^(JSError *error) {
        [QMUITips showInfo:@"拉黑失败，稍后再试"];
    }];
}
- (void)setupNavigationItems {
    [super setupNavigationItems];
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"mine_more"] target:self action:@selector(moreButtonDidClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_back_black"] target:self action:@selector(handleNavLeftBarButtonEvent)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark - Event
- (void)moreButtonDidClicked {
    if (self.popupAtBarButtonItem.isShowing) {
        [self.popupAtBarButtonItem hideWithAnimated:YES];
    } else {
        // 相对于右上角的按钮布局
        self.popupAtBarButtonItem.sourceBarItem = self.navigationItem.rightBarButtonItem;
        [self.popupAtBarButtonItem showWithAnimated:YES];
    }
}

- (void)handleNavLeftBarButtonEvent {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.userModel.isMan) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.userModel.isMan) {
        if (section == 1) {
            return self.itemArray.count;
        }
        return 1;
    }
    
    if (section == 2) {
        return self.itemArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userModel.isMan) {
        if (indexPath.section == 0) {
            CGFloat h = 0;
            if (self.photoArray.count <= 4) {// 一排
                h = 120;
            } else {// 两排
                h = 200;
            }
            return h;
        } else {
            return 50;
        }
    }
    if (indexPath.section == 1) {
        CGFloat h = 0;
        if (self.photoArray.count <= 4) {// 一排
            h = 120;
        }else {// 两排
            h = 200;
        }
        return h;
    }else {
        if (indexPath.section == 0) {
            return 110;
        }
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.userModel.isMan) {
        if (indexPath.section == 0) {
            YoOtherPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uploadCell"];
            cell.delegate = self;
            cell.dataArray = self.photoArray;
            return cell;
        }
    } else {
        if (indexPath.section == 0) {
            YoMineFemaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"female"];
            [cell setWeight:self.userModel.weight Height:self.userModel.hight Chest:self.userModel.chest andText:@""];
            return cell;
        }
        if (indexPath.section == 1) {
            YoOtherPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uploadCell"];
            cell.delegate = self;
            cell.dataArray = self.photoArray;
            return cell;
        }
    }
    YoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    cell.config = self.itemArray[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userModel.isMan) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [self femalPortraitHandler];
            } else if (indexPath.row == 1) {
                [self _appointmentHandler];
            } else if (indexPath.row == 2) {
               
            }
        }
    } else {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [self _portraitHandler];
            } else if (indexPath.row == 1) {
                [self _appointmentHandler];
            } else if (indexPath.row == 2) {
                
            } else if (indexPath.row == 3) {
                
            } else if (indexPath.row == 4) {
               
            } else if (indexPath.row == 5) {
                if (self.userModel.buyContact && self.userModel.weixin) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = self.userModel.weixin;
                    [QMUITips showSucceed:@"已复制"];
                }else{
                    [self didClickRelationHandle];
                }
            }
        }
    }
}
#pragma mark - did 点击写真集
- (void)femalPortraitHandler{
    if (YoUserDefault.authStatus == YoAuthStatusSuccess) {
        [self goToPhotoAlbum];
    }else{
        [self creatJumpAuthenticate:@"写真集" message:@"只有认证的用户才能访问写真集"];
    }
}

- (void)creatJumpAuthenticate:(NSString *)title  message:(NSString *)message
{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"去认证" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        // 跳转认证界面
        [self goToauthenticate];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorGrayFont,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
- (void)_portraitHandler {
    if (!YoUserDefault.isVip) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"暂不开通" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"去开通" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [self didClickMemberHandler];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"你还不是会员，无法使用写真集\n请开通会员" preferredStyle:QMUIAlertControllerStyleAlert];
        alertController.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorGrayFont,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    } else {
        [self goToPhotoAlbum];
    }
}
#pragma mark - 写真集 跳转入口
- (void)goToPhotoAlbum{
    
}
#pragma mark - did 跳转广播
- (void)_appointmentHandler {
    YoDataingAndNotificationController *controller = [[YoDataingAndNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - did Event
- (void)presentEvaluate:(NSArray *)dataArray
{
    YoBaseEvaluateView *contentView = [[YoBaseEvaluateView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 250)];
    contentView.isShowEvaluateBtn = YES;
    contentView.delegate = self;
    contentView.dataArray = dataArray;
    [contentView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar]];
    contentView.nicknameString = self.userModel.userName;
    modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), (CGRectGetHeight(containerBounds) - CGRectGetHeight(contentView.frame))/2 );
    };
    [modalViewController showWithAnimated:YES completion:nil];
}
#pragma mark 点击评价
- (void)didClickEvaluteHandle {  //
    EvaluateService *evaApi = [[EvaluateService alloc] initWithUserNo:[self.userModel.userNo integerValue]];
    evaApi.handlerType = BaseRequestHandlerTypeGET;
    [evaApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *evaArr = request.responseJSONObject[@"result"][@"list"];
        NSMutableArray *tempImageArr = [NSMutableArray array];
        for (NSDictionary *dic in evaArr) {
            YoEvaluateModel *model = [[YoEvaluateModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [tempImageArr addObject:model];
        }
        [self presentEvaluate:tempImageArr];
    } failure:^(JSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark 点击私聊
- (void)didClickChatHandle {
    if (self.userModel.buyContact) {
    [self chatAction];
    }else{
        [self didClickRelationHandle];
    }
}
- (void)femalDidClickChatHandle{
    if (YoUserDefault.authStatus == YoAuthStatusSuccess) {
        [self chatAction];
    }else{
         [self creatJumpAuthenticate:@"获取联系方式" message:@"只有认证的用户才能主动发起私聊"];
    }
}
-(void)chatAction{
    YoSingleChatViewController *chatController = [[YoSingleChatViewController alloc] initWithConversationChatter:self.userModel.imUsername conversationType:EMConversationTypeChat];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatController];
    chatController.userName = self.userModel.userName;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark  身份认证
- (void)goToauthenticate{
    YoAuthenticationViewController *authVC = [[YoAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authVC animated:YES];
}
- (void)didClickCanecelHandler {
    [modalViewController hideWithAnimated:YES completion:nil];
}
#pragma mark VIP Page Action
- (void)didClickMemberHandler { //
    [self didClickCanecelHandler];
    YoMemberController *memberVC = [[YoMemberController alloc] init];
    YoOrderItemRequestModel *requestModel = [YoOrderItemRequestModel vip_Buy];
    memberVC.orderType = requestModel.type;
    memberVC.userNo = self.userNo;
    [memberVC setBlock:^{
        
    }];
    [self.navigationController pushViewController:memberVC animated:YES];
}
#pragma mark 获取订单逻辑 只有购买
- (void)didClickPayHandlerBuyOnly {
    YoOrderItemRequestModel *requestModel = [YoOrderItemRequestModel connect_Buy];
    YoVIPConfigService *service = [[YoVIPConfigService alloc] init];
    service.configType = requestModel.type;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSMutableArray *netArray = [NSMutableArray array];
        NSArray *dataList = data[@"list"];
        for (NSDictionary *dic  in dataList) {
            YoConfigVipModel *model = [[YoConfigVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [netArray addObject:model];
        }
        self.configModel =[netArray firstObject];
        if(self.configModel.itemModel.coin.integerValue > YoUserDefault.balance){
            YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
            walletVC.accountBalances = [NSNumber numberWithFloat:YoUserDefault.balance];
            [self.navigationController pushViewController:walletVC animated:YES];
        }else{
            [self orderActionl];
        }
    } failure:^(JSError *error) {
        NSLog(@" ***error %@  *** ",error);
    }];
}
#pragma mark 获取订单逻辑
- (void)didClickPayHandler {
    YoOrderItemRequestModel *requestModel = [YoOrderItemRequestModel connect_Buy];
    YoVIPConfigService *service = [[YoVIPConfigService alloc] init];
    service.configType = requestModel.type;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSMutableArray *netArray = [NSMutableArray array];
        NSArray *dataList = data[@"list"];
        for (NSDictionary *dic  in dataList) {
            YoConfigVipModel *model = [[YoConfigVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [netArray addObject:model];
        }
        [self orderAction:[netArray firstObject]];
    } failure:^(JSError *error) {
        NSLog(@" ***error %@  *** ",error);
    }];
}
- (void)orderAction:(YoConfigVipModel *)model{
    _configModel = model;
    if(model.itemModel.coin.integerValue > YoUserDefault.balance){
        YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
        walletVC.accountBalances = [NSNumber numberWithFloat:YoUserDefault.balance];
        [self.navigationController pushViewController:walletVC animated:YES];
    }else{
        NSString *message = [NSString stringWithFormat:@"查看%@资料和私聊他", self.userModel.userName];
        NSString *buyTitle = [NSString stringWithFormat:@"付费查看和私聊 (%@ 个云币)", model.itemModel.coin];
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"联系他" message:message cancelButtonTitle:@"取消" otherButtonTitles:buyTitle,@"成为会员，免费查看", nil];
        [alertView setSelctBtnBlock:^(NSInteger index, NSString * _Nullable btnCurrentTitle) {
            if (index == 0) {
                [self orderActionl];
            }else if (index == 1){
                [self didClickMemberHandler];
            }
        }];
        alertView.titleBackgroundColor = UIColorWhite;
        alertView.titleTextColor = UIColorBlackFont;
        alertView.titleTextFont = UIFontMake(20);
        alertView.otherBtnTextColor = UIColorRed;
        alertView.otherBtnTextFont = UIFontMake(16);
        alertView.cancelBtnTextColor = UIColorGrayFont;
        [alertView show];
    }
}
- (void)orderActionl{
    YoCreatOrderService *service = [[YoCreatOrderService alloc] init];
    service.requestType = YoCreatOrderServiceOrderCreate;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userNo forKey:@"toUserNo"];
    [dic setObject:@"BUY_CONTACT" forKey:@"orderType"];
    [dic setObject:_configModel.dictCode forKey:@"dictCode"];
    service.params = dic;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips showSucceed:@"支付成功"];
        self.userModel.buyContact = YES;
        [self verbDataSource];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSNumber *totalMoney = data[@"totalMoney"];
        YoUserDefault.balance = totalMoney.floatValue;
    } failure:^(JSError *error) {
        [QMUITips showError:[NSString stringWithFormat:@"%@",error]];
    }];
}
#pragma mark 点击联系方式
- (void)didClickRelationHandle {
    if (YoUserDefault.isVip && YoUserDefault.vipCounter > 0) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"不使用" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"使用" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            // 使用一次
              [self didClickPayHandlerBuyOnly];
            YoUserDefault.vipCounter -= 1;
        }];
        NSString *content = [NSString stringWithFormat:@"你今天有10次会员特权，\n还剩下%ld次，继续使用吗？", (long)YoUserDefault.vipCounter];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"获取联系方式" message:content preferredStyle:QMUIAlertControllerStyleAlert];
        alertController.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorGrayFont,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    } else if (YoUserDefault.isVip && YoUserDefault.vipCounter == 0){ // 购买
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"不购买" style:QMUIAlertActionStyleCancel handler:NULL];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"购买" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            // 购买
            [self didClickPayHandlerBuyOnly];
        }];
        NSString *content = @"你今天有10次会员特权,已用尽,购买联系方式";
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"获取联系方式" message:content preferredStyle:QMUIAlertControllerStyleAlert];
        alertController.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorGrayFont,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }else{
        [self didClickPayHandler];
    }
}
#pragma mark - YoBaseEvaluateViewDelegate
- (void)YoBaseEvaluateViewSelectedEvaluateTagArray:(NSArray *)array {
     [self didClickCanecelHandler];
    if (self.userModel.buyContact || self.userModel.buyedContact) {
        if (!array) {
            return;
        }
        YoEvaluateModel *model = [array firstObject];
        EvaluateService *evaApi = [[EvaluateService alloc] initWithUserNo:[self.userModel.userNo integerValue]];
        evaApi.handlerType = BaseRequestHandlerTypePOST;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.dictCode forKey:@"dictCode"];
        [dic setObject:model.dictValue forKey:@"dictValue"];
        [dic setObject:YoUserDefault.userNo forKey:@"signedUser"];
        evaApi.params = dic;
        [evaApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips showSucceed:@"评价成功"];
        } failure:^(JSError *error) {
            [QMUITips showError:@"评价失败"];
        }];
    }else{
        [self judgeAction];
    }
}
//评价权限问题
- (void)judgeAction{
     NSString *content = [NSString stringWithFormat:@"你暂时没有评价权限，需先购买她联系方式"];
    if (self.userModel.isMan) {
        content = [NSString stringWithFormat:@"你暂时没有评价权限，需对方购买你联系方式后"];
    }
    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:nil];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"评价" message:content preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorGrayFont,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
    [alertController addAction:action];
    [alertController showWithAnimated:YES];
}
#pragma mark - YoOtherPhotoCellDelegate
- (void)otherPhotoCell:(YoOtherPhotoCell *)cell didSelectedIndex:(NSInteger)index {
    YoImageModel *model = self.photoArray[index];
    if (model.imageType == YoMineUploadCollectionViewCellTypeInviteUpload) {
        [QMUITips showInfo:@"邀请发布照片"];
    }else{
        NSMutableArray *imageArr = [NSMutableArray array];
        for (YoImageModel *model in self.userModel.photos) {
            GKPhoto *photo = [GKPhoto new];
            photo.url =[NSURL URLWithString:model.photo];
            photo.imageType = model.imageType;
            photo.imageId = model.imageId;
            photo.userNo = [NSString stringWithFormat:@"%@",self.userModel.userNo];
            photo.isSelf = NO;
            [imageArr addObject:photo];
        }
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:imageArr currentIndex:index];
        browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
        browser.showStyle = GKPhotoBrowserShowStylePush;
        [browser showFromVC:self];
    }
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT+NavigationContentTop) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[YoOtherTableViewCell class] forCellReuseIdentifier:@"normalCell"];
        [_tableView registerClass:[YoOtherPhotoCell class] forCellReuseIdentifier:@"uploadCell"];
        [_tableView registerClass:[YoMineFemaleTableViewCell class] forCellReuseIdentifier:@"female"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (YoMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YoMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200) isSelf:NO];
        _headerView.model = self.userModel;
    }
    return _headerView;
}

- (YoOtherFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[YoOtherFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _footerView.isHiddenRelationButton = self.userModel.isMan;
       if (self.userModel.isMan) {
           [_footerView.commentButton addTarget:self action:@selector(didClickEvaluteHandle) forControlEvents:UIControlEventTouchUpInside];
           [_footerView.chatButton addTarget:self action:@selector(femalDidClickChatHandle) forControlEvents:UIControlEventTouchUpInside];
       }else{
           [_footerView.commentButton addTarget:self action:@selector(didClickEvaluteHandle) forControlEvents:UIControlEventTouchUpInside];
           [_footerView.chatButton addTarget:self action:@selector(didClickChatHandle) forControlEvents:UIControlEventTouchUpInside];
           [_footerView.relationButton addTarget:self action:@selector(didClickRelationHandle) forControlEvents:UIControlEventTouchUpInside];
       }
    }
    return _footerView;

}


- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 控制表头图片的放大
    if (scrollView.contentOffset.y < 0) {
        self.headerView.ya = scrollView.contentOffset.y;
        self.headerView.offset = self.headerView.height + fabs(scrollView.contentOffset.y);
        
    }else{
        // 复原
        self.headerView.ya = 0;
        self.headerView.offset = self.headerView.height;
    }
    
}


#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorClear];;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorClear size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}

- (UIColor *)navigationBarTintColor {
    return UIColorWhite;
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YosssMineViewController";
}

@end
