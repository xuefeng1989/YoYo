//
//  YoPortraitTagViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitTagViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "YoPortraitTagCell.h"
#import <Masonry.h>
#import "YoPortraitCreaeteViewController.h"
#import "YoPortraitAddTagController.h"
#import "YoCommonNavigationController.h"

@interface YoPortraitTagViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ZYTagViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QMUILabel *detailsLabel;
@property (nonatomic, strong) QMUIButton *nextButton;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation YoPortraitTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageViewArray = [NSMutableArray array];
    for (UIImage *img in _imagesAssetArray) {
        ZYTagImageView *imageView = [[ZYTagImageView alloc] initWithImage:img];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(RatioZoom(15), RatioZoom(10), SCREEN_WIDTH-RatioZoom(30), RatioZoom(400));
        imageView.delegate = self;
        [self.imageViewArray addObject:imageView];
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(RatioZoom(10));
        make.left.mas_equalTo(self.collectionView);
        make.right.mas_equalTo(self.collectionView);
    }];
    
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailsLabel);
        make.right.mas_equalTo(self.detailsLabel);
        make.top.mas_equalTo(self.detailsLabel.mas_bottom).offset(RatioZoom(10));
        make.height.mas_equalTo(RatioZoom(50));
    }];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = [NSString stringWithFormat:@"%zd/%zd",self.index+1, _imagesAssetArray.count];
    
}

#pragma mark - method
- (void)next {
    YoPortraitCreaeteViewController *createVC = [[YoPortraitCreaeteViewController alloc] init];
    
    NSMutableArray *array = [NSMutableArray array];
        for (ZYTagImageView *imageView in self.imageViewArray) {
            UIImage *img = imageView.image;
            NSArray *tagInfo = imageView.getAllTagInfos;
            
            [array addObject:@{@"tags":tagInfo,@"image":img}];
        }

    createVC.imageArray = array;
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    self.index = indexPathNow.row;
    
    self.title = [NSString stringWithFormat:@"%zd/%zd",self.index+1, _imagesAssetArray.count];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZYTagImageView *imageView = self.imageViewArray[indexPath.row];
    
    [cell.contentView addSubview:imageView];

    return cell;
}

#pragma mark - ZYTagViewDelegate
- (void)tagImageView:(ZYTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:tagImageView];
    
    
    YoPortraitAddTagController *addTagVC = [[YoPortraitAddTagController alloc] init];
    YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:addTagVC];
    addTagVC.block = ^(NSString * _Nonnull title) {
        [tagImageView addTagWithTitle:title point:tapPoint object:nil];
    };
    [self presentViewController:navVc animated:YES completion:nil];
    
//    UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alVC addTextFieldWithConfigurationHandler:nil];
//    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSString *text = ((UITextField *)(alVC.textFields[0])).text;
//        if (text.length) {
//            // 添加标签
//            [tagImageView addTagWithTitle:text point:tapPoint object:nil];
//        }
//    }];
//    [alVC addAction:ac];
//    [self presentViewController:alVC animated:YES completion:nil];
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveTapGesture:(ZYTagView *)tagView
{
    /** 可自定义点击手势的反馈 */
    if (tagView.isEditEnabled) {
        
        JSLogInfo(@"编辑模式 -- 轻触");
        [tagView switchDeleteState];
    }else{
        JSLogInfo(@"预览模式 -- 轻触");
    }
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveLongPressGesture:(ZYTagView *)tagView
{
    /** 可自定义长按手势的反馈 */
    if (tagView.isEditEnabled) {
        JSLogInfo(@"编辑模式 -- 长按");
        
        UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"修改标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = tagView.tagInfo.title;
        }];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (((UITextField *)(alVC.textFields[0])).text.length) {
                [tagView updateTitle:((UITextField *)(alVC.textFields[0])).text];
            }
        }];
        [alVC addAction:ac];
        [self presentViewController:alVC animated:YES completion:nil];
        
    }else{
        JSLogInfo(@"预览模式 -- 长按");
    }
}

#pragma mark - Lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(self.view.qmui_width, self.view.qmui_width*(400/345));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,NORMAL_Y,self.view.bounds.size.width, self.view.bounds.size.width*(400/345)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[YoPortraitTagCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (QMUILabel *)detailsLabel {
    if (!_detailsLabel) {
        _detailsLabel = [QMUILabel new];
        _detailsLabel.text = @"点击图片以添加标签";
        _detailsLabel.numberOfLines = 2;
        _detailsLabel.textColor = UIColorGlobal;
        _detailsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailsLabel;
}

- (QMUIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.backgroundColor = UIColorGlobal;
        [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
