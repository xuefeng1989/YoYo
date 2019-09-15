//
//  YoDataingAndNotificationController.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoDataingAndNotificationController.h"
#import "YoPublishViewController.h"
#import "YoAppointmentCell.h"
#import "YoDialogViewController.h"
#import "YoCityTablePickerView.h"
#import "YoCityPickerView.h"

#import "YoLocationManager.h"
#import "Const.h"
#import "AppointmentListService.h"

static NSString * const kCellIdentifier = @"cell";
@interface YoDataingAndNotificationController ()<UITableViewDelegate, UITableViewDataSource,YoAppointmentCellDelegate>
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
@property(nonatomic, strong) QMUIButton *leftNavBtn;
@end

@implementation YoDataingAndNotificationController

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"广播";
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"btn_nav_item_add"] target:self action:@selector(handleNavRightBarButtonEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)handleNavRightBarButtonEvent{
    
}
@end
