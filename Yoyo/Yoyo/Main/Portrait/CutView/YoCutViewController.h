//
//  YoCutViewController.h
//  Yoyo
//
//  Created by guzhichao on 2019/9/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 图片裁剪
 */
@class YoCutViewController;

@protocol  YoImageCutViewControllerDelegate <NSObject>
/**
 裁剪完成
 @param controller controller
 @param editImage  裁剪完的图片
 */
- (void)imageCutViewController:(YoCutViewController*)controller finishedEidtImage:(UIImage*)editImage;
/**
 取消裁剪
 @param controller controller
 */
- (void)imageCutViewControllerDidCancel:(YoCutViewController*)controller;

- (void)imageCutViewControllerDidChangeFrame:(CGRect)cutframe andIndex:(NSInteger)index;

@end
@interface YoCutViewController : UIViewController
@property (nonatomic, strong) UIColor *cutBorderColor;//边框颜色
@property (nonatomic, assign) CGRect cutFrame;//边框位置
@property (nonatomic, assign) NSInteger cutIndex;
@property (nonatomic, assign) CGFloat maxScale;//最大缩放比例
@property (nonatomic, strong) UIImage *originalImage;//原图像
@property (nonatomic, assign) CGFloat cutBorderWidth;//边框宽度
@property (nonatomic, strong) UIColor *cutCoverColor;//周围覆盖层颜色
@property (nonatomic, weak) id<YoImageCutViewControllerDelegate> delegate;
- (void)confirmAction;
@end

NS_ASSUME_NONNULL_END
