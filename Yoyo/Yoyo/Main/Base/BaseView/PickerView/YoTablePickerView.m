//
//  YoTablePickerView.m
//  Yoyo
//
//  Created by ning on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoTablePickerView.h"

#import "Const.h"
@interface YoTablePickerView() <UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *lineView;
/// 标题栏
@property(nonatomic, strong) UIView *titleBarView;
@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, strong) QMUIButton *comfirmBtn;
@property(nonatomic, strong) QMUIButton *cancelBtn;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableArray *selectedDataArray;
@property(nonatomic, strong) NSMutableSet *selectedIndexPathSet;


@end
@implementation YoTablePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = [UIScreen mainScreen].bounds;
        //        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        
        CGFloat content_height = 264;
        CGFloat titleBar_height = 50;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, content_height)];
        [self addSubview:self.contentView];
        
        
        self.titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleBar_height)];
        self.titleBarView.backgroundColor = UIColorWhite;
        [self.contentView addSubview:self.titleBarView];
        
        self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height - PixelOne, SCREEN_WIDTH, PixelOne)];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.titleBarView addSubview:self.lineView];
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height, SCREEN_WIDTH, self.contentView.qmui_height - self.titleBarView.qmui_height)];
        self.tableView.backgroundColor = UIColorWhite;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsMultipleSelection = YES;
        [self.contentView addSubview:self.tableView];
        
        
        CGFloat width = 60;
        self.comfirmBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(self.titleBarView.qmui_width - width, 0, width, self.titleBarView.qmui_height)];
        [self.comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.comfirmBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        self.comfirmBtn.titleLabel.font = UIFontMake(14);
        [self.comfirmBtn addTarget:self action:@selector(didClickComfirmHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBarView addSubview:self.comfirmBtn];
        
        self.cancelBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.titleBarView.qmui_height)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = UIFontMake(14);
        [self.cancelBtn addTarget:self action:@selector(didClickCancelHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBarView addSubview:self.cancelBtn];
        
        
        [self initPickerView];
        
        
    }
    return self;
}


+(instancetype)showDataArray:(NSArray *)array block:(selectedTableBlock)block {
    YoTablePickerView *pick = [[YoTablePickerView alloc] init];
    [pick setDataArray:array];
    [pick show];
    pick.block = block;
    return pick;
}


- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y -= self.contentView.frame.size.height;
    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = contentViewFrame;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss {
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y += self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = contentViewFrame;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        //        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}


- (void)initPickerView {
    
}

- (void)didClickComfirmHandler {
    [self dismiss];
    if (self.block) {
        self.block(self.selectedDataArray);
    }
}

- (void)didClickCancelHandler {
    [self dismiss];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QMUIButton *selectBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [selectBtn setImage:[UIImage imageNamed:@"icon_tick_nomal"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"icon_tick_select"] forState:UIControlStateSelected];
        selectBtn.tag = 100;
        selectBtn.userInteractionEnabled = NO;
        [cell.contentView addSubview:selectBtn];
        
        QMUILabel *titleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame), 0, 100, 44)];
        titleLabel.textColor = UIColorBlackFont;
        titleLabel.font = UIFontMake(15);
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
    }
   
    QMUIButton *selectBtn = [cell.contentView viewWithTag:100];
    QMUILabel *titleLabel = [cell.contentView viewWithTag:101];
    titleLabel.text = self.dataArray[indexPath.row];
    selectBtn.selected = NO;
    if ([self.selectedIndexPathSet containsObject:indexPath]) {
        selectBtn.selected = YES;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QMUIButton *selectBtn = [cell.contentView viewWithTag:100];
    selectBtn.selected = cell.isSelected;
    
    [self.selectedDataArray addObject:str];
    [self.selectedIndexPathSet addObject:indexPath];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.dataArray[indexPath.row];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QMUIButton *selectBtn = [cell.contentView viewWithTag:100];
    selectBtn.selected = cell.isSelected;
    
    [self.selectedDataArray removeObject:str];
    [self.selectedIndexPathSet removeObject:indexPath];
}



#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.selectedDataArray = [NSMutableArray array];
    self.selectedIndexPathSet = [NSMutableSet set];
}


@end
