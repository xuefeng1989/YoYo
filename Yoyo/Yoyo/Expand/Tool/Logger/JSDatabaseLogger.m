//
//  QJDatabaseLogger.m
//  Master
//
//  Created by ningcol on 2017/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JSDatabaseLogger.h"
#import "AppDelegate.h"

#define LogCacheCapacity        2000

@interface JSDatabaseLogger()
@property (nonatomic, strong) NSMutableArray *logs;
@end
@implementation JSDatabaseLogger


// 生命周期函数
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logs = [NSMutableArray array];
        // 使用默认的配置。达到500条或者间隔1分钟就保存；磁盘数据库保留7天，删除操作间隔5分钟，这两个数据不关心，用基类的就可以了
        self.saveThreshold = 500; // 达到500条就保存传后台
        self.saveInterval = 60;   // 60s定时到就保存传后台
        // 监听UIApplicationWillResignActiveNotification消息，在程序进入后台前保存log
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
        
     }
    return self;
}

// 重写父类函数
- (BOOL)db_log:(DDLogMessage *)logMessage {
    // _logFormatter只能用下划线变量访问，不能用self的方式，否则会触发断言
    if (!_logFormatter) {
        //没有指定 formatter
        return NO;
    }
    
    if ([self.logs count] > LogCacheCapacity) {
        // 如果段时间内进入大量log，并且迟迟发不到服务器上，我们可以判断哪里出了问题，在这之后的 log 暂时不处理了。
        // 但我们依然要告诉 DDLog 这个存进去了。
        return YES;
    }
    //利用 formatter 得到消息字符串，添加到缓存
    @synchronized (self) {
        // _logFormatter只能用下划线变量访问，不能用self的方式，否则会触发断言
        [self.logs addObject:[_logFormatter formatLogMessage:logMessage]];
    }
    
    return YES;
}

- (void)db_save {
    //如果缓存内没数据，啥也不做
    if (0 == [self.logs count]) {
        return;
    }
    
    // 用换行符，把所有的数据拼成一个大字符串
    NSString *logsString = [self.logs componentsJoinedByString:@"\n"];
    // 发送给服务器，将AFNetworking包一层作为网络传输
    NSString *url = @"";  // 根据实际修改
    NSDictionary *logs = @{@"log": logsString}; // key值跟后台商量好
    __weak __typeof(self) weakSelf = self;
//    [[MyAFNetWorking shareAfnetworking] performRequestWithPath:url formDataDic:logs success:^(NSDictionary *responseObject) {
//        // 已经成功传到服务器，之后将缓存清空
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf clearLogs];
//    } failure:^(NSDictionary *responseObject) {
//        // 啥也不做
//    }];
}

// selector
- (void)onWillResignActive:(NSNotification *)notification {
    dispatch_async(self.loggerQueue, ^{
        [self db_save];
    });
}

// 清空缓存
- (void)clearLogs {
    @synchronized (self) {
        [self.logs removeAllObjects];
    }
}


@end
