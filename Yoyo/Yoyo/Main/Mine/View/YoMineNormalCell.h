//
//  YoMineNormalCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoMinePhotoOnce.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoMineNormalCellConfig : NSObject
@property (nonatomic, copy) NSString *titleImageString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *arrowImageString;
@property (nonatomic, copy) NSString *subTitleString;
@property (nonatomic, strong) UIColor *rightTitleColor;
@property (nonatomic, copy) NSString *subImageString;
@property (nonatomic, assign) BOOL hideArrowImage;
@property (nonatomic, assign) BOOL hideSeeContentView;
@property (nonatomic, strong) YoMinePhotoOnce *photoOnce;

- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString hideArrowImage:(BOOL)hideArrowImage;

- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString;


- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString subTitle:(NSString *)subTitleString;


- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString arrowImageString:(NSString *)rightImageString subTitle:(NSString *)rightTitle subTitleColor:(UIColor *)rightTitleColor subImageString:(NSString *)secondRightImageString hideArrowImage:(BOOL)hideArrowImage hideSeeContentView:(BOOL)hideSeeContentView;


@end

@interface YoMineNormalCell : UITableViewCell

@property (nonatomic, strong) YoMineNormalCellConfig *config;
@property (nonatomic, strong) NSDictionary *item;

- (void)setCornerRadius;
- (void)resetCornerRadius;

@end

NS_ASSUME_NONNULL_END
