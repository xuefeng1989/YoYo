//
//  YoSinglePickerView.m
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoSinglePickerView.h"
#import "Const.h"
@interface YoSinglePickerView()
@property(nonatomic, copy) NSString *selectedTitle;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation YoSinglePickerView

+(instancetype)showDataArray:(NSArray *)array block:(selectedBlock)block {
    YoSinglePickerView *pick = [[YoSinglePickerView alloc] init];
    [pick setDataArray:array];
    [pick show];
    pick.block = block;
    return pick;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width;
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
//    label.backgroundColor = UIColorRed;
    label.text = self.dataArray[row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedTitle = self.dataArray[row];
    _selectedIndex = row;
}



- (void)didClickComfirmHandler {
    [super didClickComfirmHandler];
    if (self.block) {
        self.block(self.selectedTitle, _selectedIndex);
    }
    
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    _selectedTitle = dataArray.firstObject;
    _selectedIndex = 0;
}


@end
