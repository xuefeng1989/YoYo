//
//  AppDelegate+RefreshToken.m
//  Yoyo
//
//  Created by ning on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "AppDelegate+RefreshToken.h"

#import "Const.h"
#import "YoTool.h"
#import "RefreshTokenService.h"


@implementation AppDelegate (RefreshToken)

- (void)refreshTokens {
    if (!StringIsEmpty(YoUserDefault.token)) {
        RefreshTokenService *refreshApi = [[RefreshTokenService alloc] init];
        [refreshApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *userDict = [request.responseJSONObject objectForKey:@"result"];
                [YoTool saveUserInfo:userDict];
        } failure:^(JSError *error) {
            
        }];
    }
}

@end
