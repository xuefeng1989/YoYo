//
//  YoOtherHeaderView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/18.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "YoMineUploadCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@interface YoOtherHeaderViewModel : NSObject

@property (nonatomic, assign) YoMineUploadCollectionViewCellType imageType;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *imageUrl;

- (instancetype)initWithType:(YoMineUploadCollectionViewCellType)type photo:(UIImage *)photo imageUrl:(NSString *)imageUrl;

@end

@class YoOtherHeaderView;

@protocol YoOtherHeaderViewDelegate <NSObject>

@optional
- (void)otherHeaderView:(YoOtherHeaderView *)view didClickedIndex:(NSInteger)index;

@end

@interface YoOtherHeaderView : UIView

@property (nonatomic, strong) QMUIButton *backButton;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id<YoOtherHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
