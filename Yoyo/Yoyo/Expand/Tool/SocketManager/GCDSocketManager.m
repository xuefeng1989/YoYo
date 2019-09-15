//
//  GCDSocketManager.m
//  QJ
//
//  Created by ningcol on 2017/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "GCDSocketManager.h"
#import "NSData+gzip.h"

#import "Const.h"

//#import "QJUserEntityManager.h"

#define SocketHost @"120.55.119.228"
#define SocketPort 9210


@interface GCDSocketManager()<GCDAsyncSocketDelegate>

//握手次数
@property(nonatomic,assign) NSInteger pushCount;
//断开重连定时器
@property(nonatomic,strong) NSTimer *timer;
//重连次数
@property(nonatomic,assign) NSInteger reconnectCount;

@property (strong, nonatomic) NSMutableData *buffer;            // 接收缓冲区


@end

@implementation GCDSocketManager

//全局访问点
+ (instancetype)sharedSocketManager {
    static GCDSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//可以在这里做一些初始化操作
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buffer = [[NSMutableData alloc] init];
        [self.buffer setLength:0];
    }
    return self;
}

#pragma mark 请求连接
//连接
- (void)connectToServer {
    self.pushCount = 0;
    
//    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 10)];
     self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    
    if (error) {
        JSLogError(@"SocketConnectError:%@",error);
    }
}

#pragma mark 连接成功
//连接成功的回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    JSLogInfo(@"socket连接成功");
    [self sendDataToServer];
}

//连接成功后向服务器发送数据
- (void)sendDataToServer {
    // 把json字符串按格式转位data
    
//    NSString *jsonStr = [NSString stringWithFormat:@"{\"action\":\"reportUserTag\",\"userTag\":\"%@\"}",[[QJUserEntityManager sharedInstance] getCurUserProfile].userTag];
    NSString *jsonStr = [NSString stringWithFormat:@"{\"action\":\"reportUserTag\",\"userTag\":\"%@\"}",@""];

    
    NSData *sendData = [self parseSendJSONString:jsonStr];
    //发送
    [self.socket writeData:sendData withTimeout:-1 tag:1];
    
    //读取数据
    [self.socket readDataWithTimeout:-1 tag:200];
}

//连接成功向服务器发送数据后,服务器会有响应
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    [_buffer appendData:data];
    
    while (_buffer.length >= 4) {
        Byte *resverByte = (Byte *)[_buffer bytes];
        Byte jsonlenByte[] = {resverByte[0],resverByte[1],resverByte[2],resverByte[3]};
        NSInteger length = [self toInt:jsonlenByte];    // 读取长度
        
        NSUInteger packageLength = 4 + length;  //算出一个包完整的长度(内容长度＋头长度)
        if (packageLength <= _buffer.length) {     // 长度判断 如果缓存中数据够一个整包的长度
            NSData *rootData = [_buffer subdataWithRange:NSMakeRange(4, length)]; //截取一个包的长度(处理粘包)
            //处理包数据
            [self handleRootData:rootData];

            // 从缓存中截掉处理完的数据,继续循环
            NSData *tmp = [_buffer subdataWithRange:NSMakeRange(packageLength, _buffer.length - packageLength)];
            [_buffer setLength:0];      // 清零
            [_buffer appendData:tmp];
        } else {
            break;
        }
    }
    
    [self.socket readDataWithTimeout:-1 tag:200];       // 设置下次接收数据的时间, tag
    
    //服务器推送次数
    self.pushCount++;
}

#pragma mark 连接失败
//连接失败的回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    JSLogError(@"Socket连接失败");
    
    self.pushCount = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentStatu = [userDefaults valueForKey:@"Statu"];
    
    //程序在前台才进行重连
//    if ([currentStatu isEqualToString:@"foreground"]&&[[QJUserEntityManager sharedInstance] getCurUserProfile].userTag) {
    if ([currentStatu isEqualToString:@"foreground"]) {

        
        //重连次数
        self.reconnectCount++;
        
        //如果连接失败 累加1秒重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 * self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        
        self.timer = timer;
    }
}

//如果连接失败,5秒后重新连接
- (void)reconnectServer {
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    //连接失败重新连接
    NSError *error = nil;
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    if (error) {
        JSLogError(@"SocektConnectError:%@",error);
    }
}

#pragma mark 断开连接
//切断连接
- (void)cutOffSocket {
    JSLogError(@"socket断开连接");
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.socket disconnect];
}

#pragma mark - tool
-(int)toInt:(Byte[]) byte
{
    int repLength = 0;
    
    for (int i = 0; i < 4; i++) {
        repLength += (byte[i] & 0xFF) << (8 * (3 - i));
    }
    
    return repLength;
}

-(int)charNumber:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

-(NSData *)parseSendJSONString:(NSString *)jsonString{
    
    NSMutableData* sendData =[NSMutableData data];

    int dataLength = [self charNumber:jsonString];
    // int转byte数组
    Byte lengthByte[4] = {0};
    for (int i = 0; i < 4; i++) {
        lengthByte[i] = (Byte)(dataLength >> 8 * (3 - i) & 0xFF);
    }
    [sendData appendBytes:lengthByte length:sizeof(lengthByte)];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [sendData appendData:data];
    
    return sendData;
}


-(void)handleRootData:(NSData *)data{
    NSString *comstring = [[NSString alloc] initWithData:[data ungzipData]  encoding:NSUTF8StringEncoding];
//    JSLogInfo(@"收到的消息:%@",comstring);
    if ([comstring isEqualToString:@"serverPing"]) {
        NSData *sendData = [self parseSendJSONString:@"clientPing"];
        [self.socket writeData:sendData withTimeout:-1 tag:1];
    }else{
        if ([self.delegate respondsToSelector:@selector(GCDSocketManagerReceivedMessage:)]) {
            [self.delegate GCDSocketManagerReceivedMessage:comstring];
        }
    }
    
}





@end
