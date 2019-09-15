//
//  MyFileLogger.h
//  MobileProject  日志记录
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"
#import "JSLoggerFormatter.h"
#import "JSDatabaseLogger.h"

#define JSLogError(frmt, ...)      DDLogError(frmt, ##__VA_ARGS__)
#define JSLogWarning(frmt, ...)    DDLogWarn(frmt, ##__VA_ARGS__)
#define JSLogInfo(frmt, ...)       DDLogInfo(frmt, ##__VA_ARGS__)
#define JSLogDebug(frmt, ...)      DDLogDebug(frmt, ##__VA_ARGS__)
#define JSLogVerbose(frmt, ...)    DDLogVerbose(frmt, ##__VA_ARGS__)

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif



@interface MyFileLogger : NSObject
@property (nonatomic, strong, readwrite) DDFileLogger *fileLogger;

+(MyFileLogger *)sharedManager;

-(NSArray*)getLogPath;

@end

