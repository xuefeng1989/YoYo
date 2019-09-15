//
//  JSError.h
//  Master
//
//  Created by ningcol on 2017/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JSErrorCode) {
    JSErrorGeneral = 1,                      /*! \~chinese 一般错误 \~english General error */
    JSErrorNetworkUnavailable,               /*! \~chinese 网络不可用 \~english Network is unavaliable */
    JSErrorDatabaseOperationFailed,          /*! \~chinese 数据库操作失败 \~english Database operation failed */
    
    JSErrorServerNotReachable = 300,         /*! \~chinese 服务器未连接 \~english Server is not reachable */
    JSErrorServerTimeout,                    /*! \~chinese 服务器超时 \~english Server response timeout */
    JSErrorServerBusy,                       /*! \~chinese 服务器忙碌 \~english Server is busy */
    JSErrorServerUnknownError,               /*! \~chinese 未知服务器错误 \~english Unknown server error */
    JSErrorServerGetDNSConfigFailed,         /*! \~chinese 获取DNS设置失败 \~english Get DNS config failed */
    JSErrorServerServingForbidden,           /*! \~chinese 服务被禁用 \~english Service is forbidden */
    
    JSErrorJSONFormmat  = 400,                 /*! \~chinese JSON格式错误 \~english Service is forbidden */
    
    JSErrorTokensError = 100007,       /*! \~chinese tokens错误 \~english Service is forbidden */
    JSErrorTokensTimeout = 100008      /*! \~chinese tokens过期 \~english Service is forbidden */
    
};


@interface JSError : NSObject
/*!
 *  \~chinese
 *  错误码
 *
 *  \~english
 *  Error code
 */
@property (nonatomic, readonly) JSErrorCode code;

/*!
 *  \~chinese
 *  错误描述
 *
 *  \~english
 *  Error description
 */
@property (nonatomic, copy, readonly) NSString *errorDescription;



- (instancetype)initWithDescription:(NSString *)aDescription
                               code:(JSErrorCode)aCode;



+ (instancetype)errorWithDescription:(NSString *)aDescription
                                code:(JSErrorCode)aCode;

@end
