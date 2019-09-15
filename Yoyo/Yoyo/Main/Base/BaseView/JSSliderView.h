//
//  JSSliderView.h
//  Master
//
//  Created by ningcol on 2017/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSSliderView;
/**
 代理方法用于初始化界面（模仿UITableViewDataSource）和实现刷新的操作
 */
@protocol JSSliderViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInJSSliderView:(JSSliderView *)sliderView;

- (UIView *)JSSliderView:(JSSliderView *)sliderView viewForItemAtIndex:(NSInteger)index;

/**
 JSSliderView代理
 @return 未选中的图片名，选中的为 "***_select"，内部自动添加了
 */
- (NSString *)JSSliderView:(JSSliderView *)sliderView imageStrForItemAtIndex:(NSInteger)index;

@optional
/**
 初始化的位置
 
 @param sliderView 当前sliderView
 @return 初始化显示的位置
 */
- (NSInteger)initialzeIndexOfJSSliderView:(JSSliderView *)sliderView;


- (void)JSSliderView:(JSSliderView *)sliderView didSelectItemAtIndex:(NSInteger)index;


@end

@interface JSSliderView : UIView

@property (nonatomic, weak) id<JSSliderViewDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, assign) BOOL scrollEnabled;

@property (nonatomic, strong) UIColor *themeColor;


- (void)reloadData;
@end
