//
//  YoCityTablePickerView.m
//  Yoyo
//
//  Created by ning on 2019/6/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCityTablePickerView.h"
#import "Const.h"

const CGFloat leftTableWidth = 100;
const CGFloat tableHeight = 44;

@interface YoCityTablePickerView() <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *leftTabView;
@property(nonatomic, strong) UITableView *rightTabView;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *lineView;
/// 标题栏
@property(nonatomic, strong) UIView *titleBarView;
@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, strong) QMUIButton *comfirmBtn;
@property(nonatomic, strong) QMUIButton *cancelBtn;
@property(nonatomic, strong) NSArray *allDataArr;

@property(nonatomic, strong) NSMutableArray *selectedCityArray;
@property(nonatomic, strong) NSMutableArray *selectedCityCodeArray;


@property(nonatomic, strong) NSArray *firstDataArray;
@property(nonatomic, strong) NSArray *secondDataArray;

@property(nonatomic, assign) NSInteger maxCount;

@end
@implementation YoCityTablePickerView


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
        
        
        CGFloat content_height = 264 * 2;
        CGFloat titleBar_height = 50;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, content_height)];
        [self addSubview:self.contentView];
        
        
        self.titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleBar_height)];
        self.titleBarView.backgroundColor = UIColorWhite;
        [self.contentView addSubview:self.titleBarView];
        
        self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height - PixelOne, SCREEN_WIDTH, PixelOne)];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.titleBarView addSubview:self.lineView];
        
        
        self.leftTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height, leftTableWidth, self.contentView.qmui_height - self.titleBarView.qmui_height) style:UITableViewStylePlain];
        self.leftTabView.dataSource = self;
        self.leftTabView.delegate = self;
        self.leftTabView.backgroundColor = UIColorMake(243, 243, 243);
        self.leftTabView.tableFooterView = [UIView new];
        //    self.leftTabView.separatorColor = UIColorSeparator;
        self.leftTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.leftTabView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:self.leftTabView];
        
        
        self.rightTabView = [[UITableView alloc]initWithFrame:CGRectMake(leftTableWidth, self.titleBarView.qmui_height, SCREEN_WIDTH - leftTableWidth, self.contentView.qmui_height - self.titleBarView.qmui_height) style:UITableViewStylePlain];
        self.rightTabView.dataSource = self;
        self.rightTabView.delegate = self;
        self.rightTabView.backgroundColor = [UIColor whiteColor];
        self.rightTabView.tableFooterView = [UIView new];
        self.rightTabView.separatorColor = UIColorSeparator;
        self.rightTabView.allowsMultipleSelection = YES;
//        self.rightTabView.showsVerticalScrollIndicator = NO;
//        self.rightTabView.scrollEnabled = NO;
        [self.contentView addSubview:self.rightTabView];
        
        
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
        
        
    }
    return self;
}

+ (instancetype)showWithblock:(cityCodeMulSelectedBlock)block {
    YoCityTablePickerView *pick = [[YoCityTablePickerView alloc] init];
    [pick initData];
    [pick show];
    pick.block = block;
    return pick;
}

- (void)seletedMaxCount:(NSInteger)maxCount block:(seletedMaxCountBlock)maxBlock {
    _maxCount = maxCount;
    
    self.maxBlock = maxBlock;
}

- (void)initData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:path];
    self.allDataArr = dataArray;
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        [provinceArray addObject:dict[@"province"]];
        if (i == 0) {
            self.secondDataArray = dict[@"cities"];
        }
    }
    self.firstDataArray = provinceArray;
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


- (void)didClickComfirmHandler {
    if (self.maxBlock) {
        if (_maxCount < self.selectedCityArray.count) {
            self.maxBlock(true);
            return;
        }
    }
    [self dismiss];
    if (self.block) {
        self.block(self.selectedCityArray, self.selectedCityCodeArray);
    }
}

- (void)didClickCancelHandler {
    [self dismiss];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTabView) {
        return self.firstDataArray.count;
    }
    return self.secondDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTabView) {
        static NSString *reuseID = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            
            QMUILabel *titleLab = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 0, leftTableWidth, tableHeight)];
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.textColor = UIColorBlackFont;
            titleLab.font = UIFontMake(13);
            titleLab.tag = 99;
            [cell.contentView addSubview:titleLab];
            
            UIView *selectView = [[UIView alloc] initWithFrame:cell.frame];
            selectView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectView;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
        }
        UILabel *titleLab = [cell.contentView viewWithTag:99];
        titleLab.text = self.firstDataArray[indexPath.row];
        cell.backgroundColor = UIColorMake(243, 243, 243);
        
        if (indexPath.row == 0) {
            [_leftTabView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;
        
    } else {
        static NSString *identifier = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            QMUIButton *selectBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, tableHeight, tableHeight)];
            [selectBtn setImage:[UIImage imageNamed:@"icon_tick_nomal"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"icon_tick_select"] forState:UIControlStateSelected];
            selectBtn.tag = 100;
            selectBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:selectBtn];
            
            QMUILabel *titleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame), 0, self.rightTabView.qmui_width - CGRectGetMaxX(selectBtn.frame), tableHeight)];
            titleLabel.textColor = UIColorBlackFont;
            titleLabel.font = UIFontMake(15);
            titleLabel.tag = 101;
            [cell.contentView addSubview:titleLabel];
        }
        
        QMUIButton *selectBtn = [cell.contentView viewWithTag:100];
        QMUILabel *titleLabel = [cell.contentView viewWithTag:101];
        NSDictionary *dict = self.secondDataArray[indexPath.row];
        titleLabel.text = dict[@"name"];
        selectBtn.selected = NO;

        if ([self.selectedCityArray containsObject:titleLabel.text]) {
            selectBtn.selected = YES;
        }
        
        return cell;
    }
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
    if (_leftTabView == tableView) {
        self.secondDataArray = self.allDataArr[indexPath.row][@"cities"];
        [self.rightTabView reloadData];

    } else {
        [self changeBtnStatus:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftTabView == tableView) {
    } else {
        [self changeBtnStatus:indexPath];
    }
}


- (void)changeBtnStatus:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.secondDataArray[indexPath.row];
    NSString *str = dict[@"name"];
    NSString *code = dict[@"code"];

    UITableViewCell *cell = [_rightTabView cellForRowAtIndexPath:indexPath];
    QMUIButton *selectBtn = [cell.contentView viewWithTag:100];

    selectBtn.selected = !selectBtn.selected;
    if (selectBtn.selected) {
        [self.selectedCityArray addObject:str];
        [self.selectedCityCodeArray addObject:code];
    } else {
        [self.selectedCityArray removeObject:str];
        [self.selectedCityCodeArray removeObject:code];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}



-(NSMutableArray *)selectedCityArray {
    if (_selectedCityArray == nil) {
        _selectedCityArray = [NSMutableArray array];
    }
    return _selectedCityArray;
}

-(NSMutableArray *)selectedCityCodeArray {
    if (_selectedCityCodeArray == nil) {
        _selectedCityCodeArray = [NSMutableArray array];
    }
    return _selectedCityCodeArray;
}

@end
