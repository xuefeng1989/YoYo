//
//  UploadImageUnAuthService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadImageUnAuthService : BaseRequestService
- (id)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
