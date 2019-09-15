//
//  YoAuthenticationViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/1.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAuthenticationViewController.h"

#import <Masonry.h>
#import "HXPhotoPicker.h"
#import "UIImage+Extension.h"

#import "AuthCodeService.h"
#import "UploadImageService.h"
#import "AuthService.h"

@interface YoAuthenticationViewController ()

@property(nonatomic, strong) UIImageView *backImageView;
//@property(nonatomic, strong) QMUILabel *titleLabel;

@property(nonatomic, strong) UIImageView *avatarImageView;

@property(nonatomic, strong) QMUILabel *firstTitleLabel;
@property(nonatomic, strong) QMUILabel *firstContentLabel;
@property(nonatomic, strong) UIView *sepV;
@property(nonatomic, strong) QMUILabel *secondTitleLabel;
@property(nonatomic, strong) QMUILabel *secondContentLabel;
@property(nonatomic, strong) QMUILabel *numberLabel;
@property(nonatomic, strong) QMUILabel *tipsFontLabel;
@property(nonatomic, strong) QMUILabel *tipsBackLabel;
@property(nonatomic, strong) UIImageView *trueImageView;
@property(nonatomic, strong) QMUIFillButton *uploadButton;

@property(nonatomic, strong) HXPhotoManager *manager;


@end

@implementation YoAuthenticationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AuthCodeService *codeApi = [[AuthCodeService alloc] init];
    [codeApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(JSError *error) {
        [QMUITips showError:error.errorDescription inView:self.view];
    }];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.tableView addSubview:self.backImageView];

    [self.tableView addSubview:self.avatarImageView];
    [self.tableView addSubview:self.firstTitleLabel];
    [self.tableView addSubview:self.firstContentLabel];
    [self.tableView addSubview:self.sepV];
    
    [self.tableView addSubview:self.secondTitleLabel];
    [self.tableView addSubview:self.secondContentLabel];
    [self.tableView addSubview:self.numberLabel];
    [self.tableView addSubview:self.uploadButton];
    [self.tableView addSubview:self.tipsFontLabel];
    [self.tableView addSubview:self.trueImageView];
    [self.tableView addSubview:self.tipsBackLabel];
    
    
    AuthCodeService *codeApi = [[AuthCodeService alloc] init];
    [codeApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *code = request.responseJSONObject[@"result"][@"value"];
        self.numberLabel.text = code;
    } failure:^(JSError *error) {
        [QMUITips showError:error.errorDescription inView:self.view];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(-self.qmui_navigationBarMaxYInViewCoordinator);
        make.size.mas_equalTo(CGSizeMake(self.tableView.qmui_width, 200));
    }];
    
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(20);
        make.height.with.mas_equalTo(80);
    }];
    
    [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(20);
    }];
    
    [self.firstContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.firstTitleLabel.mas_bottom).offset(15);
    }];
    
    [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.firstContentLabel.mas_bottom).offset(15);
    }];
    
    [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.sepV.mas_bottom).offset(RatioZoom(15));
    }];
    
    [self.secondContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.secondTitleLabel.mas_bottom).offset(15);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.secondContentLabel).offset(25);
    }];
    
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.secondContentLabel.mas_bottom).offset(40);
    }];
    
    [self.tipsFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.uploadButton.mas_bottom).offset(20);
    }];
    
    [self.trueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsFontLabel.mas_right);
        make.centerY.mas_equalTo(self.tipsFontLabel);
    }];
    
    [self.tipsBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.trueImageView.mas_right);
        make.centerY.mas_equalTo(self.tipsFontLabel);
    }];
}

#pragma mark - method
- (void)uploadButtonDidClicked {
    __weak __typeof(self)weakSelf = self;

    [self hx_presentCustomCameraViewControllerWithManager:self.manager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
        NSMutableArray *imageArr = [NSMutableArray array];
        NSMutableArray *widthArr = [NSMutableArray array];
        NSMutableArray *heightArr = [NSMutableArray array];
        
        [weakSelf.manager afterListAddCameraTakePicturesModel:model];
        
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
            JSLogInfo(@"---finalImage:%@", NSStringFromCGSize(finalImage.size));
            
            NSNumber *width = [NSNumber numberWithFloat:finalImage.size.width];
            NSNumber *height = [NSNumber numberWithFloat:finalImage.size.height];
            [imageArr addObject:finalImage];
            [widthArr addObject:width];
            [heightArr addObject:height];
          
            [QMUITips showLoadingInView:weakSelf.view];
            UploadImageService *imgApi = [[UploadImageService alloc] initWithImageArray:imageArr type:YoUploadImgTypeAvatar widthArray:widthArr heightArray:heightArr];
            [imgApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSArray *imgArr = request.responseJSONObject[@"result"][@"list"];
                NSString *imgUrl = [imgArr.firstObject objectForKey:@"url"];
                
                AuthService *authApi = [[AuthService alloc] initWithAuthCode:self.numberLabel.text authPicUrl:imgUrl];
                [authApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    BOOL isOK = [request.responseJSONObject[@"result"][@"value"] boolValue];
                    if (!isOK) {
                        [QMUITips showError:request.responseJSONObject[@"result"][@"desc"] inView:self.view];
                    } else {
                        QMUITips *tips = [QMUITips showSucceed:@"提交审核成功" inView:self.view hideAfterDelay:1.5];
                        tips.didHideBlock = ^(UIView *hideInView, BOOL animated) {
                            [self.navigationController popViewControllerAnimated:YES];
                        };
                    }
                    
                } failure:^(JSError *error) {
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
                }];
            } failure:^(JSError *error) {
                [QMUITips hideAllTipsInView:weakSelf.view];
                [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
            }];
            
        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            
        }];
    } cancel:^(HXCustomCameraViewController *viewController) {
        JSLogInfo(@"取消了");
    }];
}


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.singleSelected = YES;
        
        _manager.configuration.creationDateSort = YES;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showOriginalBytes = YES;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.hideOriginalBtn = YES;
        
    }
    return _manager;
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
    return UIStatusBarStyleLightContent;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoAuthenticationViewController";
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"认证中心";
}

