//
//  YoDataItem.h
//  Yoyo
//
//  Created by yunxin bai on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YoDataItem : NSObject

@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gap;
@property (nonatomic, assign) BOOL care;
@property (nonatomic, assign) NSInteger totalHot;
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger totalBit;
@property (nonatomic, copy) NSString *datingStatus;
@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
