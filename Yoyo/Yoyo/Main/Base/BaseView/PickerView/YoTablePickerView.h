//
//  YoTablePickerView.h
//  Yoyo
//
//  Created by ning on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectedTableBlock)(NSArray *selectedDataArray);
/// 单列tableView选择器，多选
@interface YoTablePickerView : UIView <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) selectedTableBlock block;
+ (instancetype)showDataArray:(NSArray *)array block:(selectedTableBlock)block;

- (void)show;
- (void)dismiss;

/// 初始化方法
- (void)initPickerView;
/// 点击确定按钮
- (void)didClickComfirmHandler;
/// 点击取消按钮
- (void)didClickCancelHandler;
@end

NS_ASSUME_NONNULL_END
