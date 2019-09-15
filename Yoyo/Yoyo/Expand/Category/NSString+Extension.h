//
//  NSString+Extension.h
//  QiJi
//
//  Created by ningcol on 8/1/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)


/**
 *  返回字符串所占用的尺寸
 *
 *  @param fontSize  字体大小
 *  @param maxW      最大宽度
 */
- (CGSize)sizeWithFont:(CGFloat)fontSize maxW:(CGFloat)maxW;


- (NSString *)pinyin;
- (NSString *)pinyinInitial;

// baseTool
+ (NSString *)getRandomUUIDString;
+ (NSString *)getCurrentTimestamp;



/**
 字典转json字符串
 */
+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary;








@end
