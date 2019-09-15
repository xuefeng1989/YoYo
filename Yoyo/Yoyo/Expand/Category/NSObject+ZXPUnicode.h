//
//  NSObject+ZXPUnicode.h
//  House
//  blog : http://blog.csdn.net/biggercoffee
//  github : https://github.com/biggercoffee/ZXPUnicode
//  Created by coffee on 15/9/28.
//  Copyright © 2015年 cylkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZXPUnicode)

+ (NSString *)stringByReplaceUnicode:(NSString *)string;

/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)isNullOrNilWithObject:(id)object;
@end
