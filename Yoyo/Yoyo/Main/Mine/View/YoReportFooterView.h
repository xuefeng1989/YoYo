//
//  YoReportFooterView.h
//  Yoyo
//
//  Created by yunxin bai on 2019/7/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXPhotoPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoReportFooterView : UIView

@property(nonatomic, strong) HXPhotoView *photoView;
@property(nonatomic, strong) HXPhotoManager *manager;

@end

NS_ASSUME_NONNULL_END
