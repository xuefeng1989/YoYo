//
//  YoMinePickerViewManager.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePickerViewManager.h"
#import "YoMinePickerCell.h"
#import "Const.h"

@interface YoMinePickerViewManager ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation YoMinePickerViewManager

static YoMinePickerViewManager *instance = nil;


+ (instancetype)manager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
    
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.backgroundView];
    [window addSubview:self.table];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformMakeTranslation(0, -(self.itemArray.count*RatioZoom(50)+NORMAL_Bottom));
    }];

}

- (void)hide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.table removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
    
}

- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
    self.table.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, itemArray.count*RatioZoom(50)+NORMAL_Bottom);
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoMinePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleL.text = self.itemArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (self.block) {
        self.block(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - lazy load

- (UITableView *)table {
    if (!_table) {
//        _table = [[UITableView alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT-(_itemArray.count*RatioZoom(50)+NORMAL_Bottom), SCREEN_WIDTH, _itemArray.count*RatioZoom(50)+NORMAL_Bottom) style:UITableViewStylePlain];
        _table = [[UITableView alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _itemArray.count*RatioZoom(50)+NORMAL_Bottom) style:UITableViewStylePlain];

        _table.rowHeight = RatioZoom(50);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerClass:[YoMinePickerCell class] forCellReuseIdentifier:@"cell"];
        _table.scrollEnabled = NO;
        
        
        
    }
    return _table;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}


@end
