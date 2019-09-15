//
//  YoMineMaleViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineMaleViewController.h"
#import "YoMemberController.h"
#import "YoWalletViewController.h"
#import "YoMineBindPhoneController.h"
#import "YoMindMomentDetailViewController.h"
#import "YoDialogViewController.h"
#import "YoMineFansViewController.h"
#import "YoMineBlacklistController.h"
#import "YoInitUserInfoViewController.h"
#import "YoIndexViewController.h"
#import "YoCommonNavigationController.h"
#import "YoUserProtocolViewController.h"
#import "YoChangePwdViewController.h"
#import "YoTestViewController.h"
#import "YoMineHeaderView.h"
#import "YoMineNormalCell.h"
#import "YoMineUploadCell.h"
#import "YoMineFooterView.h"
#import "YoMinePickerView.h"
#import "YoBaseEvaluateView.h"
#import "YoBaseSelectedCellView.h"
#import "YoMinePickerViewManager.h"
#import "YoMinePhotoController.h"
#import "YoMineFemaleTableViewCell.h"
#import "YoAuthenticationViewController.h"
#import "HXPhotoPicker.h"
#import "YoUIHelper.h"
#import "YoFireCoverView.h"
#import "YoMineHeaderModel.h"

#import "UIView+Extension.h"
#import "UIImage+Extension.h"

#import "LookPermitService.h"
#import "UploadImageService.h"
#import "DateDataService.h"
#import "LogoutService.h"
#import "EvaluateService.h"
#import "YoUploadImageService.h" // 图片上传
#import "YoUserInfoNetrequestService.h"
#import "YoMineHeaderModel.h"
#import "YoImageModel.h"
#import "YoSetPhotoStatuesTypeService.h"
#import "YoFiredBrowseService.h" // 重置阅后即焚
#import "YoEvaluateModel.h"
#import "YoOrderModel.h"

@interface YoMineMaleViewController ()<UITableViewDataSource, UITableViewDelegate,YoMineUploadCellDelegate,HXCustomNavigationControllerDelegate, YoBaseEvaluateViewDelegate, YoBaseSelectedCellViewDelegate, HXPhotoViewDelegate>
@property(nonatomic, strong) HXPhotoView *photoView;
@property(nonatomic, strong) HXPhotoManager *manager;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YoMineHeaderView *headerView;
@property (nonatomic, strong) YoMineFooterView *footerView;

@property (nonatomic, strong) NSArray *array0;
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSArray *array3;
@property (nonatomic, strong) NSArray *array4;
@property (nonatomic, strong) NSArray *totalArray;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *bigPhotoArray;


@property(nonatomic, copy) NSString *bindString;/// 绑定手机、换绑手机
/// 弹出的控制器
@property(nonatomic, strong) QMUIModalPresentationViewController *modalVc;
@property(nonatomic, strong) YoBaseSelectedCellView *seletedView;/// 权限选中View
@property(nonatomic, strong) NSIndexPath *seletedIndexPath;
@property(nonatomic, strong) NSArray *statuLimitArray;/// 权限数组
@property(nonatomic, assign) NSInteger statuLimitIndex;/// 权限选中的索引
@property(nonatomic, strong) YoMineHeaderModel *userModel;//个人中心
@property(nonatomic, strong) YoMineNormalCellConfig *configNumber;
@property(nonatomic, strong) YoMineNormalCellConfig *configWallet;
@property(nonatomic, strong) YoMineNormalCellConfig *freWhenRead;//阅后即焚
@property(nonatomic, strong) YoMineNormalCellConfig *jurisdiction;//权限设置
@end

