//
//  YoCityPickerView.m
//  Yoyo
//
//  Created by ning on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCityPickerView.h"
#import "Const.h"

@interface YoCityPickerView()
@property(nonatomic, strong) NSArray *allDataArr;
@property(nonatomic, strong) NSArray *firstDataArray;
@property(nonatomic, strong) NSArray *secondDataArray;


@property(nonatomic, copy) NSString *selectedFirstString;
@property(nonatomic, copy) NSString *selectedSecondString;
@property(nonatomic, copy) NSString *selectedCityCode;

@property(nonatomic, assign) NSInteger selectedFirstIndex;
@property(nonatomic, assign) NSInteger selectedSecondIndex;

@end

@implementation YoCityPickerView

+ (instancetype)showWithblock:(cityCodeselectedBlock)block {
    YoCityPickerView *pick = [[YoCityPickerView alloc] init];
    [pick initData];
    [pick show];
    pick.block = block;
    return pick;
}

- (void)initData {
    _selectedFirstIndex = 0;
    _selectedSecondIndex = 0;
    
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

- (void)initPickerView {
    [super initPickerView];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.firstDataArray.count;
    }
    return self.secondDataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = UIColorSeparator;
        }
    }
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = UIFontMake(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    
    if (component == 0) {
        label.text = self.firstDataArray[row];
    } else {
        NSDictionary *dict = self.secondDataArray[row];
        label.text = dict[@"name"];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedFirstString = self.firstDataArray[row];
        _selectedFirstIndex = row;
        
        
        // 选中第一列的row时，把对应row的第二列数据拿出来
        self.secondDataArray = self.allDataArr[row][@"cities"];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
        NSDictionary *dict = self.secondDataArray[0];
        self.selectedSecondString = dict[@"name"];
        self.selectedCityCode = dict[@"code"];
        _selectedSecondIndex = 0;
        // 下面要按照顺序，先刷新，再选择
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (component == 1) {
        NSDictionary *dict = self.secondDataArray[row];
        self.selectedSecondString = dict[@"name"];
        self.selectedCityCode = dict[@"code"];
        _selectedSecondIndex = row;
    }
    
}

- (void)didClickComfirmHandler {
    [super didClickComfirmHandler];
    
    self.selectedFirstString = self.firstDataArray[_selectedFirstIndex];
    NSDictionary *dict = self.secondDataArray[_selectedSecondIndex];
    self.selectedSecondString = dict[@"name"];
    self.selectedCityCode = dict[@"code"];
        
    if (self.block) {
        self.block(self.selectedFirstString, self.selectedSecondString, self.selectedCityCode);
    }
    
}


@end
