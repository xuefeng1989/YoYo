//
//  MyFileLogger.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MyFileLogger.h"

@implementation MyFileLogger

#pragma mark - Inititlization
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureLogging];
    }
    return self;
}

#pragma mark 单例模式
static MyFileLogger *sharedManager=nil;

+(MyFileLogger *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager=[[self alloc]init];
    });
    return sharedManager;
}


#pragma mark - Configuration

- (void)configureLogging{
    
    //设置输出的LOG样式
    JSLoggerFormatter *formatter = [[JSLoggerFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];

    // 添加DDTTYLogger，你的日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //添加文件输出
    [self.fileLogger setLogFormatter:formatter];
    [DDLog addLogger:self.fileLogger];
    
    //添加数据库输出,并上传
    JSDatabaseLogger *dateBaseLogger = [[JSDatabaseLogger alloc] init];
    [dateBaseLogger setLogFormatter:formatter];
    [DDLog addLogger:dateBaseLogger];
    
    
}

/**
 * 获得系统日志的路径
 **/
-(NSArray*)getLogPath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * logPath = [docPath stringByAppendingPathComponent:@"Caches"];
    logPath = [logPath stringByAppendingPathComponent:@"Logs"];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * fileList = [[NSArray alloc]init];
    fileList = [fileManger contentsOfDirectoryAtPath:logPath error:&error];
    NSMutableArray * listArray = [[NSMutableArray alloc]init];
    for (NSString * oneLogPath in fileList)
    {
        //带有工程名前缀的路径才是我们存储的日志路径
        if([oneLogPath hasPrefix:[NSBundle mainBundle].bundleIdentifier])
        {
            NSString * truePath = [logPath stringByAppendingPathComponent:oneLogPath];
            [listArray addObject:truePath];
        }
    }
    return listArray;
}


//拿到log日志以及日志路径
/*
DDFileLogger *file = [MyFileLogger sharedManager].fileLogger;

DDLogFileInfo *logFileInfo = file.currentLogFileInfo;
NSData *logData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
NSString *logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
NSLog(@"------:%@",logText);

NSArray *arr = [[MyFileLogger sharedManager] getLogPath];
NSLog(@"arr:%@",arr);
 */



#pragma mark - Getters
- (DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        
        _fileLogger = fileLogger;
    }
    
    return _fileLogger;
}
@end
