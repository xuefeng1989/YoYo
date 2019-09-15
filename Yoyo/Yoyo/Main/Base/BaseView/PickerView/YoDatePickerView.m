//
//  YoDatePickerView.m
//  Yoyo
//
//  Created by ning on 2019/6/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoDatePickerView.h"

#import "Const.h"

@interface YoDatePickerView()
@property(nonatomic, assign) NSInteger yearCount;
@property(nonatomic, assign) NSInteger currentYear;
@property(nonatomic, assign) NSInteger currentMonth;
@property(nonatomic, assign) NSInteger currentDay;

@property(nonatomic, assign) NSInteger selectYear;
@property(nonatomic, assign) NSInteger selectMonth;
@property(nonatomic, assign) NSInteger selectDay;

@end

@implementation YoDatePickerView

+ (instancetype)showEndYear:(NSInteger)year block:(dateSelectedBlock)block{
    YoDatePickerView *pick = [[YoDatePickerView alloc] init];
    [pick initData:year + 1];
    [pick show];
    pick.block = block;
    return pick;
    
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearCount;
    }
    if (component == 1) {
        return 12;
    }
    return [self getDaysWithYear:self.selectYear month:self.selectMonth];
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return self.frame.size.width/3;
//}

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
        label.text = [NSString stringWithFormat:@"%ld年", row + self.currentYear];
    } else if (component == 1) {
        label.text = [NSString stringWithFormat:@"%ld月", row + 1];
    } else {
        label.text = [NSString stringWithFormat:@"%ld日", row + 1];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectYear = row + self.currentYear;
        // 重置月和日，让numberOfRowsInComponent计算天数（因为天数不相等，重置可以去掉选择31天，再选择28天的月份导致日期错乱的问题）
        self.selectMonth = 0 + 1;
        self.selectDay = 0 + 1;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 1) {
        self.selectMonth = row + 1;
        self.selectDay = 0 + 1;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 2) {
        self.selectDay = row + 1;
        [pickerView reloadComponent:2];
    }
    

}

- (void)didClickComfirmHandler {
    [super didClickComfirmHandler];

    if (self.block) {
        self.block(self.selectYear, self.selectMonth, self.selectDay);
    }
    
}

- (void)initData:(NSInteger)endYear {
    NSDate *currentDate = [NSDate date];//当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];//当前用户的calendar
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay fromDate:currentDate];
//    JSLogInfo(@"%ld-%ld-%ld  %ld:%ld:%ld",components.year, components.month, components.day, components.hour, components.minute, components.second);
    
    self.yearCount = endYear - components.year;
    if (endYear <= components.year) {
        self.yearCount = 1;
    }
    
    if (endYear == 0) {
        self.yearCount = 2;
    }
    
    self.currentYear = components.year;
    self.currentMonth = components.month;
    self.currentDay = components.day;
    
    self.selectYear = components.year;
    self.selectMonth = components.month;
    self.selectDay = components.day;
    
    
    [self.pickerView selectRow:self.currentYear-1 inComponent:0 animated:YES];
    [self.pickerView selectRow:self.currentMonth-1 inComponent:1 animated:YES];
    [self.pickerView selectRow:self.currentDay-1 inComponent:2 animated:YES];


}


#pragma mark - tool
- (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month {
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            if (year%400==0 || (year%100!=0 && year%4 == 0)) {
                return 29;
            }else{
                return 28;
            }
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}
@end
