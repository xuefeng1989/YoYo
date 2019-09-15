//
//  NSDictionary+Extension.h
//  QiJi
//
//  Created by ningcol on 23/02/2017.
//  Copyright © 2017 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)


/**
 json字符串转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
