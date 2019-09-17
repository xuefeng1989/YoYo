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
#import "YoMyPhotoService.h"
#import "YoImageModel.h"
#import "MJRefresh.h"
#import "GKPhotoBrowser.h"
#import "YoSetPhotoStatuesTypeService.h"
#import "YoCenterBaseCollectionView.h"
#import "YoBaseTableView.h"
#import "YoPhotoViewController.h"

CGFloat const HeaderImageViewHeight = 240;
@interface YoMinePhotoController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) QMUILabel *topTitleLabel;
@property (nonatomic, strong) QMUILabel *topTipLabel;
@property (nonatomic, strong) QMUIButton *backButton;
@property (nonatomic, strong) QMUILabel *titleL;
@property (nonatomic, strong) YoBaseTableView *tableView;
@property (nonatomic, strong) YoPhotoViewController *photoView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic) BOOL cannotScroll;
@end

@implementation YoMinePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
     [self addChildViewController:self.photoView];
    [self.footerView addSubview:self.photoView.view];
    [self.headerImageView addSubview:self.topView];
    [self.topView addSubview:self.topTitleLabel];
    [self.topView addSubview:self.topTipLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleL];
}
- (UIView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -HeaderImageViewHeight, SCREEN_WIDTH, HeaderImageViewHeight)];
        _headerImageView.backgroundColor = UIColorGlobal;
    }
    return _headerImageView;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(RatioZoom(60));
        make.bottom.mas_equalTo(self.headerImageView);
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.photoView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
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


#pragma mark - lazy load
- (YoPhotoViewController *)photoView
{
    if (!_photoView) {
        _photoView = [[YoPhotoViewController alloc] init];
        _photoView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HeaderImageViewHeight);
        __weak __typeof(self)weakSelf = self;
        [_photoView setBlock:^(NSString * _Nonnull text) {
            weakSelf.topTitleLabel.text = text;
        }];
    }
    return _photoView;
}
- (UIImageView *)topView {
    if (!_topView) {
        _topView = [UIImageView new];
        UIImage *image = [UIImage qmui_imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, RatioZoom(60)) cornerRadiusArray:@[@(20), @(0), @(0), @(20)]];
        _topView.image = image;
    }
    return _topView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YoBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
        _tableView.contentInset = UIEdgeInsetsMake(HeaderImageViewHeight, 0, 0, 0);
        [_tableView setContentOffset:CGPointMake(0, -HeaderImageViewHeight)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    CGFloat stuBar;
    if (@available(iOS 11.0, *)) {
        if (is_iPhoneXSerious) {
            stuBar = 88.0f;
        }else{
            stuBar = 64.0f;
        }
    } else {
        // Fallback on earlier versions
        stuBar = 64.0f;
    }

    CGFloat criticalPointOffsetY = TabBarHeight + stuBar - HeaderImageViewHeight;
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (contentOffsetY >= criticalPointOffsetY) {
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
         [self.photoView makePageViewControllerScroll:YES];
    } else {
        if (self.cannotScroll) {
            //“维持吸顶状态”
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        }
    }
}
- (void)pageViewControllerLeaveTop {
    self.cannotScroll = NO;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (UIView *)footerView {
    if (!_footerView) {
        //如果当前控制器存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - ToolBarHeight)];
    }
    return _footerView;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGFLOAT_MIN;
}

//解决tableView在group类型下tableView头部和底部多余空白的问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - HGSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.tableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {
    self.tableView.scrollEnabled = YES;
}


@end
