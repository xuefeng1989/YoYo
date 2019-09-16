//
//  YoHomeSearchController.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeSearchController.h"
#import "YoHomeListCell.h"
#import "Const.h"
#import "YoHomeSearchService.h"
#import "YoHomeListModel.h"
#import "YoOtherFemaleViewController.h"

@interface YoHomeSearchController () <UISearchBarDelegate, QMUITableViewDelegate, QMUITableViewDataSource>
@property(nonatomic, strong) QMUISearchBar *searchBar;
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, strong) QMUITableView *fuzzyTableView;
@property(nonatomic, strong) NSArray *nicknameDataArray;

@end

@implementation YoHomeSearchController


- (void)initSubviews {
    [super initSubviews];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, self.view.qmui_width - (44 + 25), 36);
    titleView.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[QMUISearchBar alloc] init];
    self.searchBar.frame = titleView.bounds;
    self.searchBar.placeholder = @"输入昵称搜索";
    self.searchBar.qmui_textField.font = UIFontMake(13);
    self.searchBar.delegate = self;
    self.searchBar.qmui_textFieldMargins = UIEdgeInsetsMake(-4, -8, -4, -8);
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem = nil;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImageMake(@"icon_search_right_nav_close") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(handleRightBarButtonItemEvent)];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self handleSearchBarItemEvent];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.dataArray.count;
    } else {
        return self.nicknameDataArray.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        YoHomeListCell *cell = [YoHomeListCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    } else {
        QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.imageView.image = UIImageMake(@"icon_search_list");
            cell.textLabel.text = self.nicknameDataArray[indexPath.row];
        }
        cell.imageEdgeInsets = UIEdgeInsetsZero;
        cell.textLabelEdgeInsets = UIEdgeInsetsZero;
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
        cell.accessoryEdgeInsets = UIEdgeInsetsZero;
        
        [cell updateCellAppearanceWithIndexPath:indexPath];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 90;
    } else {
        return 44;
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.tableView) {
        YoOtherFemaleViewController *detailVc = [[YoOtherFemaleViewController alloc] init];
        YoHomeListModel *model = (YoHomeListModel *)self.dataArray[indexPath.row];
        detailVc.userNo = [NSString stringWithFormat:@"%ld",model.userNo];
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        self.fuzzyTableView.hidden = YES;
        self.tableView.hidden = NO;
        
        JSLogInfo(@"searchText:%@",self.nicknameDataArray[indexPath.row]);
        [self.tableView reloadData];
    }
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.fuzzyTableView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.fuzzyTableView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

- (void)handleSearchBarItemEvent {
    self.fuzzyTableView.hidden = YES;
    self.tableView.hidden = NO;
    YoHomeSearchService *service = [[YoHomeSearchService alloc] initWithlikeName:self.searchBar.text Current:1 cityCodes:50];
    [service js_startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self.dataArray removeAllObjects];
        
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *dataList = data[@"list"];
        for (NSDictionary *dic in dataList) {
            YoHomeListModel *model = [[YoHomeListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(JSError *error) {
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
    [self.searchBar resignFirstResponder];
}


- (QMUITableView *)fuzzyTableView {
    if (_fuzzyTableView == nil) {
        _fuzzyTableView = [[QMUITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _fuzzyTableView.dataSource = self;
        _fuzzyTableView.delegate = self;
        _fuzzyTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_fuzzyTableView];
    }
    return _fuzzyTableView;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorSeparator size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}


@end