@implementation YoMineMaleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bindString = @"换绑手机";
    if (YoUserDefault.loginType == YoLoginTypeQQ) {  // qq登录还要判断是不是绑定过手机了
        self.bindString = @"绑定手机";
    }
    self.statuLimitIndex = YoUserDefault.lookPermissionStatus - 1;
    self.statuLimitArray = @[@"公开", @"隐身", @"手机号隐藏"];
    NSString *statusStr = self.statuLimitArray[self.statuLimitIndex];
    _configNumber = [[YoMineNormalCellConfig alloc] initWithTitle:@"会员" titleImageString:@"mine_member" subTitle:@"开通会员享受超级特权"];
    _configWallet = [[YoMineNormalCellConfig alloc] initWithTitle:@"我的钱包" titleImageString:@"mine_wallet" subTitle:@"100个"];
    _freWhenRead = [[YoMineNormalCellConfig alloc] initWithTitle:@"阅后即焚" titleImageString:@"mine_read" arrowImageString:@"" subTitle:@"一键恢复" subTitleColor:UIColorGlobal subImageString:@"" hideArrowImage:YES hideSeeContentView:NO];
    _jurisdiction =  [[YoMineNormalCellConfig alloc] initWithTitle:@"权限设置" titleImageString:@"mine_authority" arrowImageString:@"" subTitle:statusStr subTitleColor:UIColorGlobal subImageString:@"" hideArrowImage:YES hideSeeContentView:YES];
    self.array0 = @[_configNumber,_configWallet,
                    [[YoMineNormalCellConfig alloc] initWithTitle:self.bindString titleImageString:@"mine_bind"],
                    ];
    self.array1 = @[[[YoMineNormalCellConfig alloc] initWithTitle:@"上传照片" titleImageString:@"icon_tabbar_me"],];
    
    self.array2 = @[[[YoMineNormalCellConfig alloc] initWithTitle:@"我的写真集" titleImageString:@"mine_portrait"],];
    self.array3 = @[
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我的相册" titleImageString:@"mine_photo"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我的动态" titleImageString:@"mine_radio"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"收到的评价" titleImageString:@"mine_comment"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我的收藏" titleImageString:@"mine_foucs"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"黑名单" titleImageString:@"mine_block"],
                   _jurisdiction,
                    _freWhenRead,
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"修改密码" titleImageString:@"mine_modify"],
                    
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"分享领取红包" titleImageString:@"mine_share" arrowImageString:@"" subTitle:@"" subTitleColor:UIColorClear subImageString:@"mine_red" hideArrowImage:NO hideSeeContentView:YES],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"用户使用协议" titleImageString:@"mine_protocol"],
                    ];
    
    self.array4 = @[
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"如需帮助联系客服" titleImageString:@"" arrowImageString:@"" subTitle:@"" subTitleColor:UIColorClear subImageString:@"" hideArrowImage:YES hideSeeContentView:YES],
                    ];
    
    if (YoUserDefault.sex == YoSexTypeWoman) {
        self.array0 = @[[[YoMineNormalCellConfig alloc] initWithTitle:@"" titleImageString:@""]];
        self.array3 = @[
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"我的相册" titleImageString:@"mine_photo"],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"认证" titleImageString:@"mine_auth"],
                       _configWallet,
                        [[YoMineNormalCellConfig alloc] initWithTitle:self.bindString titleImageString:@"mine_bind"],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"我的动态" titleImageString:@"mine_radio"],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"收到的评价" titleImageString:@"mine_comment"],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"我的收藏" titleImageString:@"mine_foucs"],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"黑名单" titleImageString:@"mine_block"],
                        _jurisdiction,
                        _freWhenRead,
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"修改密码" titleImageString:@"mine_modify"],
                        
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"分享领取红包" titleImageString:@"mine_share" arrowImageString:@"" subTitle:@"" subTitleColor:UIColorClear subImageString:@"mine_red" hideArrowImage:NO hideSeeContentView:YES],
                        [[YoMineNormalCellConfig alloc] initWithTitle:@"用户使用协议" titleImageString:@"mine_protocol"],
                        ];

    }
    
    self.totalArray = @[self.array0,self.array1,self.array2,self.array3,self.array4];
}
- (void)requestMyData{
    YoUserInfoNetrequestService *service = [[YoUserInfoNetrequestService alloc] initWithUserNo:YoUserDefault.userNo.integerValue];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        [YoTool saveUserInfo:data];
        self.userModel = [[YoMineHeaderModel alloc] init];
        [self.userModel setValuesForKeysWithDictionary:data];
        [self preppareDataSource];
        [self preparePhotoArray:(NSArray *) self.userModel.photos];
    } failure:^(JSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)preppareDataSource{
    _configWallet.subTitleString = [NSString stringWithFormat:@"%@",self.userModel.accountBalances];
    _freWhenRead.photoOnce = self.userModel.photoOnce;
    self.statuLimitIndex = self.userModel.lookPermission.integerValue;
    YoUserDefault.lookPermissionStatus = self.userModel.lookPermission.integerValue;
    _jurisdiction.subTitleString =self.statuLimitArray[self.userModel.lookPermission.integerValue - 1];
}
- (void)preparePhotoArray:(NSArray *)array{
    [_photoArray removeAllObjects];
     self.headerView.model = self.userModel;
    _photoArray = nil;
    NSInteger max = (array.count > 7)? 7:array.count;
    for (NSInteger i = 0; i < max; i ++) {
        YoImageModel *model = array[i];
        [self.photoArray insertObject:model atIndex:self.photoArray.count-1];
        if (self.photoArray.count == 8) {
            break;
        }
    }
    [self.tableView reloadData];
}
- (void)initSubviews {
    [super initSubviews];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT+NavigationContentTop) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[YoMineNormalCell class] forCellReuseIdentifier:@"normalCell"];
    [self.tableView registerClass:[YoMineUploadCell class] forCellReuseIdentifier:@"uploadCell"];
    [self.tableView registerClass:[YoMineFemaleTableViewCell class] forCellReuseIdentifier:@"female"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorGrayBackGround;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestMyData];
}

