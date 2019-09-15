//
//  YoMinePhotoPickerView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YoMinePhotoPickerViewDeleteBlock)(void);
typedef void(^YoMinePhotoPickerViewCommitBlock)(NSInteger index);

@interface YoMinePhotoPickerView : UIView

@property (nonatomic, copy) YoMinePhotoPickerViewDeleteBlock deleteBlock;
@property (nonatomic, copy) YoMinePhotoPickerViewCommitBlock commitBlock;
- (void)setSelectIndex:(NSInteger) selectIndex;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
