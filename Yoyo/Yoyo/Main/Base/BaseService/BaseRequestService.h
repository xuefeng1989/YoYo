//
//  BaseService.h
//  MobileProject 继承于YTKBaseRequest 可以处理一些共同的事情
//
//  Created by wujunyang on 16/7/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork.h>
#import "JSError.h"

@class JSError;
typedef void(^JSNetRequestFailedBlock)(JSError *error);
typedef NS_ENUM(NSUInteger, BaseRequestHandlerType) {
    BaseRequestHandlerTypeAdd = 0,
    BaseRequestHandlerTypeRemove,
    BaseRequestHandlerTypePOST,
    BaseRequestHandlerTypeGET,
};

@interface BaseRequestService : YTKRequest
/// post请求参数
@property(nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic,assign)BaseRequestHandlerType handlerType;
- (void)js_startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success
                                       failure:(JSNetRequestFailedBlock)failure;

@end
