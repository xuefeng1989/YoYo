//
//  YoPublishViewController.m
//  Yoyo
//
//  Created by ning on 2019/6/23.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPublishViewController.h"

#import "YoCityPickerView.h"
#import "YoSinglePickerView.h"
#import "YoDatePickerView.h"
#import "YoPublishPickerCell.h"

#import "HXPhotoPicker.h"
#import <Masonry.h>
#import "UIImageEffects.h"

static const CGFloat kPhotoViewMargin = 15.0;


@interface YoPublishViewController ()<HXPhotoViewDelegate, YoPublishPickerCellDelegate>
@property(nonatomic, strong) HXPhotoView *photoView;
@property(nonatomic, strong) HXPhotoManager *manager;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QMUITextView *contentView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@property(nonatomic, strong) UIView *lineView1;
@property(nonatomic, strong) QMUILabel *introlLabel;

@property(nonatomic, strong) YoPublishPickerCell *cityCell;
@property(nonatomic, strong) YoPublishPickerCell *dateCell;
@property(nonatomic, strong) YoPublishPickerCell *timeCell;

@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) QMUIButton *publishBtn;
@property(nonatomic, strong) QMUILabel *footerIntrolLabel;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVc;


@property(nonatomic, strong) NSArray<NSString *> *dataArray;
@property(nonatomic, assign) CGFloat photoViewHeight;
@property(nonatomic, strong) NSMutableArray *selectedArray;
@property(nonatomic, strong) NSMutableArray<NSNumber *> *selectTagArray;
@property(nonatomic, strong) NSMutableArray<QMUIFillButton *> *suggestionTagBtnArray;

@end

@implementation YoPublishViewController
@dynamic dataArray;

