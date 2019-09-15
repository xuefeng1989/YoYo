//
//  YoPortraitAddTagController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitAddTagController.h"
#import "YoAddTagTableViewCell.h"
#import "YoPortraitTagModel.h"

@interface YoPortraitAddTagController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YoPortraitAddTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray array];
    
    YoPortraitTagModel *tagModel0 = [YoPortraitTagModel new];
    tagModel0.title = @"昆明 海天国际";
    tagModel0.subTitle = @"云南省昆明市盘龙区海天国际 200 米";
    tagModel0.type = 0;
    
    YoPortraitTagModel *tagModel = [YoPortraitTagModel new];
    tagModel.title = @"昆明 昆明广场";
    tagModel.subTitle = @"云南省昆明市盘龙区昆明广场 198 米";
    tagModel.type = 1;
    
    YoPortraitTagModel *tagModel1 = [YoPortraitTagModel new];
    tagModel1.title = @"昆明 1903公园";
    tagModel1.subTitle = @"云南省昆明市官渡区1903公园";
    tagModel1.type = 1;
    
    YoPortraitTagModel *tagModel2 = [YoPortraitTagModel new];
    tagModel2.title = @"昆明 呈贡大学城";
    tagModel2.subTitle = @"云南省昆明市呈贡区";
    tagModel2.type = 1;
    
    YoPortraitTagModel *tagModel3 = [YoPortraitTagModel new];
    tagModel3.title = @"上海 陆家嘴";
    tagModel3.subTitle = @"上海市浦东新区陆家嘴";
    tagModel3.type = 1;
    
    YoPortraitTagModel *tagModel4 = [YoPortraitTagModel new];
    tagModel4.title = @"北京 钓鱼台";
    tagModel4.subTitle = @"北京市钓鱼台";
    tagModel4.type = 1;
    [self.dataArray addObject:tagModel0];
    [self.dataArray addObject:tagModel];
    [self.dataArray addObject:tagModel1];
    [self.dataArray addObject:tagModel2];
    [self.dataArray addObject:tagModel3];
    [self.dataArray addObject:tagModel4];
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, self.view.qmui_width - (44 + 25), 36);
    
    QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = titleView.bounds;
    [btn setImage:UIImageMake(@"icon_nav_title_search") forState:UIControlStateNormal];
    [btn setTitle:@"输入昵称搜索" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
    btn.titleLabel.font = UIFontMake(13);
    btn.backgroundColor = UIColorGrayBackGround1;
    btn.adjustsButtonWhenHighlighted = NO;
    btn.imagePosition = QMUIButtonImagePositionLeft;
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.spacingBetweenImageAndTitle = 2;
    [btn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    self.navigationItem.titleView = titleView;
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = UIFontMake(14);
    [cancelButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
}

#pragma mark - method
- (void)addTitle {
        UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alVC addTextFieldWithConfigurationHandler:nil];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *text = ((UITextField *)(alVC.textFields[0])).text;
            if (text.length) {
                if (self.block) {
                    self.block(text);
                }
                [self popController];
            }
        }];
        [alVC addAction:ac];
        [self presentViewController:alVC animated:YES completion:nil];
}


#pragma mark - UITableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoAddTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     YoPortraitTagModel *model = self.dataArray[indexPath.row];
    if (model.type == YoAddTagTableViewCellTypeAdd) {
        [self addTitle];
    }else {
        if (self.block) {
            self.block(model.title);
            [self popController];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorClear];;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorClear size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}

- (UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoPortraitAddTagController";
}

#pragma mark - method
- (void)clickSearchBtn {
//    YoHomeSearchController *searchVc = [[YoHomeSearchController alloc] init];
//    YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:searchVc];
//    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)popController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YoAddTagTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = RatioZoom(80);
    }
    return _tableView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return _searchTextField;
}

@end
