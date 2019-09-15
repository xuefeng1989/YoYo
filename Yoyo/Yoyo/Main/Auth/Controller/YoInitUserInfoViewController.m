//
//  YoInitUserInfoViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoInitUserInfoViewController.h"
#import <RSKImageCropViewController.h>
#import "YoTabBarViewController.h"

#import "YoBaseInfoCellView.h"
#import "YoBaseInfoTagView.h"
#import "YoSinglePickerView.h"
#import "YoTwoRowPickerView.h"
#import "YoTablePickerView.h"
#import "YoCityTablePickerView.h"
#import "YoCityPickerView.h"

#import "HXPhotoPicker.h"
#import <Masonry.h>
#import "YoTool.h"
#import "AppDelegate.h"
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>

#import "UserStaticInfoService.h"
#import "NicknameService.h"
#import "RegisterService.h"
#import "UploadImageUnAuthService.h"
#import "UserInfoService.h"


@interface YoInitUserInfoViewController () <YoBaseInfoTagViewDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) QMUILabel *uploadLabel;
@property(nonatomic, strong) YoBaseInfoCellView *nicknameView;
@property(nonatomic, strong) YoBaseInfoCellView *cityView;
@property(nonatomic, strong) YoBaseInfoCellView *appointmentAreaView;
@property(nonatomic, strong) YoBaseInfoCellView *ageView;
@property(nonatomic, strong) YoBaseInfoCellView *professionView;
@property(nonatomic, strong) QMUILabel *contactTitleLabel;
@property(nonatomic, strong) QMUILabel *contactIntrolLabel;
@property(nonatomic, strong) YoBaseInfoCellView *wxView;
@property(nonatomic, strong) YoBaseInfoCellView *qqView;
@property(nonatomic, strong) YoBaseInfoCellView *fromView;
@property(nonatomic, strong) UIImageView *lineView;

@property(nonatomic, strong) QMUILabel *introTitleLabel;
@property(nonatomic, strong) QMUILabel *introContentLabel;
@property(nonatomic, strong) YoBaseInfoTagView *tagView;
@property(nonatomic, strong) QMUIFillButton *registerBtn;

@property(nonatomic, strong) YoBaseInfoCellView *heightView;
@property(nonatomic, strong) YoBaseInfoCellView *weightView;
@property(nonatomic, strong) YoBaseInfoCellView *sizeView;
@property(nonatomic, strong) YoBaseInfoCellView *styleView;
@property(nonatomic, strong) YoBaseInfoCellView *languageView;
@property(nonatomic, strong) YoBaseInfoCellView *statusView;
@property(nonatomic, strong) YoBaseInfoCellView *appointmentItemView;
@property(nonatomic, strong) YoBaseInfoCellView *appointmentConditView;
/// dataArray
// 年龄数组
@property(nonatomic, strong) NSArray *ageArray;
@property(nonatomic, strong) NSArray *professionArray;

@property(nonatomic, strong) NSArray *heightArray;
@property(nonatomic, strong) NSArray *weightArray;
@property(nonatomic, strong) NSDictionary *sizeDict;
@property(nonatomic, strong) NSArray *styleArray;
@property(nonatomic, strong) NSArray *languageArray;
@property(nonatomic, strong) NSArray *statusArray;
@property(nonatomic, strong) NSArray *appointmentItemArray;
@property(nonatomic, strong) NSArray *appointmentConditArray;
@property(nonatomic, strong) NSArray *tagDataArray;