- (void)initSubviews {
    [super initSubviews];
    
    self.photoViewHeight = 113;
    
    self.selectTagArray = [NSMutableArray array];
    self.suggestionTagBtnArray = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    
    self.contentView = [[QMUITextView alloc] init];
    self.contentView.placeholder = @"请选择标签..";
    self.contentView.textColor = UIColorBlackFont;
    self.contentView.font = UIFontMake(14);
    [self.contentView setUserInteractionEnabled:NO];
    [self.scrollView addSubview:self.contentView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorSeparator;
    [self.scrollView addSubview:self.lineView];
    
    
    self.dataArray = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜", @"读书热榜哈蛤", @"全天可约", @"滴滴", @"哈哈哈哈", @"飞机", @"富豪", @"读书热榜", @"帅哥", @"美女"];

    self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    self.floatLayoutView.padding = UIEdgeInsetsMake(12, 0, 12, 0);
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    [self.scrollView addSubview:self.floatLayoutView];
    
    NSMutableArray<NSString *> *suggestions = [[self.dataArray subarrayWithRange:NSMakeRange(0, 10)] mutableCopy];
    [suggestions addObject:@"+ 更多标签"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        if (i == suggestions.count - 1) {
            QMUIGhostButton *button = [[QMUIGhostButton alloc] init];
            button.ghostColor = UIColorGrayFont;
            [button setTitle:suggestions[i] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontMake(14);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
            [button addTarget:self action:@selector(clickMoreTagEvent) forControlEvents:UIControlEventTouchUpInside];
            [self.floatLayoutView addSubview:button];
        } else {
            QMUIFillButton *tagBtn = [[QMUIFillButton alloc] init];
            tagBtn.cornerRadius = 4;
            tagBtn.fillColor = UIColorGrayFont;
            tagBtn.tag = i;
            tagBtn.titleLabel.font = UIFontMake(14);
            tagBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
            [tagBtn setTitle:suggestions[i] forState:UIControlStateNormal];
            [tagBtn addTarget:self action:@selector(clickTagEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.floatLayoutView addSubview:tagBtn];
            [self.suggestionTagBtnArray addObject:tagBtn];
        }
    }
    
    self.lineView1 = [[UIView alloc] init];
    self.lineView1.backgroundColor = UIColorSeparator;
    [self.scrollView addSubview:self.lineView1];
    
    
    self.photoView = [HXPhotoView photoManager:self.manager];
    self.photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, self.view.qmui_width - kPhotoViewMargin * 2, 0);
    self.photoView.delegate = self;
    self.photoView.outerCamera = YES;
    self.photoView.lineCount = 3;
    self.photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    self.photoView.previewShowDeleteButton = YES;  //btn_photo_delete
    self.photoView.deleteImageName = @"btn_photo_delete";
    self.photoView.showAddCell = YES;
    [self.photoView.collectionView reloadData];
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.photoView];
    
    
    self.introlLabel = [[QMUILabel alloc] init];
    self.introlLabel.backgroundColor = UIColorGrayBackGround;
    self.introlLabel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
    self.introlLabel.font = UIFontMake(13);
    self.introlLabel.textColor = UIColorGlobal;
    self.introlLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [self.scrollView addSubview:self.introlLabel];
    
    
    self.cityCell = [[YoPublishPickerCell alloc] init];
    self.cityCell.delegate = self;
    self.cityCell.titleString = @"约会城市";
    self.cityCell.contentString = @"选择地点";
    [self.scrollView addSubview:self.cityCell];
    
    self.dateCell = [[YoPublishPickerCell alloc] init];
    self.dateCell.delegate = self;
    self.dateCell.titleString = @"约会日期";
    self.dateCell.contentString = @"选择日期";
    [self.scrollView addSubview:self.dateCell];
    
    self.timeCell = [[YoPublishPickerCell alloc] init];
    self.timeCell.delegate = self;
    self.timeCell.titleString = @"约会时间";
    self.timeCell.contentString = @"选择时间";
    self.timeCell.hiddenSeparator = YES;
    [self.scrollView addSubview:self.timeCell];
    
    
    
    self.footerView = [[UIView alloc] init];
    self.footerView.backgroundColor = UIColorGrayBackGround;
    [self.scrollView addSubview:self.footerView];
    
    self.publishBtn = [[QMUIButton alloc] init];
    [self.publishBtn setTitle:@"发布广播" forState:UIControlStateNormal];
    self.publishBtn.titleLabel.font = UIFontBoldMake(15);
    [self.publishBtn setBackgroundImage:UIImageMake(@"base_btn_shadow_bg") forState:UIControlStateNormal];
    [self.publishBtn addTarget:self action:@selector(didClickPublishHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.publishBtn];
    
    
    self.footerIntrolLabel = [[QMUILabel alloc] init];
    self.footerIntrolLabel.text = @"认证后才可以发布广播";
    self.footerIntrolLabel.textAlignment = NSTextAlignmentCenter;
    self.footerIntrolLabel.textColor = UIColorGrayFont;
    self.footerIntrolLabel.font = UIFontMake(13);
    [self.footerView addSubview:self.footerIntrolLabel];
    
}

#pragma mark - Event;
- (void)clickMoreTagEvent {
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGFloat margin = 20;
    QMUIButton *arrowsBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(self.contentView.qmui_width - margin - 20, 0, 20, 20)];
    [arrowsBtn setImage:UIImageMake(@"btn_nav_item_down_white") forState:UIControlStateNormal];
    [arrowsBtn addTarget:self action:@selector(didClickTagViewArrows) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:arrowsBtn];
    
    QMUIFloatLayoutView *floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    floatLayoutView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    [contentView addSubview:floatLayoutView];

    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        QMUIFillButton *tagBtn = [[QMUIFillButton alloc] init];
        tagBtn.cornerRadius = 4;
        tagBtn.fillColor = UIColorGrayFont;
        tagBtn.tag = i;
        tagBtn.titleLabel.font = UIFontMake(14);
        tagBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
        [tagBtn setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [tagBtn addTarget:self action:@selector(clickTagEvent:) forControlEvents:UIControlEventTouchUpInside];
        [floatLayoutView addSubview:tagBtn];
        
        if ([self.selectTagArray containsObject:[NSNumber numberWithInteger:tagBtn.tag]]) {
            tagBtn.fillColor = UIColorGlobal;
            tagBtn.selected = YES;
        }
    }
    floatLayoutView.frame = CGRectMake(0, CGRectGetMaxY(arrowsBtn.frame) + 10, self.contentView.qmui_width, QMUIViewSelfSizingHeight);

    UIImage *blurredBackgroundImage = [UIImage qmui_imageWithView:self.navigationController.view];
    blurredBackgroundImage = [UIImageEffects imageByApplyingTintEffectWithColor:UIColorMakeWithRGBA(0, 0, 0, 0.5) toImage:blurredBackgroundImage];
    UIImageView *blurredDimmingView = [[UIImageView alloc] initWithImage:blurredBackgroundImage];
    
    self.modalVc = [[QMUIModalPresentationViewController alloc] init];
    self.modalVc.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    self.modalVc.dimmingView = blurredDimmingView;
    self.modalVc.contentView = contentView;
    [self.modalVc showWithAnimated:YES completion:nil];
}

- (void)clickTagEvent:(QMUIFillButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.fillColor = UIColorGlobal;
        [self.selectedArray addObject:btn.titleLabel.text];
        [self.selectTagArray addObject:[NSNumber numberWithInteger:btn.tag]];
    } else {
        btn.fillColor = UIColorGrayFont;
        [self.selectedArray removeObject:btn.titleLabel.text];
        [self.selectTagArray removeObject:[NSNumber numberWithInteger:btn.tag]];
    }
    
    self.contentView.text = [[self.selectedArray copy] componentsJoinedByString:@","];
    
}

