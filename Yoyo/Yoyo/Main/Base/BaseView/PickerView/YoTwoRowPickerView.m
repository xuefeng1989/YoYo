//
//  YoTwoRowPickerView.m
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoTwoRowPickerView.h"

#import "Const.h"
@interface YoTwoRowPickerView()
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSArray *firstDataArray;
@property(nonatomic, strong) NSArray *secondDataArray;

//@property(nonatomic, copy) NSString *firstKey;
//@property(nonatomic, copy) NSString *secondKey;

@property(nonatomic, copy) NSString *selectedFirstString;
@property(nonatomic, copy) NSString *selectedSecondString;
@property(nonatomic, assign) NSInteger selectedFirstIndex;
@property(nonatomic, assign) NSInteger selectedSecondIndex;

@end

@implementation YoTwoRowPickerView

+ (instancetype)showDataArray:(NSArray *)array block:(twoRowselectedBlock)block {
    YoTwoRowPickerView *pick = [[YoTwoRowPickerView alloc] init];
//    pick.firstKey = firstKey;
//    pick.secondKey = secondKey;
    [pick setDataArray:array];
    [pick show];
    pick.block = block;
    return pick;
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
        label.text = self.secondDataArray[row];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedFirstString = self.firstDataArray[row];
        _selectedFirstIndex = row;
        
        // 选中第一列的row时，把对应row的第二列数据拿出来
        self.secondDataArray = self.dataArray[row][@"second"];
        _selectedSecondIndex = 0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (component == 1) {
        self.selectedSecondString = self.secondDataArray[row];
        _selectedSecondIndex = row;
    }
    
}

- (void)didClickComfirmHandler {
    [super didClickComfirmHandler];
    
    self.selectedFirstString = self.firstDataArray[_selectedFirstIndex];
    self.selectedSecondString = self.secondDataArray[_selectedSecondIndex];
    
    if (self.block) {
        self.block(self.selectedFirstString, self.selectedSecondString);
    }
    
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray  = dataArray;
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        [provinceArray addObject:dict[@"first"]];
        if (i == 0) {
            self.secondDataArray = dict[@"second"];
        }
    }
    self.firstDataArray = provinceArray;
    
    _selectedFirstIndex = 0;
    _selectedSecondIndex = 0;
}

//- (void)setDictData:(NSDictionary *)dictData {
//    _dictData = dictData;
////    NSDictionary *cDict = dictData[self.secondKey];
////    NSMutableArray *dArray = [NSMutableArray array];
////    NSArray *keys = cDict.allKeys;
////    JSLogInfo(@"%@",keys);
////    self.firstDataArray = keys;
//
//    JSLogInfo(@"%@",dictData.allKeys);
//
//
////    self.firstDataArray = dictData[self.firstKey];
////    //  默认把第一个列第一个对应的第二列所有数据拿出来
////    self.secondDataArray = dictData[self.secondKey][self.firstDataArray.firstObject];
//

//}

@end