/// 数据
@property(nonatomic, copy) NSString *avatarUrlString;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *ageString;
@property(nonatomic, copy) NSString *professionString;
@property(nonatomic, copy) NSString *heightString;
@property(nonatomic, copy) NSString *weightString;
@property(nonatomic, copy) NSString *sizeString;
@property(nonatomic, copy) NSString *styleString;
@property(nonatomic, copy) NSString *languageString;
@property(nonatomic, copy) NSString *statusString;
@property(nonatomic, copy) NSString *appointmentItemString;
@property(nonatomic, copy) NSString *appointmentConditString;
@property(nonatomic, copy) NSString *qqString;
@property(nonatomic, copy) NSString *wxString;
@property(nonatomic, copy) NSString *fromString;
@property(nonatomic, copy) NSString *tagString;
/// 城市名称，用英文逗号分隔
@property(nonatomic, copy) NSString *appointmentAreaCodeString;

@property(nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic, strong) HXPhotoManager *manager;

@end

@implementation YoInitUserInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    [self getStaticData];
    
}
- (void)_initInfoView {
    if (self.isUpdateUserInfo) {
        [self.portraitView sd_setImageWithURL:[NSURL URLWithString:YoUserDefault.avatar] placeholderImage:UIImageMake(@"icon_portrait_placeholder")];
        self.avatarUrlString = YoUserDefault.avatar;
        
        self.nicknameView.textFieldString = YoUserDefault.nickName;
        self.nickName = YoUserDefault.nickName;
        
        self.appointmentAreaView.textLabelString = YoUserDefault.appointmentAreaCodeString;
        self.appointmentAreaCodeString = YoUserDefault.appointmentAreaCodeString;
        
        self.ageView.textLabelString = YoUserDefault.ageString;
        self.ageString = YoUserDefault.ageString;
        
        self.professionView.textLabelString = YoUserDefault.professionString;
        self.professionString = YoUserDefault.professionString;
        
        self.heightView.textLabelString = YoUserDefault.heightString;
        self.heightString = YoUserDefault.heightString;
        
        self.weightView.textLabelString = YoUserDefault.weightString;
        self.weightString = YoUserDefault.weightString;
        
        self.sizeView.textLabelString = YoUserDefault.sizeString;
        self.sizeString = YoUserDefault.sizeString;
        
        self.styleView.textLabelString = YoUserDefault.styleString;
        self.styleString = YoUserDefault.styleString;
        
        self.languageView.textLabelString = YoUserDefault.languageString;
        self.languageString = YoUserDefault.languageString;
        
        self.statusView.textLabelString = YoUserDefault.statusString;
        self.statusString = YoUserDefault.statusString;
        
        self.appointmentItemView.textLabelString = YoUserDefault.appointmentItemString;
        self.appointmentItemString = YoUserDefault.appointmentItemString;
        
        self.appointmentConditView.textLabelString = YoUserDefault.appointmentConditString;
        self.appointmentConditString = YoUserDefault.appointmentConditString;
        
        self.wxView.textFieldString = YoUserDefault.wxString;
        self.wxString = YoUserDefault.wxString;
        
        self.qqView.textFieldString = YoUserDefault.qqString;
        self.qqString = YoUserDefault.qqString;
        
        self.fromView.textFieldString = YoUserDefault.fromString;
        self.fromString = YoUserDefault.fromString;
        
        self.tagView.selectedArr = [YoUserDefault.tagString componentsSeparatedByString:@","];
        self.tagString = YoUserDefault.tagString;
    }
}