#pragma mark - method
- (void)openPhoto {
    [self.manager clearSelectedList];
     HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithManager:self.manager delegate:self];
    [self presentViewController:nav animated:YES completion:nil];
}
- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 0;  //
        _manager.configuration.maxNum = 0;
    }
    return _manager;
}
- (void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController
                       didDoneAllList:(NSArray<HXPhotoModel *> *)allList
                               photos:(NSArray<HXPhotoModel *> *)photoList
                               videos:(NSArray<HXPhotoModel *> *)videoList
                             original:(BOOL)original{
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *widthArr = [NSMutableArray array];
    NSMutableArray *heightArr = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    [self showMyPhotoSelect:photoList];
    for (NSInteger i = 0;i < photoList.count;i ++ ){
            HXPhotoModel *model =photoList[i];
            [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                UIImage *nowImage = [image scaleToWidth:400];
                JSLogInfo(@"---size:%@", NSStringFromCGSize(nowImage.size));
                
                NSData *data = UIImageJPEGRepresentation(nowImage, 1.0);
                double dataLength = [data length] * 1.0;
                if (dataLength > 1024 * 1024) {
                    data = UIImageJPEGRepresentation(nowImage, 0.1);
                } else {
                    data = UIImageJPEGRepresentation(nowImage, 0.9);
                }
                UIImage *finalImage = [UIImage imageWithData:data];
                NSNumber *width = [NSNumber numberWithFloat:finalImage.size.width];
                NSNumber *height = [NSNumber numberWithFloat:finalImage.size.height];
                [imageArr addObject:finalImage];
                [widthArr addObject:width];
                [heightArr addObject:height];
                if (i == photoList.count - 1) {
                    UploadImageService *imgApi = [[UploadImageService alloc] initWithImageArray:imageArr type:YoUploadImgTypeAvatar widthArray:widthArr heightArray:heightArr];
                    [imgApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        NSArray *imgArr = request.responseJSONObject[@"result"][@"list"];
                        NSMutableArray *tempImageArr = [NSMutableArray array];
                        for (NSInteger j =0; j < imgArr.count; j ++) {
                            NSDictionary *dic  = imgArr[j];
                            if (dic[@"url"]) {
                                [tempImageArr addObject:dic[@"url"]];
                            }
                        }
                        YoUploadImageService *imageYoService = [[YoUploadImageService alloc] initWithUserImageArray:tempImageArr];
                        [imageYoService js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            NSLog(@" ****  发布成功 ***** ");
                            [self requestMyData];
                        } failure:^(JSError *error) {
                            
                        }];
                    } failure:^(JSError *error) {
                        [QMUITips hideAllTipsInView:weakSelf.view];
                        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
                    }];
                }
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                
            }];
        }
    
}
- (void)showMyPhotoSelect:(NSArray<HXPhotoModel *> *)photoList
{
        for (HXPhotoModel *photoModel in photoList) {
            if (self.photoArray.count == 8) {
                break;
            }
             YoImageModel *model = [[YoImageModel alloc] initWithType:YoMineUploadCollectionViewCellTypeNormal photo:photoModel.thumbPhoto imageUrl:@""];
            [self.photoArray insertObject:model atIndex:self.photoArray.count-1];
        }
        [self.tableView reloadData];
}
- (void)seeBig:(NSInteger)index {
    self.bigPhotoArray = [NSMutableArray array];
    if (index > self.photoArray.count - 1) {
        [QMUITips showInfo:@"图片正在上传，请稍后..."];
        return;
    }
    for (NSInteger i = 0; i < self.photoArray.count - 1; i ++) {
        YoImageModel *model = self.photoArray[i];
        if (!model.photo) {
            [QMUITips showInfo:@"图片正在上传，请稍后..."];
            return;
        }
        switch (model.imageType) {
            case YoMineUploadCollectionViewCellTypeNormal:{
                GKPhoto *photo = [GKPhoto new];
                if (model.photo) {
                    photo.url =[NSURL URLWithString:model.photo];
                    photo.imageId = model.imageId;
                    photo.isSelf = YES;
                }else{
                    [QMUITips showInfo:@"图片正在上传，请稍后..."];
                    return;
                }
                [self.bigPhotoArray addObject:photo];
            }
                break;
            case YoMineUploadCollectionViewCellTypeFire:
            {
                GKPhoto *photo = [GKPhoto new];
                if (model.photo) {
                    photo.url =[NSURL URLWithString:model.photo];
                    photo.imageId = model.imageId;
                    photo.isSelf = YES;
                }else{
                    [QMUITips showInfo:@"图片正在上传，请稍后..."];
                    return;
                }
                [self.bigPhotoArray addObject:photo];
            }
                break;
            case YoMineUploadCollectionViewCellTypePay:{
                GKPhoto *photo = [GKPhoto new];
                if (model.photo) {
                    photo.url =[NSURL URLWithString:model.photo];
                    photo.imageId = model.imageId;
                    photo.isSelf = YES;
                }else{
                    [QMUITips showInfo:@"图片正在上传，请稍后..."];
                    return;
                }
                [self.bigPhotoArray addObject:photo];
            }
                break;
            case YoMineUploadCollectionViewCellTypeMore:
            case YoMineUploadCollectionViewCellTypeUpload:{
            }
                break;
                
        }
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:self.bigPhotoArray currentIndex:index];
    browser.showStyle = GKPhotoBrowserShowStylePush;
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    [browser showFromVC:self];
}



