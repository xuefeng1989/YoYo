//
//  KSMediaPickerHandlerCollectionView.h
//  KSMediaPickerDemo
//
//  Created by kinsun on 2019/9/13.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KSMediaPickerHandlerCollectionViewDelegate <NSObject, UIScrollViewDelegate, UICollectionViewDelegate>

@optional
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView;

@end

@interface KSMediaPickerHandlerCollectionView : UICollectionView

@property (nonatomic, weak) id<KSMediaPickerHandlerCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