- (void)getStaticData {
    UserStaticInfoService *staticInfoApi = [[UserStaticInfoService alloc] initWithSex:_isMan];
    [staticInfoApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = request.responseJSONObject[@"result"];
        self.ageArray = result[@"ages"];
        self.professionArray = result[@"jobs"];
        self.heightArray = result[@"highs"];
        self.weightArray = result[@"weigh"];
        self.sizeDict = result[@"size"];
        self.styleArray = result[@"dressStyle"];
        self.languageArray = result[@"language"];
        self.statusArray = result[@"feeling"];
        self.appointmentItemArray = result[@"dateCondition"];
        self.appointmentConditArray = result[@"dateShow"];
        if (self.isMan) {
            self.tagDataArray = result[@"menIntroduce"];
        } else {
            self.tagDataArray = result[@"womenIntroduce"];
        }
        self.tagView.dataArray = self.tagDataArray;
        
        [self _initInfoView];
    } failure:^(JSError *error) {
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
}

- (void)checkNickName {
    NicknameService *nicknameApi = [[NicknameService alloc] initWithNickname:self.nickName];
    [nicknameApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        BOOL isExist = [request.responseJSONObject[@"result"][@"value"] boolValue];
        if (isExist) {
            [QMUITips showError:@"昵称已被使用，请重新输入" inView:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
        }
    } failure:^(JSError *error) {
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
}



- (void)initViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = UIColorWhite;
    [self.view addSubview:self.scrollView];
    
    self.portraitView = [[UIImageView alloc] init];
    self.portraitView.image = UIImageMake(@"icon_portrait_placeholder");
    self.portraitView.frame = CGRectMake(0, 0, 90, 90);
    self.portraitView.layer.cornerRadius = 90/2;
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickPortraitHandler)];
    [self.portraitView addGestureRecognizer:tap];
    self.portraitView.backgroundColor = UIColorRed;
    [self.scrollView addSubview:self.portraitView];
    
    self.uploadLabel = [[QMUILabel alloc] init];
    self.uploadLabel.text = @"上传头像";
    self.uploadLabel.font = UIFontMake(14);
    [self.scrollView addSubview:self.uploadLabel];
    
    __block UITextField *nickNametextField;
    __weak __typeof(self)weakSelf = self;
    self.nicknameView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeTextField title:@"昵称"];
    [self.scrollView addSubview:self.nicknameView];
    self.nicknameView.didChangeTextFieldblock = ^(NSString * _Nonnull string, UITextField * _Nonnull textField) {
        weakSelf.nickName = string;
        nickNametextField = textField;
    };
    self.nicknameView.didEndEditTextFieldblock = ^(NSString * _Nonnull string) {
        [weakSelf checkNickName];
    };
    
    
    self.cityView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"所在地"];
    [self.scrollView addSubview:self.cityView];
    self.cityView.textLabelString = YoUserDefault.city;
    self.cityView.didClickLabelblock = ^(UILabel * _Nonnull label) {
        [nickNametextField resignFirstResponder];
//        label.text = YoUserDefault.city;
    };
    
    
    self.appointmentAreaView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"约会范围"];
    [self.scrollView addSubview:self.appointmentAreaView];
    self.appointmentAreaView.didClickLabelblock = ^(UILabel * _Nonnull label) {
        [nickNametextField resignFirstResponder];
        [YoCityTablePickerView showWithblock:^(NSArray * _Nonnull selectedCitys, NSArray * _Nonnull selectedCityCodes) {
            label.text = [selectedCitys componentsJoinedByString:@","];
            weakSelf.appointmentAreaCodeString = [selectedCitys componentsJoinedByString:@","];
        }];
        
    };
    
    
    self.ageView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"年龄"];
    [self.scrollView addSubview:self.ageView];
    self.ageView.didClickLabelblock = ^(UILabel * _Nonnull label) {
        [nickNametextField resignFirstResponder];
        [YoSinglePickerView showDataArray:weakSelf.ageArray block:^(NSString * _Nonnull string, NSInteger index) {
            label.text = string;
            weakSelf.ageString = string;
        }];
    };
    
    
    self.professionView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"职业"];
    [self.scrollView addSubview:self.professionView];
    self.professionView.didClickLabelblock = ^(UILabel * _Nonnull label) {
        [nickNametextField resignFirstResponder];
        [YoSinglePickerView showDataArray:weakSelf.professionArray block:^(NSString * _Nonnull string, NSInteger index) {
            label.text = string;
            weakSelf.professionString = string;
        }];
    };
    
    
    if (!_isMan) {
        self.heightView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"身高"];
        [self.scrollView addSubview:self.heightView];
        self.heightView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoSinglePickerView showDataArray:weakSelf.heightArray block:^(NSString * _Nonnull string, NSInteger index) {
                label.text = string;
                weakSelf.heightString = string;
            }];
        };
        
        self.weightView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"体重"];
        [self.scrollView addSubview:self.weightView];
        self.weightView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoSinglePickerView showDataArray:weakSelf.weightArray block:^(NSString * _Nonnull string, NSInteger index) {
                label.text = string;
                weakSelf.weightString = string;
            }];
        };
        
        self.sizeView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"胸围"];
        [self.scrollView addSubview:self.sizeView];
        self.sizeView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            
            NSDictionary *size = weakSelf.sizeDict[@"y"];
            NSArray *allKeys = [size.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSNumber *int1 = obj1;
                NSNumber *int2 = obj2;
                return [int1 compare:int2];
            }];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSNumber *key in allKeys) {
                NSMutableDictionary *firstDict = [NSMutableDictionary dictionaryWithObject:key forKey:@"first"];
                NSDictionary *secondDict = [NSDictionary dictionaryWithObject:size[key] forKey:@"second"];
                [firstDict addEntriesFromDictionary:secondDict];
                [dataArray addObject:firstDict];
            }
            [YoTwoRowPickerView showDataArray:dataArray  block:^(NSString * _Nonnull firstRowString, NSString * _Nonnull secondRowString) {
                label.text = [NSString stringWithFormat:@"%@%@", firstRowString,secondRowString];
                weakSelf.sizeString = label.text;
            }];
        };
        
        self.styleView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"打扮风格"];
        [self.scrollView addSubview:self.styleView];
        self.styleView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoTablePickerView showDataArray:weakSelf.styleArray block:^(NSArray * _Nonnull selectedDataArray) {
                NSString *string = [selectedDataArray componentsJoinedByString:@","];
                label.text = string;
                weakSelf.styleString = string;
            }];
        };
        
        self.languageView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"语言"];
        [self.scrollView addSubview:self.languageView];
        self.languageView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoTablePickerView showDataArray:weakSelf.languageArray block:^(NSArray * _Nonnull selectedDataArray) {
                NSString *string = [selectedDataArray componentsJoinedByString:@","];
                label.text = string;
                weakSelf.languageString = string;

            }];
        };
        
        self.statusView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"情感状态"];
        [self.scrollView addSubview:self.statusView];
        self.statusView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoSinglePickerView showDataArray:weakSelf.statusArray block:^(NSString * _Nonnull string, NSInteger index) {
                label.text = string;
                weakSelf.statusString = string;
            }];
        };
        
        self.appointmentItemView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"约会节目"];
        [self.scrollView addSubview:self.appointmentItemView];
        self.appointmentItemView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoTablePickerView showDataArray:weakSelf.appointmentItemArray block:^(NSArray * _Nonnull selectedDataArray) {
                NSString *string = [selectedDataArray componentsJoinedByString:@","];
                label.text = string;
                weakSelf.appointmentItemString = string;

            }];
        };
        
        self.appointmentConditView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeLabel title:@"约会条件"];
        [self.scrollView addSubview:self.appointmentConditView];
        self.appointmentConditView.didClickLabelblock = ^(UILabel * _Nonnull label) {
            [nickNametextField resignFirstResponder];
            [YoTablePickerView showDataArray:weakSelf.appointmentConditArray block:^(NSArray * _Nonnull selectedDataArray) {
                NSString *string = [selectedDataArray componentsJoinedByString:@","];
                label.text = string;
                weakSelf.appointmentConditString = string;
            }];
        };
        
    }
    
    
    self.contactTitleLabel = [[QMUILabel alloc] init];
    self.contactTitleLabel.text = @"联系方式(必填)";
    self.contactTitleLabel.font = UIFontMake(16);
    [self.scrollView addSubview:self.contactTitleLabel];
    
    self.contactIntrolLabel = [[QMUILabel alloc] init];
    self.contactIntrolLabel.text = @"用户须向你付费才能查看"; //至少填写一种联系方式
    self.contactIntrolLabel.font = UIFontMake(13);
    [self.scrollView addSubview:self.contactIntrolLabel];
    
    self.wxView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeTextField title:@"微信"];
    [self.scrollView addSubview:self.wxView];
    self.wxView.didChangeTextFieldblock = ^(NSString * _Nonnull string, UITextField * _Nonnull textField) {
        weakSelf.wxString = string;
    };
    
    self.qqView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeTextField title:@"QQ"];
    [self.scrollView addSubview:self.qqView];
    self.qqView.didChangeTextFieldblock = ^(NSString * _Nonnull string, UITextField * _Nonnull textField) {
        weakSelf.qqString = string;
    };
    
    self.fromView = [[YoBaseInfoCellView alloc] initWithFrame:CGRectZero viewType:YoBaseInfoCellViewTypeTextField title:@"哪里知道我们的"];
    [self.scrollView addSubview:self.fromView];
    self.fromView.didChangeTextFieldblock = ^(NSString * _Nonnull string, UITextField * _Nonnull textField) {
        weakSelf.fromString = string;
    };
    
    
    self.lineView = [[UIImageView alloc] init];
    self.lineView.backgroundColor = UIColorGrayBackGround;
    [self.scrollView addSubview:self.lineView];
    
    
    // 个人介绍
    self.introTitleLabel = [[QMUILabel alloc] init];
    self.introTitleLabel.text = @"个人介绍";
    self.introTitleLabel.font = UIFontMake(16);
    [self.scrollView addSubview:self.introTitleLabel];
    
    self.introContentLabel = [[QMUILabel alloc] init];
    self.introContentLabel.text = @"吸引人的介绍大大提高女士的约会欲望";
    self.introContentLabel.font = UIFontMake(13);
    [self.scrollView addSubview:self.introContentLabel];
    
    self.tagView = [[YoBaseInfoTagView alloc] initWithFrame:CGRectMake(0, 0, self.view.qmui_width, [self tagViewHeight:self.tagDataArray])];
    self.tagView.delegate = self;
    [self.scrollView addSubview:self.tagView];

    NSString *titleStr = @"欢迎进入";
    if (self.isUpdateUserInfo) {
        titleStr = @"保存";
    }
    self.registerBtn = [[QMUIFillButton alloc] initWithFillColor:UIColorGlobal titleTextColor:UIColorWhite];
    [self.registerBtn setTitle:titleStr forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = UIFontMake(14);
    [self.registerBtn addTarget:self action:@selector(didClickRegisterHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.registerBtn];

}


#pragma mark - YoBaseInfoTagViewDelegate
- (void)YoBaseInfoTagView:(YoBaseInfoTagView *)view didSelectedTagArray:(NSArray *)array {
    self.tagString = [array componentsJoinedByString:@","];
}


#pragma mark - event
- (void)didClickPortraitHandler {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self presentViewController:self.imagePicker animated:YES completion:nil];
                [self _presentPhotoPickerView];
            });
        }];
    } else {
//        [self presentViewController:self.imagePicker animated:YES completion:nil];
        [self _presentPhotoPickerView];
    }
}


