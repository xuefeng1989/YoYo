//
//  PHPublishViewPictureCell.h
//  
//
//  Created by kinsun on 2018/12/28.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSMediaPickerOutputModel;
@interface KSPublishViewPictureCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIButton *removeButton;

@property (nonatomic, copy) void (^didClickRemoveButtonCallback)(KSPublishViewPictureCell *cell);

@property (nonatomic, strong) KSMediaPickerOutputModel *model;

@property (nonatomic, readonly) CGRect imageViewFrameInSuperView;

@end

NS_ASSUME_NONNULL_END