- (void)didClickTagViewArrows {
    for (int i=0; i < self.suggestionTagBtnArray.count; i++) {
        QMUIFillButton *btn = self.suggestionTagBtnArray[i];
        if ([self.selectedArray containsObject:btn.titleLabel.text]) {
            btn.fillColor = UIColorGlobal;
            btn.selected = YES;
        } else {
            btn.fillColor = UIColorGrayFont;
            btn.selected = NO;
        }
    }
    
    [self.modalVc hideWithAnimated:YES completion:nil];
    
}

- (void)didClickPublishHandler {
    
}

#pragma mark - YoPublishPickerCellDelegate
- (void)YoPublishPickerCell:(YoPublishPickerCell *)cell didClickEvent:(QMUILabel *)contentLabel {
    if (cell == self.cityCell) {
        [YoCityPickerView showWithblock:^(NSString * _Nonnull provinceName, NSString * _Nonnull cityName, NSString * _Nonnull cityCode) {
            contentLabel.text = cityName;
            JSLogInfo(@"%@ %@  %@",provinceName, cityName, cityCode);
        }];
    }
    if (cell == self.dateCell) {
        [YoDatePickerView showEndYear:-1 block:^(NSInteger year, NSInteger month, NSInteger day) {
            contentLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year, month, day];
        }];
    }
    
    if (cell == self.timeCell) {
        [YoSinglePickerView showDataArray:@[@"早上",@"中午",@"下午",@"晚上",@"一整天"] block:^(NSString * _Nonnull string, NSInteger index) {
            contentLabel.text = string;
        }];
        
    }
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    for (HXPhotoModel *model in allList) {
       
    }
    HXPhotoModel *photoModel = allList.firstObject;
    
//    [allList hx_requestImageWithOriginal:isOriginal completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
//        NSString *filePathName = [@"/Users/ningcol/Desktop" stringByAppendingPathComponent:@"1.png"];
//        UIImage *img = imageArray.firstObject ;
//        NSData *data = UIImagePNGRepresentation(img);
//        [data writeToFile:filePathName atomically:YES];
//        JSLogInfo(@"%ld",data.length / 1024 /1024);
//    }];
    
    [allList hx_requestImageDataWithCompletion:^(NSArray<NSData *> * _Nullable imageDataArray) {
        NSString *filePathName = [@"/Users/ningcol/Desktop" stringByAppendingPathComponent:@"2.png"];
        NSData *data = imageDataArray.firstObject;
        [data writeToFile:filePathName atomically:YES];
        JSLogInfo(@"%ld",data.length / 1024 /1024);
    }];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    JSLogInfo(@"updateFrame:%@",NSStringFromCGRect(frame));
    self.photoViewHeight = frame.size.height;
    [self viewDidLayoutSubviews];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = CGRectMake(kPhotoViewMargin, 0, self.view.qmui_width - kPhotoViewMargin *2, 80);
    
    self.lineView.frame = CGRectMake(kPhotoViewMargin, CGRectGetMaxY(self.contentView.frame), self.view.qmui_width - kPhotoViewMargin, PixelOne);
    
    self.floatLayoutView.frame = CGRectMake(kPhotoViewMargin, CGRectGetMaxY(self.lineView.frame), self.view.qmui_width - kPhotoViewMargin * 2, QMUIViewSelfSizingHeight);
    
    self.lineView1.frame = CGRectMake(kPhotoViewMargin, CGRectGetMaxY(self.floatLayoutView.frame), self.view.qmui_width - kPhotoViewMargin, PixelOne);

    self.photoView.frame = CGRectMake(kPhotoViewMargin, CGRectGetMaxY(self.floatLayoutView.frame) + 12, self.view.qmui_width - kPhotoViewMargin * 2, self.photoViewHeight);
    
    self.introlLabel.frame = CGRectMake(0, self.lineView1.frame.origin.y + 12 + self.photoViewHeight + 12, self.view.qmui_width, 45);
    
    
    self.cityCell.frame = CGRectMake(0, CGRectGetMaxY(self.introlLabel.frame), self.view.qmui_width, 50);
    self.dateCell.frame = CGRectMake(0, CGRectGetMaxY(self.cityCell.frame), self.view.qmui_width, 50);
    self.timeCell.frame = CGRectMake(0, CGRectGetMaxY(self.dateCell.frame), self.view.qmui_width, 50);

    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.timeCell.frame), self.view.qmui_width, 160);
    self.publishBtn.frame = CGRectMake( (self.view.qmui_width -  RatioZoom(300))/2, (160 - 50)/2, RatioZoom(300), 50);
    self.footerIntrolLabel.frame = CGRectMake(0, CGRectGetMaxY(self.publishBtn.frame), self.view.qmui_width, 40);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.footerView.frame));

    
}


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;

        _manager.configuration.creationDateSort = YES;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showOriginalBytes = YES;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.hideOriginalBtn = YES;
        
    }
    return _manager;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
