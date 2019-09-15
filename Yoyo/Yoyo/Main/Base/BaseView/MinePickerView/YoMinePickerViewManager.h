//
//  YoMinePickerViewManager.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YoMinePickerViewManagerBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface YoMinePickerViewManager : NSObject

+ (instancetype)manager;

- (void)show;

- (void)hide;


@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, copy) YoMinePickerViewManagerBlock block;
@end

NS_ASSUME_NONNULL_END
