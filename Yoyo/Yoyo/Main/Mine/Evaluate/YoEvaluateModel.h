//
//  YoEvaluateModel.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoEvaluateModel : NSObject
@property (nonatomic,retain)NSNumber *count;
@property (nonatomic,retain)NSNumber *dictCode;
@property (nonatomic,copy)  NSString *dictValue;
@property (nonatomic,assign) BOOL isMySign;
@property (nonatomic,retain)NSNumber *signUser;
@property (nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