#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.totalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.totalArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CGFloat h = 0;
        // 图片section的高度
        if (self.photoArray.count == 1) {// 空
            h = RatioZoom(196);
        }else if (self.photoArray.count <= 4 && self.photoArray.count > 1) {// 一排
            h = RatioZoom(266 - 83 - 5);
        }else if(self.photoArray.count > 4){// 两排
            h = RatioZoom(266);
        }
        return h;
    } else {
        if (YoUserDefault.sex == YoSexTypeWoman) {
            if (indexPath.section == 0) return 90;
        }
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        YoMineUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uploadCell"];
        cell.dataArray = self.photoArray;
        cell.delegate = self;
        return cell;
    }
    if (YoUserDefault.sex == YoSexTypeWoman) {
        JSLogInfo(@"-----%ld", YoUserDefault.sex);
        JSLogInfo(@"----section:%ld", indexPath.section);

        if (indexPath.section == 0) {
            YoMineFemaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"female"];
            [cell setWeight:self.userModel.weight Height:self.userModel.hight Chest:self.userModel.chest andText:@""];
            return cell;
        } else {
            YoMineNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
            if (indexPath.section == 0 && indexPath.row == 0) {
                [cell setCornerRadius];
            }else {
                [cell resetCornerRadius];
            }
            NSArray *array = self.totalArray[indexPath.section];
            YoMineNormalCellConfig *item = array[indexPath.row];
            cell.config = item;
            return cell;
        }
    }
    
    YoMineNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell setCornerRadius];
    }else {
        [cell resetCornerRadius];
    }
    NSArray *array = self.totalArray[indexPath.section];
    YoMineNormalCellConfig *item = array[indexPath.row];
    cell.config = item;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (YoUserDefault.sex == YoSexTypeMan) {
            if (indexPath.row == 0) {
                YoMemberController *memberVC = [[YoMemberController alloc] init];
                YoOrderItemRequestModel *requestModel = [YoOrderItemRequestModel vip_Buy];
                 memberVC.orderType = requestModel.type;
                 memberVC.userNo = [NSString stringWithFormat:@"%@",self.userModel.userNo];
                [memberVC setBlock:^{
                    
                }];
                [self.navigationController pushViewController:memberVC animated:YES];
            } else if (indexPath.row == 1) {
                YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
                walletVC.accountBalances = self.userModel.accountBalances;
                [self.navigationController pushViewController:walletVC animated:YES];
            } else if (indexPath.row == 2) {
                YoMineBindPhoneController *bindVC = [[YoMineBindPhoneController alloc] init];
                bindVC.title = self.bindString;
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
    } else if (indexPath.section == 2) {
        if (YoUserDefault.sex == YoSexTypeWoman) {
            if (self.userModel.authStatus == YoAuthStatusSuccess) {
                [self goToPhotoAlbum];
            }else{
                [self goToAuthenticateAction];
            }
        }else{
            if (YoUserDefault.isVip){
                [self goToPhotoAlbum];
            }else{
                [self goToVipAction];
            }
        }
    } else if (indexPath.section == 3) {
        if (YoUserDefault.sex == YoSexTypeWoman) {
            if (indexPath.row == 0) {
                YoMinePhotoController *photoVC = [[YoMinePhotoController alloc] init];
                [self.navigationController pushViewController:photoVC animated:YES];
            } else if (indexPath.row == 1) {
               [self goToauthenticate];
            } else if (indexPath.row == 2) {
                YoWalletViewController *walletVC = [[YoWalletViewController alloc] init];
                 walletVC.accountBalances = self.userModel.accountBalances;
                [self.navigationController pushViewController:walletVC animated:YES];
            } else if (indexPath.row == 3) {  // 绑定手机
                YoMineBindPhoneController *bindVC = [[YoMineBindPhoneController alloc] init];
                bindVC.title = self.bindString;
                [self.navigationController pushViewController:bindVC animated:YES];
            } else if (indexPath.row == 4) { // 我的动态
                [QMUITips showInfo:@"广播中心"];
            } else if (indexPath.row == 5) {  // 收到的评价
                [self didClickEvaluteHandle];
            } else if (indexPath.row == 6) {  // 我的关注
                YoMineFansViewController *focusVC = [[YoMineFansViewController alloc] init];
                focusVC.title = @"我的收藏";
                focusVC.isFoucsVc = YES;
                [self.navigationController pushViewController:focusVC animated:YES];
            } else if (indexPath.row == 7) { // 黑名单
                YoMineBlacklistController *blacklistVC = [[YoMineBlacklistController alloc] init];
                blacklistVC.userNo = self.userModel.userNo;
                [self.navigationController pushViewController:blacklistVC animated:YES];
            } else if (indexPath.row == 8) {
                [self presentStatusView:indexPath];
            } else if (indexPath.row == 9) {
                 [self resetFiredPhoto];
            } else if (indexPath.row == 10) {  // 修改密码
                YoChangePwdViewController *changePwdVc = [[YoChangePwdViewController alloc] init];
                [self.navigationController pushViewController:changePwdVc animated:YES];
            } else if (indexPath.row == 11) { // 分享
                [self presentShareView];
            } else if (indexPath.row == 12) { // 用户协议
                YoUserProtocolViewController *userProtocolVc = [[YoUserProtocolViewController alloc] init];
                [self.navigationController pushViewController:userProtocolVc animated:YES];
            }
        } else {
            if (indexPath.row == 0) {
                YoMinePhotoController *photoVC = [[YoMinePhotoController alloc] init];
                [self.navigationController pushViewController:photoVC animated:YES];
            } else if (indexPath.row == 1) {  // 我的动态
                [QMUITips showInfo:@"广播中心"];
            } else if (indexPath.row == 2) { // 收到的评价
                [self didClickEvaluteHandle];
            } else if (indexPath.row == 3) {  // 我的关注
                YoMineFansViewController *focusVC = [[YoMineFansViewController alloc] init];
                focusVC.title = @"我的收藏";
                focusVC.isFoucsVc = YES;
                [self.navigationController pushViewController:focusVC animated:YES];
            } else if (indexPath.row == 4) {  // 黑名单
                YoMineBlacklistController *blacklistVC = [[YoMineBlacklistController alloc] init];
                [self.navigationController pushViewController:blacklistVC animated:YES];
            } else if (indexPath.row == 5) {
                [self presentStatusView:indexPath];
            } else if (indexPath.row == 6) {
                [self resetFiredPhoto];
            } else if (indexPath.row == 7) {  // 修改密码
                YoChangePwdViewController *changePwdVc = [[YoChangePwdViewController alloc] init];
                [self.navigationController pushViewController:changePwdVc animated:YES];
            } else if (indexPath.row == 8) { // 分享
                YoMineViewController *other = [[YoMineViewController alloc] initWithType:YoMineViewControllerTypeOtherAndSexTypeMale];
                [self.navigationController pushViewController:other animated:YES];
            } else if (indexPath.row == 9) { // 用户协议
                YoUserProtocolViewController *userProtocolVc = [[YoUserProtocolViewController alloc] init];
                [self.navigationController pushViewController:userProtocolVc animated:YES];
            }
        }
        
    } else if (indexPath.section == 4) {
//        YoMineViewController *other = [[YoMineViewController alloc] initWithType:YoMineViewControllerTypeMineAndSexTypeFemale];
//        [self.navigationController pushViewController:other animated:YES];
        YoTestViewController *vc = [[YoTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark  - 收到的评价
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

#pragma mark - 写真集 跳转入口
- (void)goToPhotoAlbum{
    YoMindMomentDetailViewController *postDetailVc = [[YoMindMomentDetailViewController alloc] init];
    [self.navigationController pushViewController:postDetailVc animated:YES];
}
#pragma mark - VIP 跳转入口
- (void)goToVipAction{
    YoDialogViewController *dialogViewController = [[YoDialogViewController alloc] init];
    dialogViewController.title = @"写真集专区";
    dialogViewController.titleTintColor = UIColorGlobal;
    dialogViewController.contentLabelString = @"开通VIP会员，开启写真集功能，\n成为高级玩家";
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"开通会员" block:^(QMUIDialogViewController *aDialogViewController) {
        YoMemberController *memberVC = [[YoMemberController alloc] init];
        YoOrderItemRequestModel *requestModel = [YoOrderItemRequestModel vip_Buy];
        memberVC.orderType = requestModel.type;
        [memberVC setBlock:^{
            
        }];
        [self.navigationController pushViewController:memberVC animated:YES];
        [aDialogViewController hide];
    }];
     [dialogViewController show];
}
#pragma mark - 认证 跳转入口
- (void)goToAuthenticateAction{
    YoDialogViewController *dialogViewController = [[YoDialogViewController alloc] init];
    dialogViewController.title = @"写真集专区";
    dialogViewController.titleTintColor = UIColorGlobal;
    dialogViewController.contentLabelString = @"认证，开启写真集功能，\n成为高级玩家";
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"去认证" block:^(QMUIDialogViewController *aDialogViewController) {
        [self goToauthenticate];
        [aDialogViewController hide];
    }];
     [dialogViewController show];
}
- (void)resetFiredPhoto
{
    YoFiredBrowseService *resetService = [[YoFiredBrowseService alloc] init];
    [resetService js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
         [QMUITips showSucceed:@"阅后即焚重置成功"];
        [self requestMyData];
    } failure:^(JSError *error) {
         [QMUITips showError:@"阅后即焚重置失败"];
    }];
}
#pragma mark - YoBaseEvaluateViewDelegate
- (void)YoBaseEvaluateViewSelectedEvaluateTagArray:(NSArray *)array {
    JSLogInfo(@"seletedArray:%@", array);
}
#pragma mark - YoMineUploadCellDelegate
- (void)mineUploadCell:(YoMineUploadCell *)cell setConfigIndex:(NSInteger)configIndex cellIndex:(NSInteger)cellIndex {
    
    YoImageModel *model = self.photoArray[cellIndex];
    switch (configIndex) {
        case 1:
            model.imageType = YoMineUploadCollectionViewCellTypeFire;
            break;
        case 2:
            model.imageType = YoMineUploadCollectionViewCellTypePay;
            break;
        default:
            model.imageType = YoMineUploadCollectionViewCellTypeNormal;
            break;
    }
    if (model.photo && model.photo.length > 0) {
        YoSetPhotoStatuesTypeService *service = [[YoSetPhotoStatuesTypeService alloc] initWithUserImageModel:model];
        service.handlerType = BaseRequestHandlerTypeAdd;
        [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"设置阅后即焚成功 *** ");
            [self requestMyData];
        } failure:^(JSError *error) {
            NSLog(@"设置阅后即焚失败 *** %@",error);
        }];
    }else{
        [QMUITips showInfo:@"图片正在上传，请稍后..."];
    }
}

