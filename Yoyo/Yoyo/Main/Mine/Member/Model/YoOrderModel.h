//
//  YoOrderModel.h
//  Yoyo
//
//  Created by guzhichao on 2019/8/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoOrderItemRequestModel : NSObject
@property(nonatomic, retain)NSNumber *typeValue;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *desc;

+ (YoOrderItemRequestModel *)apple_Buy;
+ (YoOrderItemRequestModel *)vip_Buy;
+ (YoOrderItemRequestModel *)photo_Buy;
+ (YoOrderItemRequestModel *)connect_Buy;
@end




@interface YoOrderItemModel : NSObject
@property(nonatomic, retain)NSNumber *dictCode;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@end
@interface YoOrderModel : NSObject
@property (nonatomic,retain) YoOrderItemModel *content;
@property (nonatomic, copy) NSString *orderDescription;
@end

NS_ASSUME_NONNULL_END
