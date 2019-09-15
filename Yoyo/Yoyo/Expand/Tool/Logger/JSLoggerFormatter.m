//
//  JSLoggerFormatter.m
//  Master
//
//  Created by ningcol on 2017/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JSLoggerFormatter.h"

@implementation JSLoggerFormatter


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VBOSE]";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ [%@][line %ld] %@", logLevel, [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss.S" timestamp:logMessage.timestamp], logMessage.function, logMessage.line,logMessage.message];
    return formatStr;
}

- (NSString *)stringWithFormat:(NSString *)format timestamp:(NSDate *)date{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}
@end
