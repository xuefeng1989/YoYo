//
//  YoUploadManager.h
//  Yoyo
//
//  Created by yunxin bai on 2019/6/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YoUploadManagerSuccess)(NSDictionary * _Nullable success);
typedef void(^YoUploadManagerError)(NSString * _Nullable errorString);

NS_ASSUME_NONNULL_BEGIN

@interface YoUploadManager : NSObject
+(void)uploadWithFile:(NSArray *)files;
+(void)uploadWithFile:(NSArray *)files sueecss:(YoUploadManagerSuccess)success failure:(YoUploadManagerError)errorString;
@end

NS_ASSUME_NONNULL_END
