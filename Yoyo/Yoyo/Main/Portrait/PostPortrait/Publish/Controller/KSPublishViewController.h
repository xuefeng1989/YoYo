//
//  KSPublishViewController.h
//  
//
//  Created by kinsun on 2018/11/26.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSMediaPickerOutputModel;
@interface KSPublishViewController : UIViewController

@property (nonatomic, copy, readonly) NSArray <KSMediaPickerOutputModel *> *outputModelArray;

- (instancetype)initWithOutputModelArray:(NSArray <KSMediaPickerOutputModel *> * _Nullable)outputModelArray;

@end

NS_ASSUME_NONNULL_END