- (void)mineUploadCell:(YoMineUploadCell *)cell DeleteIndex:(NSInteger)index {
    [self.photoArray removeObjectAtIndex:index];
    [self.tableView reloadData];
    [self delletePhotoCellIndex:index];
}
- (void)delletePhotoCellIndex:(NSInteger)cellIndex{
    YoImageModel *model = self.photoArray[cellIndex];
    if (model.photo && model.photo.length > 0) {
        YoSetPhotoStatuesTypeService *service = [[YoSetPhotoStatuesTypeService alloc] initWithUserImageModel:model];
        service.handlerType = BaseRequestHandlerTypeRemove;
        [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"设置阅后即焚成功 *** ");
            [self requestMyData];
        } failure:^(JSError *error) {
            NSLog(@"设置阅后即焚失败 *** %@",error);
        }];
    }
}
- (void)mineUploadCell:(YoMineUploadCell *)cell didSelectedIndex:(NSInteger)index {
    if (index == self.photoArray.count-1) {
        [self openPhoto];
    }else {
        [self seeBig:index];
    }
}

- (void)mineUploadCellDidClickedAddPhotoView:(YoMineUploadCell *)cell {
    [self openPhoto];
}
- (void)presentEvaluate:(NSArray *)dataArray
{
    YoBaseEvaluateView *contentView = [[YoBaseEvaluateView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 250)];
    contentView.isShowEvaluateBtn = NO;
    contentView.delegate = self;
    [contentView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar]];
    contentView.nicknameString = self.userModel.userName;
    contentView.dataArray = dataArray;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), (CGRectGetHeight(containerBounds) - CGRectGetHeight(contentView.frame))/2 );
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
- (void)didClickTagHandler:(QMUIButton *)btn {
    JSLogInfo(@"点击了分享");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.modalVc hideWithAnimated:YES completion:^(BOOL finished) {
            
        }];
    });
}

