//
//  YoPortraitCutViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCutViewController.h"
#import <JPImageresizerView.h>
#import "YoPortraitTagViewController.h"
#import "YoCutViewController.h"


@interface YoPortraitCutViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,YoImageCutViewControllerDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QMUILabel *detailsLabel;
@property (nonatomic, strong) QMUIButton *nextButton;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *finalImageArray;
@property (nonatomic, assign) CGRect cutFrame;
@property (nonatomic, assign) NSInteger cutIndex;
@property (nonatomic, strong) QMUIButton *yesButton;//选择按钮
@property (nonatomic, strong) QMUIButton *cannelButton;//选择按钮
@end

@implementation YoPortraitCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageViewArray = [NSMutableArray array];
    self.finalImageArray = [NSMutableArray array];
    _index = 0;
    _cutIndex = 0;
    _cutFrame =  CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) *4/3);
    for (NSInteger i = 0; i < _imagesAssetArray.count; i ++) {
        UIImage *image = _imagesAssetArray[i];
        [self.finalImageArray addObject:image];
        YoCutViewController *cutVc = [[YoCutViewController alloc]init];
        cutVc.originalImage = image;
        cutVc.delegate = self;
        cutVc.cutFrame = self.cutFrame;
        cutVc.cutBorderWidth = 1;
        cutVc.cutBorderColor = [UIColor whiteColor];
        [self.imageViewArray addObject:cutVc];
    }
}

- (void)initSubviews {
    [super initSubviews];
    _cutFrame = CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) *4/3);
    [self.view addSubview:self.collectionView];
    self.yesButton.frame = CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 60, 80, 40);
    [self.view addSubview:self.yesButton];
    self.cannelButton.frame = CGRectMake(40, SCREEN_HEIGHT - 60, 80, 40);
    [self.view addSubview:self.cannelButton];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = [NSString stringWithFormat:@"%zd/%zd",self.index+1, _imagesAssetArray.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
}

#pragma mark - method
- (void)done {
    YoPortraitTagViewController *tagVC = [[YoPortraitTagViewController alloc] init];
    tagVC.imagesAssetArray = self.finalImageArray;
    [self.navigationController pushViewController:tagVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    self.index = indexPathNow.row;
    self.title = [NSString stringWithFormat:@"%d/%zd",self.index+1, _imagesAssetArray.count];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    self.index = indexPathNow.row;
    
    self.title = [NSString stringWithFormat:@"%ld/%zd",self.index+1, _imagesAssetArray.count];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    YoCutViewController *imageresizerView = self.imageViewArray[indexPath.row];
    imageresizerView.cutIndex = self.cutIndex;
    imageresizerView.cutFrame = self.cutFrame;
    [cell addSubview:imageresizerView.view];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - Lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,NORMAL_Y,self.view.bounds.size.width, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (QMUIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [QMUIButton buttonWithType:UIButtonTypeSystem];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.backgroundColor = [UIColor clearColor];
        [_nextButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (QMUIButton *)yesButton {
    if (!_yesButton) {
        _yesButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_yesButton setImage:[UIImage imageNamed:@"yo_cutImage_selected"] forState:UIControlStateNormal];
        _yesButton.backgroundColor = [UIColor clearColor];
        [_yesButton addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesButton;
}

- (QMUIButton *)cannelButton {
    if (!_cannelButton) {
        _cannelButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_cannelButton setImage:[UIImage imageNamed:@"yo_cutImage_delete"] forState:UIControlStateNormal];
        _cannelButton.backgroundColor =  [UIColor clearColor];
        [_cannelButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cannelButton;
}
//裁剪按钮
- (void)cutAction{
    [self.collectionView layoutIfNeeded];
    YoCutViewController *imageresizerView = self.imageViewArray[self.index];
    [imageresizerView confirmAction];
}
- (void)deleteAction{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_imagesAssetArray];
    [tempArr removeObjectAtIndex:self.index];
    [self.finalImageArray removeObjectAtIndex:self.index];
    _imagesAssetArray = [tempArr copy];
    if (!tempArr || tempArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.collectionView reloadData];
    if (self.index > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.index -= 1;
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.index = 0;
    }
}
/**
 裁剪完成
 @param controller controller
 @param editImage  裁剪完的图片
 */
- (void)imageCutViewController:(YoCutViewController*)controller finishedEidtImage:(UIImage*)editImage{
    self.finalImageArray[self.index] = editImage;
    if (self.index+ 1 < _imagesAssetArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index+1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.index += 1;
    }else{
        [self done];
    }
}
/**
 取消裁剪
 @param controller controller
 */
- (void)imageCutViewControllerDidCancel:(YoCutViewController*)controller{
    
}
- (void)imageCutViewControllerDidChangeFrame:(CGRect)cutFrame andIndex:(NSInteger)index{
    self.cutIndex = index;
    self.cutFrame = cutFrame;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    self.index = 0;
    [self.finalImageArray removeAllObjects];
    [self.finalImageArray addObjectsFromArray:self.imagesAssetArray];
}
@end
