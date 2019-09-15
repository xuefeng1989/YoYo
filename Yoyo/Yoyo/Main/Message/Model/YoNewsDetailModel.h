//
//  YoNewsDetailModel.h
//  Yoyo
//
//  Created by ning on 2019/6/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YoNewsType){
    YoNewsTypeSystem   = 0,
    YoNewsTypeAppointment,
    YoNewsTypePortrait,
    YoNewsTypeReward,
    YoNewsTypeWallet,
    YoNewsTypeEvaluate
};


@interface YoNewsDetailModel : NSObject
@property(nonatomic, assign) YoNewsType type;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *pic;

@end

NS_ASSUME_NONNULL_END
