//
//  YoCityFilterController.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoHomeCityFilterController.h"

#import "YoHomeListCell.h"

@interface YoHomeCityFilterController ()

@end

@implementation YoHomeCityFilterController

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoHomeListCell *cell = [YoHomeListCell cellWithTableView:tableView];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorSeparator size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}


@end
