//
//  NSDate+Extension.h
//  QiJi
//
//  Created by ningcol on 8/26/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;


/**
 通过NSdate比较当前时间

 @return 距离当前时间的描述
 */
- (NSString *)dateDescription;


/**
 把毫秒时间戳转为NSdate
 */
+ (NSDate *)dateFromLongLong:(long long)msSince1970;
@end
