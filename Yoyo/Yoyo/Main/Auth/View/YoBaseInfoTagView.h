//
//  YoBaseInfoTagView.h
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YoBaseInfoTagView;
@protocol YoBaseInfoTagViewDelegate <NSObject>

- (void)YoBaseInfoTagView:(YoBaseInfoTagView *)view didSelectedTagArray:(NSArray *)array;

@end
@interface YoBaseInfoTagView : UIView
@property(nonatomic, weak) id<YoBaseInfoTagViewDelegate> delegate;
@property(nonatomic, strong) NSArray<NSString *> *dataArray;
/// 默认选中的数组
@property(nonatomic, strong) NSArray<NSString *> *selectedArr;


@end

NS_ASSUME_NONNULL_END