- (void)_presentPhotoPickerView {
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        NSMutableArray *imageArr = [NSMutableArray array];
        NSMutableArray *widthArr = [NSMutableArray array];
        NSMutableArray *heightArr = [NSMutableArray array];

        for (int i=0; i < photoList.count; i++) {
            HXPhotoModel *model = photoList[i];
            JSLogInfo(@"size:%@", NSStringFromCGSize(model.imageSize));
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
                if (i == photoList.count-1) {
                    UploadImageUnAuthService *imgApi = [[UploadImageUnAuthService alloc] initWithImage:finalImage];
                    [imgApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        NSString *imgUrl = request.responseJSONObject[@"result"][@"url"];
                        JSLogInfo(@"imgURL:%@",imgUrl);
                        self.avatarUrlString = imgUrl;
                        [self.portraitView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:UIImageMake(@"icon_portrait_placeholder")];
                    } failure:^(JSError *error) {

                    }];
                }
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {

            }];
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {

    }];
}


/// 提交
- (void)didClickRegisterHandler {
    if (StringIsEmpty(self.avatarUrlString)) {
        [QMUITips showInfo:@"请上传头像" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.nickName)) {
        [QMUITips showInfo:@"请输入昵称" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.appointmentAreaCodeString)) {
        [QMUITips showInfo:@"请输入约会范围" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.ageString)) {
        [QMUITips showInfo:@"请输入年龄" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.professionString)) {
        [QMUITips showInfo:@"请输入职业" inView:self.view];
        return;
    }
    if (!_isMan) {
        if (StringIsEmpty(self.heightString)) {
            [QMUITips showInfo:@"请输入身高" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.weightString)) {
            [QMUITips showInfo:@"请输入体重" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.sizeString)) {
            [QMUITips showInfo:@"请输入胸围" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.styleString)) {
            [QMUITips showInfo:@"请输入打扮风格" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.languageString)) {
            [QMUITips showInfo:@"请输入语言" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.statusString)) {
            [QMUITips showInfo:@"请输入情感状态" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.appointmentItemString)) {
            [QMUITips showInfo:@"请输入约会节目" inView:self.view];
            return;
        }
        if (StringIsEmpty(self.appointmentConditString)) {
            [QMUITips showInfo:@"请输入约会条件" inView:self.view];
            return;
        }
    }
    if (StringIsEmpty(self.wxString)) {
        [QMUITips showInfo:@"请输入微信" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.qqString)) {
        [QMUITips showInfo:@"请输入QQ" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.fromString)) {
        [QMUITips showInfo:@"请输入哪里知道我们的" inView:self.view];
        return;
    }
    if (StringIsEmpty(self.tagString)) {
        [QMUITips showInfo:@"请输入个人介绍" inView:self.view];
        return;
    }
    
    if (self.isUpdateUserInfo) {  //如果是更新资料
        [QMUITips showLoadingInView:self.view];
        UserInfoService *updateApi = [[UserInfoService alloc] init];
        updateApi.avatarUrlString = self.avatarUrlString;
        updateApi.nickName = self.nickName;
        updateApi.ageString = self.ageString;
        updateApi.professionString = self.professionString;
        updateApi.heightString = self.heightString;
        updateApi.weightString = self.weightString;
        updateApi.sizeString = self.sizeString;
        updateApi.styleString = self.styleString;
        updateApi.languageString = self.languageString;
        updateApi.statusString = self.statusString;
        updateApi.appointmentItemString = self.appointmentItemString;
        updateApi.appointmentConditString = self.appointmentConditString;
        updateApi.qqString = self.qqString;
        updateApi.wxString = self.wxString;
        updateApi.fromString = self.fromString;
        updateApi.tagString = self.tagString;
        updateApi.appointmentAreaCodeString = self.appointmentAreaCodeString;
        [updateApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips hideAllTipsInView:self.view];
            NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"result"];
            [YoTool saveUserInfo:dataDict];
            self.block();
        } failure:^(JSError *error) {
            [QMUITips hideAllTipsInView:self.view];
            [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
        }];
    } else {
        [QMUITips showLoadingInView:self.view];
        RegisterService *registerApi = [[RegisterService alloc] initWithPhone:_phoneStr password:_pwdStr smsCode:_codeStr isMan:_isMan];
        registerApi.avatarUrlString = self.avatarUrlString;
        registerApi.nickName = self.nickName;
        registerApi.ageString = self.ageString;
        registerApi.professionString = self.professionString;
        registerApi.heightString = self.heightString;
        registerApi.weightString = self.weightString;
        registerApi.sizeString = self.sizeString;
        registerApi.styleString = self.styleString;
        registerApi.languageString = self.languageString;
        registerApi.statusString = self.statusString;
        registerApi.appointmentItemString = self.appointmentItemString;
        registerApi.appointmentConditString = self.appointmentConditString;
        registerApi.qqString = self.qqString;
        registerApi.wxString = self.wxString;
        registerApi.fromString = self.fromString;
        registerApi.tagString = self.tagString;
        registerApi.appointmentAreaCodeString = self.appointmentAreaCodeString;
        if (self.loginType == YoLoginTypeQQ) {
            registerApi.uid = self.uid;
            registerApi.accessToken = self.accessToken;
        }
        [registerApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips hideAllTipsInView:self.view];
            NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"result"];
            [YoTool saveUserInfo:dataDict];
            [QMUITips showSucceed:@"更新成功"];
            YoUserDefault.loginType = YoLoginTypePhone;
            if (self.loginType == YoLoginTypeQQ) {
                YoUserDefault.loginType = YoLoginTypeQQ;
            }
            
            YoTabBarViewController *tabBarViewController = [[YoTabBarViewController alloc] init];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = tabBarViewController;
            
        } failure:^(JSError *error) {
            [QMUITips hideAllTipsInView:self.view];
            [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
        }];
    }
    
}


