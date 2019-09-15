//
//  YoTwoRowPickerView.h
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBasePickerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^twoRowselectedBlock)(NSString *firstRowString, NSString *secondRowString);
/// 两列联动选择器
@interface YoTwoRowPickerView : YoBasePickerView
@property(nonatomic, copy) twoRowselectedBlock block;
+ (instancetype)showDataArray:(NSArray *)array block:(twoRowselectedBlock)block;
@end


///  !!!!!!!!!用法
/*
NSArray *array = @[@{@"first": @"A",@"second" : @[@36,@37,@38,@39]},
                   @{@"first": @"B",@"second" : @[@27,@28,@29,@30]},
                   @{@"first": @"C",@"second" : @[@67,@68,@69,@70]}
                   ];
[YoTwoRowPickerView showDataArray:array block:^(NSString * _Nonnull firstRowString, NSString * _Nonnull secondRowString) {
    JSLogInfo(@"YoTwoRowPickerView: %@ - %@",firstRowString, secondRowString);
    label.text = [NSString stringWithFormat:@"%@-%@",firstRowString,secondRowString];
}];
*/

NS_ASSUME_NONNULL_END
