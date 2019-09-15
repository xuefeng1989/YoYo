//
//  GCDSocketManager.h
//  QJ
//
//  Created by ningcol on 2017/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


@protocol GCDSocketManagerDelegate <NSObject>

-(void)GCDSocketManagerReceivedMessage:(NSString *)message;

@end

@interface GCDSocketManager : NSObject

@property(nonatomic,strong) GCDAsyncSocket *socket;

@property (nonatomic, assign) id<GCDSocketManagerDelegate> delegate;


//单例
+ (instancetype)sharedSocketManager;

//连接
- (void)connectToServer;

//断开
- (void)cutOffSocket;


@end
