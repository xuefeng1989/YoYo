//
//  YoOtherMaleViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoOtherMaleViewController.h"
#import "YoOtherHeaderView.h"
#import "YoOtherTableViewCell.h"
#import "YoOtherFooterView.h"
#import "YoReportViewController.h"
#import <Masonry.h>

@interface YoOtherMaleViewController ()<UITableViewDataSource, UITableViewDelegate, YoOtherHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YoOtherHeaderView *headerView;
@property (nonatomic, strong) YoOtherFooterView *footerView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
@property (nonatomic, strong) QMUIButton *moreButton;


@end

@implementation YoOtherMaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.itemArray = @[
                       
                       [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的写真集" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                       [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的广播" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorClear hideRightImage:NO],
                       [[YoOtherTableViewCellConfig alloc] initWithTitle:@"他的介绍" rightImageString:@"mine_arrow" rightTitle:@"" rightTitleColor:UIColorSUBContentFont hideRightImage:YES],
                      
                       ];
    
    [self loadImage];
    
}
- (void)initSubviews {
    [super initSubviews];
    [self initNavigationPopView];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.moreButton];
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-RatioZoom(15));
//        make.top.mas_equalTo(NORMAL_Y-RatioZoom(30));
//    }];
}


- (void)initNavigationPopView {
    // 在 UIBarButtonItem 上显示
    __weak __typeof(self)weakSelf = self;
    self.popupAtBarButtonItem = [[QMUIPopupMenuView alloc] init];
    self.popupAtBarButtonItem.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupAtBarButtonItem.maximumWidth = 180;
    self.popupAtBarButtonItem.shouldShowItemSeparator = YES;
    self.popupAtBarButtonItem.itemTitleFont = UIFontMake(16);
    self.popupAtBarButtonItem.itemTitleColor = UIColorBlackFont;
    self.popupAtBarButtonItem.items = @[
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"") title:@"拉黑" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            [QMUITips showInfo:@"拉黑"];
                                        }],
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"") title:@"举报" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            YoReportViewController *reportVc = [[YoReportViewController alloc] init];
                                            reportVc.title = @"举报";
                                            [weakSelf.navigationController pushViewController:reportVc animated:YES];
                                        }]
                                        ];
    
}



- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"mine_more"] target:self action:@selector(moreButtonDidClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - method
- (void)loadImage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 20; i++) {
            if (i < 7) {
                YoOtherHeaderViewModel *model = [[YoOtherHeaderViewModel alloc] initWithType:YoMineUploadCollectionViewCellTypeNormal photo:[UIImage imageNamed:@""] imageUrl:@""];
                [self.photoArray insertObject:model atIndex:self.photoArray.count-1];
            }else if (i == 7) {
                continue;
            }else {
                YoOtherHeaderViewModel *model = [[YoOtherHeaderViewModel alloc] initWithType:YoMineUploadCollectionViewCellTypeMore photo:[UIImage imageNamed:@""] imageUrl:@""];
                self.photoArray[6] = model;
                break;
            }
        }
        [self calculatorHeight];
        self.headerView.dataArray = self.photoArray;
        [self.tableView reloadData];
    });
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonDidClicked {
    if (self.popupAtBarButtonItem.isShowing) {
        [self.popupAtBarButtonItem hideWithAnimated:YES];
    } else {
        // 相对于右上角的按钮布局
        self.popupAtBarButtonItem.sourceBarItem = self.navigationItem.rightBarButtonItem;
        [self.popupAtBarButtonItem showWithAnimated:YES];
    }
}

- (void)calculatorHeight {
    CGFloat h = 0;
    if (self.photoArray.count < 4) {
        h = RatioZoom(340); // 一排图片
    }else {
        h =  RatioZoom(420); // 二排图片
    }
    
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
}

#pragma mark - UITableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return RatioZoom(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.config = self.itemArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RatioZoom(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RatioZoom(10);
}

#pragma mark - YoOtherHeaderViewDelegate
- (void)otherHeaderView:(YoOtherHeaderView *)view didClickedIndex:(NSInteger)index {
    [QMUITips showInfo:[NSString stringWithFormat:@"点击了%zd",index]];
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NORMAL_Y, SCREEN_WIDTH, SCREEN_HEIGHT+NORMAL_Y) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = RatioZoom(52);
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        self.headerView.dataArray = self.photoArray;
        [_tableView registerClass:[YoOtherTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (YoOtherHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YoOtherHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(340))];
        _headerView.delegate = self;
//        [_headerView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (YoOtherFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[YoOtherFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(170))];
//        [_footerView hideRelationButton];
    }
    return _footerView;
}

- (QMUIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"mine_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
        YoOtherHeaderViewModel *model = [[YoOtherHeaderViewModel alloc] initWithType:YoMineUploadCollectionViewCellTypeUpload photo:[UIImage imageNamed:@"mine_photo_white_add"] imageUrl:@""];
        [_photoArray addObject:model];
    }
    return _photoArray;
}
@end
