//
//  YoBlacklistModel.h
//  Yoyo
//
//  Created by ningcol on 2019/7/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoBlacklistModel : NSObject
/**
 头像
 */
@property(nonatomic, copy) NSString *avatar;

/**
 昵称
 */
@property(nonatomic, copy) NSString *userName;

/**
 用户id
 */
@property(nonatomic, assign) NSInteger userNo;


@end

NS_ASSUME_NONNULL_END
