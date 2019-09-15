//
//  AuthService.h
//  Yoyo
//
//  Created by ningcol on 2019/7/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "BaseRequestService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthService : BaseRequestService
- (id)initWithAuthCode:(NSString *)code authPicUrl:(NSString *)picUrl;
@end

NS_ASSUME_NONNULL_END