#pragma mark - ImageUpload
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:orgImage cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    //    imageCropVC.dataSource = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController presentViewController:imageCropVC animated:YES completion:nil];
    }];
    
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    [QMUITips showLoadingInView:controller.view];
    
//    UIImage *nowImage = [croppedImage scaleToWidth:400];
//    NSData *data = UIImageJPEGRepresentation(nowImage, 1.0);
//    double dataLength = [data length] * 1.0;
//    if (dataLength > 1024 * 1024) {
//        data = UIImageJPEGRepresentation(nowImage, 0.1);
//    } else {
//        data = UIImageJPEGRepresentation(nowImage, 0.9);
//    }
//
//    UIImage *image = [UIImage imageWithData:data];
//    ChangeUserPortraitService *changeApi = [[ChangeUserPortraitService alloc] initWithImage:image];
//    [changeApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
//        NSString *avatar = [data objectForKey:@"avatar"];
//        JSUserDefault.avatar = avatar;
//        [QMUITips hideAllTipsInView:controller.view];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        [self.tableView reloadData];
//    } failure:^(JSError *error) {
//        JSLogError(@"%@", error);
//        [QMUITips hideAllTipsInView:controller.view];
//        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }];
    
}



#pragma mark - getter
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}




- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, self.view.qmui_height));
        make.top.equalTo(self.view).offset(self.qmui_navigationBarMaxYInViewCoordinator);
    }];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(20);
    }];
    
    CGFloat height = 50;
    CGFloat top_margin = 15;
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.portraitView.mas_bottom).offset(top_margin);
    }];
    
    [self.nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.uploadLabel.mas_bottom).offset(top_margin);
    }];
    
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.nicknameView.mas_bottom).offset(top_margin);
    }];
    
    [self.appointmentAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.cityView.mas_bottom).offset(top_margin);
    }];
    
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.appointmentAreaView.mas_bottom).offset(top_margin);
    }];

    [self.professionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.ageView.mas_bottom).offset(top_margin);
    }];
    
    
    if (!_isMan) {
        [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.professionView.mas_bottom).offset(top_margin);
        }];
        
        [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.heightView.mas_bottom).offset(top_margin);
        }];
        
        [self.sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.weightView.mas_bottom).offset(top_margin);
        }];
        
        [self.styleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.sizeView.mas_bottom).offset(top_margin);
        }];
        
        [self.languageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.styleView.mas_bottom).offset(top_margin);
        }];
        
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.languageView.mas_bottom).offset(top_margin);
        }];
        
        [self.appointmentItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.statusView.mas_bottom).offset(top_margin);
        }];
        
        [self.appointmentConditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
            make.centerX.equalTo(self.scrollView);
            make.top.equalTo(self.appointmentItemView.mas_bottom).offset(top_margin);
        }];
    }
    

    // 联系方式
    CGFloat margin = 18;
    if (!_isMan) {
        [self.contactTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appointmentConditView.mas_bottom).offset(20);
            make.left.equalTo(self.scrollView.mas_left).offset(margin);
        }];
    } else {
        [self.contactTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.professionView.mas_bottom).offset(20);
            make.left.equalTo(self.scrollView.mas_left).offset(margin);
        }];
    }

    [self.contactIntrolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactTitleLabel.mas_bottom).offset(top_margin);
        make.left.equalTo(self.contactTitleLabel.mas_left);
    }];


    [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.contactIntrolLabel.mas_bottom).offset(top_margin);
    }];

    [self.qqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.wxView.mas_bottom).offset(top_margin);
    }];

    [self.fromView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, height));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.qqView.mas_bottom).offset(top_margin);
    }];


    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, top_margin));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.fromView.mas_bottom).offset(0);
    }];

    // 个人介绍
    [self.introTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(top_margin + 10);
        make.left.equalTo(self.scrollView.mas_left).offset(margin);
    }];

    [self.introContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introTitleLabel.mas_bottom).offset(top_margin);
        make.left.equalTo(self.introTitleLabel.mas_left);
    }];


    // 标签view
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.qmui_width, [self tagViewHeight:self.tagDataArray]));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.introContentLabel.mas_bottom).offset(30);
    }];

    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RatioZoom(300), 50));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.tagView.mas_bottom).offset(40);
    }];

    self.scrollView.contentSize = CGSizeMake(self.view.qmui_width, CGRectGetMaxY(self.registerBtn.frame) + 120);
   
    
    
}



