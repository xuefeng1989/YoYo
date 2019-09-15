//
//  YoMinePickerView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePickerView.h"
#import "Const.h"
#import "YoMinePickerCell.h"
#import "NSObject+YoRootViewController.h"

@interface YoMinePickerView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@end

@implementation YoMinePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self addSubview:self.table];
    }
    return self;
}

+ (instancetype)pickerViewWithItem:(NSArray *)item {
    YoMinePickerView *pick = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pick.itemArray = item;
    return pick;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.table.frame, point)) {
        
        [self hide];
    }
}

- (void)show {
    
    self.hidden = NO;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformMakeTranslation(0, self.itemArray.count*RatioZoom(50)+NORMAL_Bottom);

    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }];
}

- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
    self.table.frame = CGRectMake(0, SCREEN_HEIGHT-(_itemArray.count*RatioZoom(50)), SCREEN_WIDTH, _itemArray.count*RatioZoom(50)+NORMAL_Bottom);
    self.table.transform = CGAffineTransformMakeTranslation(0, _itemArray.count*RatioZoom(50)+NORMAL_Bottom);
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


- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.rowHeight = RatioZoom(50);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerClass:[YoMinePickerCell class] forCellReuseIdentifier:@"cell"];
        _table.scrollEnabled = NO;
    }
    return _table;
}
@end
