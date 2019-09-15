//
//  YoNearbyViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoNearbyViewController.h"
#import "YoPortraitLayout.h"
#import "YoDataItem.h"
#import "YoPortraitModel.h"
#import "YoPortraitCollectionViewCell.h"
#import "YoPortraitService.h"
#import <MJRefresh.h>
#import "YoPortraitPersonalViewController.h"

@interface YoNearbyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YoPortraitLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<YoPortraitModel *> *data;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation YoNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    
    YoPortraitLayout *layout = [[YoPortraitLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-NORMAL_Y) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[YoPortraitCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView.mj_header beginRefreshing];

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark -
- (void)loadNewData {
    self.pageIndex = 1;
    YoPortraitService *portraitApi = [[YoPortraitService alloc] initWithPageIndex:self.pageIndex pageSize:50 sendType:YoPortraitTypeNearby];
    [portraitApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        JSLogInfo(@"%@",request);

        NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
        [self.data removeAllObjects];
        NSArray *dataList = result[@"list"];
        for (NSDictionary *dic in dataList) {
            YoPortraitModel *model = [[YoPortraitModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.data addObject:model];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];

        if([result[@"current"] integerValue] == [result[@"total"] integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.collectionView.mj_footer resetNoMoreData];
        }

    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [self.collectionView.mj_header endRefreshing];
        [QMUITips showError:error.errorDescription];
    }];
}

- (void)loadMoreData {
    self.pageIndex++;
    
    YoPortraitService *portraitApi = [[YoPortraitService alloc] initWithPageIndex:self.pageIndex pageSize:0 sendType:YoPortraitTypeNearby];
    [portraitApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
        [self.data addObjectsFromArray: [YoPortraitModel mj_objectArrayWithKeyValuesArray:result[@"records"]]];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
        if([result[@"current"] integerValue] == [result[@"total"] integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(JSError *error) {
        self.pageIndex--;
        JSLogInfo(@"%@",error);
        [self.collectionView.mj_footer endRefreshing];
        [QMUITips showError:error.errorDescription];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = self.data.count == 0;
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.portrait = self.data[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitPersonalViewController *personalVC = [[YoPortraitPersonalViewController alloc] init];
    personalVC.portrait = self.data[indexPath.row];
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - YoPortraitLayoutDelegate
- (CGFloat)waterFlowLayout:(YoPortraitLayout *)waterFlowLayout heigthForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    //TODO: - 等脏数据清楚，再打开注释
    YoPortraitModel *data = self.data[index];
    if (data && data.height.floatValue > 0 && data.width.floatValue > 0) {
        return itemWidth * data.height.floatValue / data.width.floatValue;
    }else{
         return  itemWidth *  265.0/ 170.0f;
    }
   
}

- (CGFloat)columnCountInWaterflowLayout:(YoPortraitLayout *)waterflowLayout {
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(YoPortraitLayout *)waterflowLayout {
    return RatioZoom(5);
}

- (CGFloat)rowMarginInWaterflowLayout:(YoPortraitLayout *)waterflowLayout {
    return RatioZoom(10);
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YoPortraitLayout *)waterflowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - lazy load
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

@end
