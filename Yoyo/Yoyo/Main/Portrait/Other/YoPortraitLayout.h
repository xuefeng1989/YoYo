//
//  YoProtraitLayout.h
//  Yoyo
//
//  Created by yunxin bai on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YoPortraitLayout;

@protocol YoPortraitLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(YoPortraitLayout *)waterFlowLayout heigthForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(YoPortraitLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(YoPortraitLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(YoPortraitLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YoPortraitLayout *)waterflowLayout;

@end

@interface YoPortraitLayout : UICollectionViewLayout
@property(nonatomic,weak) id<YoPortraitLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
