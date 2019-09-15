//
//  NSString+Extension.m
//  QiJi
//
//  Created by ningcol on 8/1/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  计算文字尺寸
 *
 */
- (CGSize)sizeWithFont:(CGFloat)fontSize maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}



- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    return initial;
}



+ (NSString *)getRandomUUIDString{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    return [uuid lowercaseString];
}

+ (NSString *)getCurrentTimestamp{
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *dateTime = [NSString stringWithFormat:@"%0.f",interval];
    return dateTime;
    
}






+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary{
    NSString *jsonStr = @"{";
    NSArray * keys = [dictionary allKeys];
    
    for (NSString * key in keys) {
        jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
        
    }
    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
    
    return jsonStr;
    
}


@end
