//
//  YoConfigVipModel.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoConfigVipItemModel : NSObject
@property(nonatomic, retain)NSNumber *coin;
@property(nonatomic, retain)NSNumber *day;
@end

@interface YoConfigVipModel : NSObject
@property(nonatomic, retain)NSNumber *dictCode;
@property(nonatomic, copy) NSString *dictLabel;
@property(nonatomic, retain)NSNumber *dictSort;
@property(nonatomic, retain)YoConfigVipItemModel *itemModel;
@property(nonatomic, copy) NSString *dictValue;
@end

NS_ASSUME_NONNULL_END

