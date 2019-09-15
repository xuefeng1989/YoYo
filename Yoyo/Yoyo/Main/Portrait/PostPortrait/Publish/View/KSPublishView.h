//
//  KSPublishView.h
//  
//
//  Created by kinsun on 2018/12/28.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSMediaPickerHandlerNavigationView;
@interface KSPublishView : UIView

@property (nonatomic, weak, readonly) UITextView *inputTextView;
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, weak, readonly) KSMediaPickerHandlerNavigationView *navigationView;
@property (nonatomic, weak, readonly) UIButton *publishButton;

@end

NS_ASSUME_NONNULL_END
