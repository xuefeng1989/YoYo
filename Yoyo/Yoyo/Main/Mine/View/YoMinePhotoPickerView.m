//
//  YoMinePhotoPickerView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePhotoPickerView.h"
#import "YoMinePhotoPickerCell.h"
#import "Const.h"
#import <Masonry.h>

@interface YoMinePhotoPickerView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSArray *itemArray;

@end

@implementation YoMinePhotoPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if(YoUserDefault.sex == YoSexTypeWoman ){
            self.itemArray = @[
                               @{@"item":@"公开",@"sub":@"",@"selected":@"true"}.mutableCopy,
                               @{@"item":@"阅后即焚",@"sub":@"",@"selected":@"fasle"}.mutableCopy,
                               @{@"item":@"付费照片",@"sub":@"（默认2元每张）",@"selected":@"false"}.mutableCopy,];
        }else{
            self.itemArray = @[
                               @{@"item":@"公开",@"sub":@"",@"selected":@"true"}.mutableCopy,
                               @{@"item":@"阅后即焚",@"sub":@"",@"selected":@"fasle"}.mutableCopy,];
        }
        
        
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
        
        [self addSubview:self.table];
        CGFloat height = self.itemArray.count > 2? 250:200;
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(RatioZoom(height)+NORMAL_Bottom);
        }];
       UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.backgroundView addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapAction{
     [self hide];
}
#pragma mark - method
- (void)deleteButtonDidClicked {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self hide];
}

- (void)commitButtonDidClicked {
    if (self.commitBlock) {
        for (int i = 0; i < self.itemArray.count; i++) {
            NSDictionary *item = self.itemArray[i];
            if ([item[@"selected"] isEqualToString:@"true"]) {
                self.commitBlock(i);
                break;
            }
        }
    }
    [self hide];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        self.backgroundView.hidden = NO;
    }];
}

- (void)hide {
    self.backgroundView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)setSelectIndex:(NSInteger) selectIndex
{
    if (self.itemArray.count > selectIndex) {
        for (NSInteger i = 0; i < self.itemArray.count; i ++) {
            NSMutableDictionary *item = self.itemArray[i];
            if (i == selectIndex) {
                 item[@"selected"] = @"true";
            }else{
                item[@"selected"] = @"fasle";
            }
        }
    }
    [self.table reloadData];
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoMinePhotoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.config = self.itemArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSMutableDictionary *item in self.itemArray) {
        item[@"selected"] = @"fasle";
    }
    NSMutableDictionary *item = self.itemArray[indexPath.row];
    item[@"selected"] = @"true";
    [self.table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - lazy load
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_table registerClass:[YoMinePhotoPickerCell class] forCellReuseIdentifier:@"cell"];
        _table.rowHeight = RatioZoom(50);
        _table.tableHeaderView = self.headerView;
        _table.tableFooterView = self.footerView;
        _table.delegate = self;
        _table.dataSource = self;
        _table.scrollEnabled = NO;
    }
    return _table;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(50));
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:cancel];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:UIColorSUBContentFont forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(15));
            make.centerY.mas_equalTo(self.headerView);
        }];
        cancel.titleLabel.font = UIFontMake(14);
        
        UIButton *commit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:commit];
        [commit setTitle:@"确定" forState:UIControlStateNormal];
        [commit setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [commit addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [commit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(15));
            make.centerY.mas_equalTo(self.headerView);
        }];
        commit.titleLabel.font = UIFontMake(14);
        
        UILabel *title = [UILabel new];
        [_headerView addSubview:title];
        title.text = @"设置照片";
        title.font = UIFontMake(14);
        title.textColor = UIColorContentFont;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.headerView);
            make.centerY.mas_equalTo(self.headerView);
        }];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(50)+NORMAL_Bottom);
        _footerView.backgroundColor = [UIColor whiteColor];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView addSubview:deleteButton];
        deleteButton.frame = _footerView.bounds;
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