- (void)presentShareView {
    NSArray *arr = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间"];
    NSArray *arrImg = @[@"icon_share_wx", @"icon_share_friend", @"icon_share_qq", @"icon_share_qqZone"];

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    contentView.backgroundColor = UIColorWhite;
    int count = 4;
    CGFloat pic_width = RatioZoom(58);
    CGFloat pic_height = RatioZoom(85);
    CGFloat left_margin = 0;
    for (int i=0; i < 4; i++) {
        QMUIButton *tagBtn = [[QMUIButton alloc] init];
        [tagBtn setTitle:arr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:UIColorBlackFont forState:UIControlStateNormal];
        [tagBtn setImage:UIImageMake(arrImg[i]) forState:UIControlStateNormal];
        tagBtn.imagePosition = QMUIButtonImagePositionTop;
        tagBtn.spacingBetweenImageAndTitle = 10;
        tagBtn.titleLabel.font = UIFontMake(11);
        tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

        [tagBtn addTarget:self action:@selector(didClickTagHandler:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:tagBtn];

        NSInteger row = i / count;
        NSInteger col = i % count;
        CGFloat marginX = (contentView.size.width - left_margin*2 - (pic_width * count)) / (count + 1);
        //        CGFloat marginY = (self.bounds.size.height - (pic_height * count)) / (count + 1);
        CGFloat marginY = 5;

        CGFloat picX = marginX + left_margin + (pic_width + marginX) * col;
        CGFloat picY = marginY + (pic_height + marginY + 5) * row;

        tagBtn.frame = CGRectMake(picX, picY + 6, pic_width, pic_height);

    }
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    self.modalVc = modalViewController;
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

- (void)presentStatusView:(NSIndexPath *)indexPath {  // 设置权限view
    self.seletedIndexPath = indexPath;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    contentView.backgroundColor = UIColorWhite;
    
    CGFloat headerHeight = 50;
//    NSArray *array = @[@"公开", @"隐身", @"手机号隐藏"];
    for (int i = 0; i < self.statuLimitArray.count; i ++) {
        YoBaseSelectedCellView *view = [[YoBaseSelectedCellView alloc] initWithFrame:CGRectMake(0, headerHeight * i, SCREEN_WIDTH, headerHeight)];
        view.titleLabel.text = self.statuLimitArray[i];
        if (i == (self.userModel.lookPermission.integerValue - 1)) {
            view.selected = YES;
            self.seletedView = view;
        }
        view.delegate = self;
        [contentView addSubview:view];
    }
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    self.modalVc = modalViewController;
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
#pragma mark - logout
- (void)clickLogoutBtn {
    LogoutService *logoutApi = [[LogoutService alloc] init];
    [QMUITips showLoadingInView:self.view];
    [logoutApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:self.view];
        YoUserDefault.token = @"";
//        [YoUserDefault reMoveAllData];
        [[EMClient sharedClient] logout:YES];
        YoIndexViewController *loginVc = [[YoIndexViewController alloc] init];
        YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:navVc animated:YES completion:nil];
    } failure:^(JSError *error) {
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
        [QMUITips hideAllTipsInView:self.view];
    }];
    
}




