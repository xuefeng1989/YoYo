//
//  KSPublishViewUploadModel.h
//  
//
//  Created by kinsun on 2018/12/28.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPublishViewUploadModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) NSNumber *width;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, assign) NSUInteger index;

@end

NS_ASSUME_NONNULL_END
