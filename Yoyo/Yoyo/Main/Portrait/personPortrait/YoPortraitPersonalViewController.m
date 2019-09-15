//
//  YoYoPortraitPersonalViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitPersonalViewController.h"
#import "YoPortraitPersonalCell.h"
#import "YoPortraitPersonalHeaderView.h"
#import "YoPortraitPersonalService.h"
#import "YoDataItem.h"
#import "YoPortraitPersonalModel.h"
#import <HWPanModal.h>
#import "YoPortraitNavigationController.h"
#import "YoAlbumService.h"

@interface YoPortraitPersonalViewController ()

@property (nonatomic, strong) YoPortraitPersonalHeaderView *headerView;
@property (nonatomic, strong) YoDataItem *totolData;
@property (nonatomic, strong) NSMutableArray<YoPortraitPersonalModel *> *data;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation YoPortraitPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    [self.tableView registerClass:[YoPortraitPersonalCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;

}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"个人写真集";
}

#pragma mark - setters
- (void)setPortrait:(YoPortraitModel *)portrait {
    _portrait = portrait;
    self.headerView.portrait = portrait;
    [self.dataArray addObject:portrait];
    [self.tableView reloadData];
}
- (void)personPortrait{
    
}
#pragma mark - request
- (void)moreButtonDidClicked {
    
}

- (void)likeButtonDidClicked:(YoPortraitPersonalModel *)model AtIndexPath:(NSIndexPath *)indexPath  {
    // 点赞
    
}

// 点赞
- (void)like:(YoPortraitPersonalModel *)model AtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf;
    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.authorId sendType:YoAlbumTypePraise];
    [QMUITips showLoadingInView:weakSelf.view];
    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        model.countAlbumLike = [NSNumber numberWithInteger:model.countAlbumLike.integerValue + 1];
        model.like = YES;
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription];
    }];
}

// 取消点赞
- (void)likeCancel:(YoPortraitPersonalModel *)model AtIndexPath:(NSIndexPath *)indexPath  {
    MJWeakSelf;
    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.authorId sendType:YoAlbumTypePraiseCancel];
    [QMUITips showLoadingInView:weakSelf.view];
    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        model.countAlbumLike = [NSNumber numberWithInteger:model.countAlbumLike.integerValue - 1];
        model.like = NO;
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription];
    }];
}

- (void)collectionDidClicked:(YoPortraitPersonalModel *)model AtIndexPath:(NSIndexPath *)indexPath {
    if (model.like) {
        [self likeCancel:model AtIndexPath:indexPath];
    }else{
        [self like:model AtIndexPath:indexPath];
    }
}
// 收藏
- (void)collect:(YoPortraitPersonalModel *)model {
    MJWeakSelf;
    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.authorId sendType:YoAlbumTypeCollect];
    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        model.collect++;
        [weakSelf.tableView reloadData];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription];
    }];
}
// 取消收藏
- (void)collectCancel:(YoPortraitPersonalModel *)model {
    MJWeakSelf;
    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.authorId sendType:YoAlbumTypeCollectCancel];
    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        model.collect--;
        [weakSelf.tableView reloadData];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription];
    }];
}

- (void)loadNewData {
    self.pageIndex = 0;
    YoPortraitPersonalService *personalApi = [[YoPortraitPersonalService alloc] initWithUserNo:self.portrait.userNo];
    [personalApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
        self.totolData = [YoDataItem mj_objectWithKeyValues:result];
        [self.data removeAllObjects];
        NSArray *albums = result[@"albums"];
        for (NSDictionary *dic in albums) {
            YoPortraitPersonalModel *model = [[YoPortraitPersonalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.avatar = self.portrait.avatar;
            model.userName = self.portrait.userName;
            [self.data addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];

    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [QMUITips showError:error.errorDescription];
    }];
}

- (void)loadMoreData {
    self.pageIndex++;

    YoPortraitPersonalService *personalApi = [[YoPortraitPersonalService alloc] initWithUserNo:self.portrait.userNo];
    [personalApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {

        NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
        self.totolData = [YoDataItem mj_objectWithKeyValues:result];
        NSArray *albums = result[@"albums"];
        for (NSDictionary *dic in albums) {
            YoPortraitPersonalModel *model = [[YoPortraitPersonalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.avatar = self.portrait.avatar;
            model.userName = self.portrait.userName;
            [self.data addObject:model];
        }

        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    
        if([result[@"current"] integerValue] == [result[@"total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    } failure:^(JSError *error) {
        self.pageIndex--;
        JSLogInfo(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
        [QMUITips showError:error.errorDescription];
    }];
}



#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = self.data.count == 0;
    return self.data.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.data[indexPath.row];
    MJWeakSelf;
    cell.commentBlock = ^(YoPortraitPersonalModel * model) {
        YoPortraitNavigationController *nav = [[YoPortraitNavigationController alloc] init];
        nav.portrait = weakSelf.portrait;
        [weakSelf presentPanModal:nav];
    };
    
    cell.likeBlock = ^(YoPortraitPersonalModel * model) {
        [weakSelf likeButtonDidClicked:model AtIndexPath:indexPath];
    };
    cell.collectBlock = ^(YoPortraitPersonalModel * model) {
        [weakSelf collectionDidClicked:model AtIndexPath:indexPath];
    };
    cell.moreBlock = ^(YoPortraitPersonalModel * model) {
        [weakSelf.tableView reloadData];
    };

    return cell;
}

#pragma mark - lazy load
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (YoPortraitPersonalHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YoPortraitPersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(100))];
    }
    return _headerView;
}
@end