#pragma mark - YoBaseSelectedCellViewDelegate
- (void)YoBaseSelectedCellView:(YoBaseSelectedCellView *)view didSelect:(BOOL)selected {  // 权限设置选中
    JSLogInfo(@"seleted:%@",view.titleLabel.text);
    
    self.statuLimitIndex = [self.statuLimitArray indexOfObject:view.titleLabel.text];

    YoMineNormalCell *cell = [self.tableView cellForRowAtIndexPath:self.seletedIndexPath];
    cell.config.subTitleString = view.titleLabel.text;
    
    if (self.seletedView != view) {
        self.seletedView.selected = NO;
        view.selected = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.modalVc hideWithAnimated:YES completion:^(BOOL finished) {
            [self.tableView reloadRowsAtIndexPaths:@[self.seletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            LookPermitService *permitApi = [[LookPermitService alloc] initWithPermit:self.statuLimitIndex + 1];
            [permitApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                BOOL isSuccess = [request.responseJSONObject[@"result"][@"value"] boolValue];
                if (isSuccess) {
                    YoUserDefault.lookPermissionStatus = self.statuLimitIndex + 1;
                }
            } failure:^(JSError *error) {
                
            }];

        }];
    });
}

#pragma mark - didClickEvent
- (void)didClickHeaderView {  // 点击header
    YoInitUserInfoViewController *infoVc = [[YoInitUserInfoViewController alloc] init];
    infoVc.isMan = YoUserDefault.sex == YoSexTypeMan ? YES : NO;
    infoVc.isUpdateUserInfo = YES;
    [infoVc setBlock:^{
        [self requestMyData];
        
    }];
    [self.navigationController pushViewController:infoVc animated:YES];
}

