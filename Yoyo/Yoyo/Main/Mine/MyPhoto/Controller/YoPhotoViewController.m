//
//  YoPhotoViewController.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPhotoViewController.h"
#import "YoMineUploadCollectionViewCell.h"
#import "YoMinePhotoPickerView.h"
#import "YoMyPhotoService.h"
#import "YoImageModel.h"
#import "MJRefresh.h"
#import "GKPhotoBrowser.h"
#import "YoSetPhotoStatuesTypeService.h"
#import "YoCenterBaseCollectionView.h"
#import <Masonry.h>
#define  HeaderImageViewHeight 240
@interface YoPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) YoCenterBaseCollectionView *collectionView;
@property (nonatomic, strong) YoMinePhotoPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) YoMyPhotoService *service;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic) BOOL canScroll;
@end

@implementation YoPhotoViewController
- (void)questDataSource
{
    if (_page == 1) {
        [self.imageArray removeAllObjects];
    }
    [self.service setWithPageNum:self.page pageSize:50];
    [self.service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *dataList = data[@"list"];
        if (dataList && dataList.count > 0) {
            for (NSDictionary *dic in dataList) {
                YoImageModel *model = [[YoImageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.imageArray addObject:model];
            }
            self.block([NSString stringWithFormat:@"相册（ %ld ）",self.imageArray.count]);
//            self.topTitleLabel.text = [NSString stringWithFormat:@"相册（ %ld ）",self.imageArray.count];
            [self.collectionView reloadData];
        }else if (self.page > 1) {
            self.page -=1;
        }
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(JSError *error) {
        if (self.page > 1) {
            self.page -=1;
        }
    }];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (YoMyPhotoService *)service
{
    if(!_service){
        _service = [[YoMyPhotoService alloc] init];
    }
    return _service;
}
#pragma mark - UICollectionView delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoMineUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    cell.model = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * bigPhotoArray = [NSMutableArray array];
    for (YoImageModel *model in self.imageArray) {
        GKPhoto *photo = [GKPhoto new];
        photo.url =[NSURL URLWithString:model.photo];
        photo.imageId = model.imageId;
        photo.isSelf = YES;
        photo.imageType = model.imageType;
        [bigPhotoArray addObject:photo];
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:bigPhotoArray currentIndex:indexPath.row];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    [browser showFromVC:self];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p=[gestureRecognizer locationInView:self.collectionView];
    NSIndexPath*indexPath =[self.collectionView indexPathForItemAtPoint:p];
    
    if(indexPath ==nil){
        JSLogInfo(@"couldn't find index path");
    }else{
        __weak __typeof(self)weakSelf = self;
        YoImageModel *model = self.imageArray[indexPath.row];
        if (model.imageType == YoMineUploadCollectionViewCellTypeFire) {
            [self.pickerView setSelectIndex:1];
        }else if (model.imageType == YoMineUploadCollectionViewCellTypeNormal){
            [self.pickerView setSelectIndex:0];
        }else if (model.imageType == YoMineUploadCollectionViewCellTypePay){
            [self.pickerView setSelectIndex:2];
        }
        [self.pickerView show];
        self.pickerView.commitBlock = ^(NSInteger index) {
            [weakSelf mineSetConfigIndex:index cellIndex:indexPath.row];
        };
        self.pickerView.deleteBlock = ^{
            [QMUITips showSucceed:[NSString stringWithFormat:@"删除了第%zd项",indexPath.row]];
            [weakSelf.imageArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
            [weakSelf delletePhotoCellIndex:indexPath.row];
        };
    }
}
- (void)delletePhotoCellIndex:(NSInteger)cellIndex{
    YoImageModel *model = self.imageArray[cellIndex];
    if (model.photo && model.photo.length > 0) {
        YoSetPhotoStatuesTypeService *service = [[YoSetPhotoStatuesTypeService alloc] initWithUserImageModel:model];
        service.handlerType = BaseRequestHandlerTypeRemove;
        [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"设置阅后即焚成功 *** ");
        } failure:^(JSError *error) {
            NSLog(@"设置阅后即焚失败 *** %@",error);
        }];
    }
}
- (void)mineSetConfigIndex:(NSInteger)configIndex cellIndex:(NSInteger)cellIndex {
    
    YoImageModel *model = self.imageArray[cellIndex];
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
        } failure:^(JSError *error) {
            NSLog(@"设置阅后即焚失败 *** %@",error);
        }];
    }
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
        _collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            self.page +=1;
            [self questDataSource];
        }];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
    }];
     [self questDataSource];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makePageViewControllerScroll:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewControllerLeaveTop)]) {
                [self.delegate pageViewControllerLeaveTop];
            }
        }
    } else {
        [self makePageViewControllerScroll:NO];
    }
}
- (void)makePageViewControllerScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    self.collectionView.showsVerticalScrollIndicator = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}
- (void)makePageViewControllerScrollToTop{
    
}
@end
