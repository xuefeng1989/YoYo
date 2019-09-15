//
//  YoOtherTableViewCell.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoOtherTableViewCellConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rightImageString;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, strong) UIColor *rightTitleColor;
@property (nonatomic, assign) BOOL hideRightImage;

- (instancetype)initWithTitle:(NSString *)title rightImageString:(NSString *)rightImageString rightTitle:(NSString *)rightTitle rightTitleColor:(UIColor *)rightTitleColor hideRightImage:(BOOL)hideRightImage;

@end

@interface YoOtherTableViewCell : UITableViewCell

@property (nonatomic, strong) YoOtherTableViewCellConfig *config;

@end

NS_ASSUME_NONNULL_END
