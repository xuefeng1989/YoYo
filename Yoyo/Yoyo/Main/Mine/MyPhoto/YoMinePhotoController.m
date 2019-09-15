//
//  YoMinePhotoController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePhotoController.h"
#import <Masonry.h>
#import "Const.h"
#import "YoMineUploadCollectionViewCell.h"
#import "YoMinePhotoPickerView.h"

@interface YoMinePhotoController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) QMUILabel *topTitleLabel;
@property (nonatomic, strong) QMUILabel *topTipLabel;
@property (nonatomic, strong) QMUIButton *backButton;
@property (nonatomic, strong) QMUILabel *titleL;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YoMinePhotoPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation YoMinePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i < 10; i++) {
        [self.imageArray addObject:@""];
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.topTitleLabel];
    [self.topView addSubview:self.topTipLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(RatioZoom(240));
    }];
    
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(RatioZoom(60));
        make.bottom.mas_equalTo(self.backImageView);
    }];
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RatioZoom(20));
        make.left.mas_equalTo(RatioZoom(15));
    }];
    
    [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topTitleLabel);
        make.right.mas_equalTo(-RatioZoom(15));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RatioZoom(15));
        make.top.mas_equalTo(RatioZoom(35));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RatioZoom(15));
        make.right.mas_equalTo(-RatioZoom(15));
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QMUINavigationControllerAppearanceDelegate
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

#pragma mark - UICollectionView delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoMineUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    cell.imageV.backgroundColor = [UIColor qmui_randomColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p=[gestureRecognizer locationInView:self.collectionView];
    NSIndexPath*indexPath =[self.collectionView indexPathForItemAtPoint:p];
    
    if(indexPath ==nil){
        JSLogInfo(@"couldn't find index path");
    }else{
        __weak __typeof(self)weakSelf = self;;
        [self.pickerView show];
        
        self.pickerView.commitBlock = ^(NSInteger index) {
            [QMUITips showSucceed:[NSString stringWithFormat:@"选择了第%zd项",index]];
        };
        self.pickerView.deleteBlock = ^{
            [QMUITips showSucceed:[NSString stringWithFormat:@"删除了第%zd项",indexPath.row]];
            [weakSelf.imageArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
    }
}

#pragma mark - lazy load

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.backgroundColor = UIColorGlobal;
    }
    return _backImageView;
}

- (UIImageView *)topView {
    if (!_topView) {
        _topView = [UIImageView new];
        UIImage *image = [UIImage qmui_imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, RatioZoom(60)) cornerRadiusArray:@[@(20), @(0), @(0), @(20)]];
        _topView.image = image;
    }
    return _topView;
}

- (QMUILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [QMUILabel new];
        _topTitleLabel.text = @"相册（ 100 ）";
        _topTitleLabel.font = UIFontMake(20);
        _topTitleLabel.textColor = UIColorContentFont;
    }
    return _topTitleLabel;
}

- (QMUILabel *)topTipLabel {
    if (!_topTipLabel) {
        _topTipLabel = [QMUILabel new];
        _topTipLabel.text = @"长按照片设置照片";
        _topTipLabel.font = UIFontBoldMake(16);
        _topTipLabel.textColor = UIColorGrayFont;
    }
    return _topTipLabel;
}

- (QMUIButton *)backButton {
    if (!_backButton) {
        _backButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (QMUILabel *)titleL {
    if (!_titleL) {
        _titleL = [QMUILabel new];
        _titleL.text = @"相册";
        _titleL.font = UIFontBoldMake(18);
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}


- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = RatioZoom(4);
        layout.minimumInteritemSpacing = RatioZoom(4);
        CGFloat width = (SCREEN_WIDTH-RatioZoom(45))/3;
        CGFloat height = width;
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YoMineUploadCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
        
        UILongPressGestureRecognizer *longPressGr =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration=1.0;
        longPressGr.delaysTouchesBegan=YES;
        [_collectionView addGestureRecognizer:longPressGr];

    }
    return _collectionView;
}

- (YoMinePhotoPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[YoMinePhotoPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _pickerView;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
@end