#pragma mark - lazy load
- (YoMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YoMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200) isSelf:YES];
        YoMineHeaderModel *model = [[YoMineHeaderModel alloc] init];
        model.avatar = YoUserDefault.avatar;
        model.userName = YoUserDefault.nickName;
        model.location = YoUserDefault.city;
        model.age = [NSNumber numberWithInteger:YoUserDefault.ageString.integerValue];
        model.job = YoUserDefault.professionString;
        model.dateRange = YoUserDefault.appointmentAreaCodeString;
        model.authStatus = YoUserDefault.authStatus;
        _headerView.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeaderView)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (YoMineFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[YoMineFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        [_footerView.exitButton addTarget:self action:@selector(clickLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
        YoImageModel *model = [[YoImageModel alloc] initWithType:YoMineUploadCollectionViewCellTypeUpload photo:[UIImage imageNamed:@"mine_photo_white_add"] imageUrl:@""];
        [_photoArray addObject:model];
    }
    return _photoArray;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 控制表头图片的放大
    if (scrollView.contentOffset.y < 0) {
        // 向下拉多少
        self.headerView.ya = scrollView.contentOffset.y;
        self.headerView.offset = self.headerView.height + fabs(scrollView.contentOffset.y);

    }else{
        // 复原
        self.headerView.ya = 0;
        self.headerView.offset = self.headerView.height;
    }

}

@end