#pragma mark - lazy load
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.backgroundColor = UIColorGlobal;
    }
    return _backImageView;
}


- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"mine_auth_avatar"];
    }
    return _avatarImageView;
}

- (QMUILabel *)firstTitleLabel {
    if (!_firstTitleLabel) {
        _firstTitleLabel = [[QMUILabel alloc] init];
        _firstTitleLabel.text = @"认证女士特权，约会成功概率提升200%";
        _firstTitleLabel.font = UIFontBoldMake(16);
        _firstTitleLabel.textColor = UIColorContentFont;
    }
    return _firstTitleLabel;
}

- (QMUILabel *)firstContentLabel {
    if (!_firstContentLabel) {
        _firstContentLabel = [[QMUILabel alloc] init];
        _firstContentLabel.text = @"1、“真实”的身份图标\n\n2、免费发广播\n\n3、直接和男士私聊打招呼";
        _firstContentLabel.font = UIFontMake(13);
        _firstContentLabel.textColor = UIColorSUBContentFont;
        _firstContentLabel.numberOfLines = 0;
    }
    return _firstContentLabel;
}

- (UIView *)sepV {
    if (!_sepV) {
        _sepV = [[UIView alloc] init];
        _sepV.backgroundColor = UIColorSeparator;
    }
    return _sepV;
}

- (QMUILabel *)secondTitleLabel {
    if (!_secondTitleLabel) {
        _secondTitleLabel = [[QMUILabel alloc] init];
        _secondTitleLabel.text = @"认证方式：手写纸条+拍照认证";
        _secondTitleLabel.font = UIFontBoldMake(16);
        _secondTitleLabel.textColor = UIColorContentFont;
    }
    return _secondTitleLabel;
}

- (QMUILabel *)secondContentLabel {
    if (!_secondContentLabel) {
        _secondContentLabel = [[QMUILabel alloc] init];
        _secondContentLabel.text = @"1、在纸条上写下：以下认证码，字迹清晰\n\n\n\n2、用该纸条与本人面部的合照，并且上传等待通过。";
        _secondContentLabel.font = UIFontMake(13);
        _secondContentLabel.textColor = UIColorSUBContentFont;
        _secondContentLabel.numberOfLines = 0;
    }
    return _secondContentLabel;
}

- (QMUILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[QMUILabel alloc] init];
//        _numberLabel.text = @"663050";
        _numberLabel.font = UIFontBoldMake(16);
        _numberLabel.textColor = UIColorGlobal;
    }
    return _numberLabel;
}

- (UIImageView *)trueImageView {
    if (!_trueImageView) {
        _trueImageView = [[UIImageView alloc] init];
        _trueImageView.image = [UIImage imageNamed:@"mine_true"];
    }
    return _trueImageView;
}

- (QMUILabel *)tipsFontLabel {
    if (!_tipsFontLabel) {
        _tipsFontLabel = [[QMUILabel alloc] init];
        _tipsFontLabel.text = @"认证成功后，你的头像旁边会带有";
        _tipsFontLabel.font = UIFontMake(13);
        _tipsFontLabel.textColor = UIColorSUBContentFont;
    }
    return _tipsFontLabel;
}

- (QMUILabel *)tipsBackLabel {
    if (!_tipsBackLabel) {
        _tipsBackLabel = [[QMUILabel alloc] init];
        _tipsBackLabel.text = @"的身份图标";
        _tipsBackLabel.font = UIFontMake(13);
        _tipsBackLabel.textColor = UIColorSUBContentFont;
    }
    return _tipsBackLabel;
}

- (QMUIFillButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [[QMUIFillButton alloc] init];
        _uploadButton.fillColor = UIColorGlobal;
        [_uploadButton setTitle:@"立即拍照" forState:UIControlStateNormal];
        _uploadButton.titleLabel.font = UIFontBoldMake(14);
        [_uploadButton addTarget:self action:@selector(uploadButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}
@end