- (CGFloat)tagViewHeight:(NSArray *)dataArray {
    int count = 4;
    CGFloat pic_height = RatioZoom(35);
    CGFloat marginY = 5;
    NSInteger row = dataArray.count / count;
    CGFloat height = (pic_height + marginY + 5) * (row + 1);

    return height;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    if (self.isUpdateUserInfo) {
        self.title = @"更新信息";
    } else {
        self.title = @"资料填写";
    }
}

#pragma mark - lazy
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


- (NSArray *)ageArray {
    if (_ageArray == nil) {
        _ageArray = [NSArray array];
    }
    return _ageArray;
}

- (NSArray *)heightArray {
    if (_heightArray == nil) {
        _heightArray = [NSArray array];
    }
    return _heightArray;
}

- (NSArray *)weightArray {
    if (_weightArray == nil) {
        _weightArray = [NSArray array];
    }
    return _weightArray;
}

- (NSDictionary *)sizeDict {
    if (_sizeDict == nil) {
        _sizeDict = [NSDictionary dictionary];
    }
    return _sizeDict;
}

- (NSArray *)styleArray {
    if (_styleArray == nil) {
        _styleArray = [NSArray array];
    }
    return _styleArray;
}

- (NSArray *)languageArray {
    if (_languageArray == nil) {
        _languageArray = [NSArray array];
    }
    return _languageArray;
}

- (NSArray *)statusArray {
    if (_statusArray == nil) {
        _statusArray = [NSArray array];
    }
    return _statusArray;
}

- (NSArray *)appointmentItemArray {
    if (_appointmentItemArray == nil) {
        _appointmentItemArray = [NSArray array];
    }
    return _appointmentItemArray;
}

- (NSArray *)appointmentConditArray {
    if (_appointmentConditArray == nil) {
        _appointmentConditArray = [NSArray array];
    }
    return _appointmentConditArray;
}

- (NSArray *)tagDataArray {
    if (_tagDataArray == nil) {
        _tagDataArray = [NSArray array];
    }
    return _tagDataArray;
}

@end
