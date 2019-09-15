//
//  YoAppointmentViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAppointmentViewController.h"
#import "YoPublishViewController.h"
#import "YoAppointmentCell.h"
#import <SDCycleScrollView.h>
#import "YoDialogViewController.h"
#import "YoCityTablePickerView.h"
#import "YoCityPickerView.h"

#import "YoLocationManager.h"
#import "Const.h"
#import "AppointmentListService.h"

static NSString * const kCellIdentifier = @"cell";

@interface YoAppointmentViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, QMUICellHeightCache_UITableViewDataSource, YoAppointmentCellDelegate>
@property(nonatomic, strong) SDCycleScrollView *scrollView;  //bannnerView
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
@property(nonatomic, strong) QMUIButton *leftNavBtn;
@end

@implementation YoAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"一处修改，全局生效。",
                       @"的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。"
                       ];
    
   
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    
    [self tableViewDidTriggerHeaderRefresh];
}


- (void)initSubviews {
    [super initSubviews];
    
    [self initScrollView];
    [self initNavigationPopView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"icon_join_appointment") title:@"报名广播" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            YoPublishViewController *publishVc = [[YoPublishViewController alloc] init];
                                            publishVc.title = @"发布报名广播";
                                            [weakSelf.navigationController pushViewController:publishVc animated:YES];
                                        }],
                                        [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"icon_nomal_appointment") title:@"普通广播" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                            [weakSelf.popupAtBarButtonItem hideWithAnimated:YES];
                                            YoPublishViewController *publishVc = [[YoPublishViewController alloc] init];
                                            publishVc.title = @"发布普通广播";
                                            [weakSelf.navigationController pushViewController:publishVc animated:YES];
                                        }]
                                        ];
    
}


- (void)tableViewDidTriggerHeaderRefresh {
    self.page = 1;
//    AppointmentListService *searchApi = [[AppointmentListService alloc] initWithPageIndex:self.page pageSize:ceilf(SCREEN_HEIGHT/100) cityCodes:@""];
//    [searchApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
//        JSLogInfo(@"data:%@",data);
//        [self tableViewDidFinishTriggerHeader:YES reload:YES];
//    } failure:^(JSError *error) {
//        [self tableViewDidFinishTriggerHeader:YES reload:NO];
//    }];
}

- (void)tableViewDidTriggerFooterRefresh {
    self.page = self.page + 1;
    AppointmentListService *searchApi = [[AppointmentListService alloc] initWithPageIndex:self.page pageSize:ceilf(SCREEN_HEIGHT/100) cityCodes:@""];
    [searchApi js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        JSLogInfo(@"data:%@",data);
//                    for (LGFoodHotModel *model in [LGFoodHotModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]]) {
//                        [self.resultsDataArr addObject:model];
//                    }
//                    if (ceilf(SCREEN_HEIGHT/100 > [[data objectForKey:@"count"] integerValue])) {
//                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                    } else {
//                        [self.tableView.mj_footer endRefreshing];
//                    }
//                    [self.tableView reloadData];
        
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }];
}


- (void)initScrollView {
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.qmui_width, RatioZoom(130)) delegate:self placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
    self.scrollView.currentPageDotImage = [UIImage imageNamed:@"icon_dot_current"];
    self.scrollView.pageDotImage = [UIImage imageNamed:@"icon_dot_inactive"];
    self.scrollView.autoScrollTimeInterval = 4;
    NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";

    self.scrollView.imageURLStringsGroup = @[url,url,url];
    self.tableView.tableHeaderView = self.scrollView;
}

/// 搭配 QMUICellHeightCache 使用，对于 UITableView 而言如果要用 QMUICellHeightCache 那套高度计算方式，则必须实现这个方法
-(UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:kCellIdentifier]) {
        YoAppointmentCell *cell = (YoAppointmentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[YoAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoAppointmentCell *cell = (YoAppointmentCell *)[self qmui_tableView:tableView cellWithIdentifier:kCellIdentifier];
    cell.contentLabelString = self.dataArray[indexPath.row];
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.picArray = @[@"1",@"2",@"3"];
    }
    if (indexPath.row == 1) {
        cell.picArray = @[@"1",@"2"];
    }
    if (indexPath.row == 2) {
        cell.picArray = @[@"1",@"2",@"3",@"1",@"2",@"3"];
    }
    if (indexPath.row == 3) {
        cell.picArray = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
    }
    if (indexPath.row == 4) {
        cell.picArray = @[@"1",@"2",@"3",@"1"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView qmui_heightForCellWithIdentifier:kCellIdentifier cacheByIndexPath:indexPath configuration:^(__kindof YoAppointmentCell *cell) {
        cell.contentLabelString = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.picArray = @[@"1",@"2",@"3"];
        }
        if (indexPath.row == 1) {
            cell.picArray = @[@"1",@"2"];
        }
        if (indexPath.row == 2) {
            cell.picArray = @[@"1",@"2",@"3",@"1",@"2",@"3"];
        }
        if (indexPath.row == 3) {
            cell.picArray = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
        }
        if (indexPath.row == 4) {
            cell.picArray = @[@"1",@"2",@"3",@"1"];
        }
    }];
}

#pragma mark - YoAppointmentCellDelegate
- (void)YoAppointmentCell:(YoAppointmentCell *)cell didClickJoinBtn:(NSInteger)appointmentId {
    JSLogInfo(@"%ld",appointmentId);
    
    YoDialogViewController *dialogViewController = [[YoDialogViewController alloc] init];
    dialogViewController.title = @"标题";
    dialogViewController.contentLabelString = @"经过认证的女士才可以报名\n约会哦！";
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    [dialogViewController show];
}



#pragma mark - Event
- (void)handleNavRightBarButtonEvent {
    
    if (self.popupAtBarButtonItem.isShowing) {
        [self.popupAtBarButtonItem hideWithAnimated:YES];
    } else {
        // 相对于右上角的按钮布局
        self.popupAtBarButtonItem.sourceBarItem = self.navigationItem.rightBarButtonItem;
        [self.popupAtBarButtonItem showWithAnimated:YES];
    }
}

- (void)handleNavLeftBarButtonEvent {
    __weak __typeof(self)weakSelf = self;
    [YoCityPickerView showWithblock:^(NSString * _Nonnull provinceName, NSString * _Nonnull cityName, NSString * _Nonnull cityCode) {
        JSLogInfo(@"%@ %@  %@",provinceName, cityName, cityCode);
        [weakSelf.leftNavBtn setTitle:cityName forState:UIControlStateNormal];
    }];
}





- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"约会";
    
    self.leftNavBtn = [[QMUIButton alloc] init];
    [self.leftNavBtn setTitle:YoUserDefault.city forState:UIControlStateNormal];
    [self.leftNavBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    self.leftNavBtn.titleLabel.font = UIFontMake(15);
    [self.leftNavBtn setImage:UIImageMake(@"btn_nav_item_down") forState:UIControlStateNormal];
    self.leftNavBtn.imagePosition = QMUIButtonImagePositionRight;
    
    [self.leftNavBtn addTarget:self action:@selector(handleNavLeftBarButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"btn_nav_item_add"] target:self action:@selector(handleNavRightBarButtonEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}



@end
