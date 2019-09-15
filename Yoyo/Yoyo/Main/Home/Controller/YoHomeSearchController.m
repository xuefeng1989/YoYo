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

@interface YoHomeSearchController () <UISearchBarDelegate, QMUITableViewDelegate, QMUITableViewDataSource>
@property(nonatomic, strong) QMUISearchBar *searchBar;
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, strong) QMUITableView *fuzzyTableView;
@property(nonatomic, strong) NSArray *nicknameDataArray;

@end

@implementation YoHomeSearchController


- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.backgroundColor = UIColorRed;
    
    
    self.dataArray = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
    
    self.nicknameDataArray =  @[@"昆明淤青",@"云青",@"雨晴",@"吁请",@"玉清",@"余庆"];

}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    

    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, self.view.qmui_width - (44 + 25), 36);
    titleView.backgroundColor = UIColorRed;
    
    self.searchBar = [[QMUISearchBar alloc] init];
    self.searchBar.frame = titleView.bounds;
    self.searchBar.placeholder = @"输入昵称搜索";
    self.searchBar.qmui_textField.font = UIFontMake(13);
    //    self.searchBar.backgroundColor = UIColorGrayBackGround1;
    self.searchBar.delegate = self;
    self.searchBar.qmui_textFieldMargins = UIEdgeInsetsMake(-4, -8, -4, -8);
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    
    self.navigationItem.leftBarButtonItem = nil;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImageMake(@"icon_search_right_nav_close") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(handleRightBarButtonItemEvent)];

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
        cell.data = self.dataArray[indexPath.row];
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






- (void)handleRightBarButtonItemEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (QMUITableView *)fuzzyTableView {
    if (_fuzzyTableView == nil) {
        _fuzzyTableView = [[QMUITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _fuzzyTableView.dataSource = self;
        _fuzzyTableView.delegate = self;
        _fuzzyTableView.backgroundColor = UIColorRed;
        [self.view addSubview:_fuzzyTableView];
    }
    return _fuzzyTableView;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorSeparator size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}


@end
