//
//  BaseService.m
//  MobileProject
//
//  Created by wujunyang on 16/7/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "BaseRequestService.h"
#import "Const.h"
#import "JSTool.h"
#import "KeyChainStore.h"

#import "YoIndexViewController.h"
#import "YoCommonNavigationController.h"

@implementation BaseRequestService


/// 公共头部设置
- (NSDictionary *)requestHeaderFieldValueDictionary{
    if (StringIsEmpty(YoUserDefault.token)) {
        YoUserDefault.token = @"";
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[UIDevice currentDevice] systemVersion] forKey:@"sys_version"];
    [dict setValue:appVersion forKey:@"app_version"];
    [dict setValue:[JSTool getDeviceName] forKey:@"model"];
    NSString *lat = [NSString stringWithFormat:@"%lf", YoUserDefault.latitude];
    NSString *lng = [NSString stringWithFormat:@"%lf", YoUserDefault.longitude];
    [dict setValue:lat  forKey:@"lat"];
    [dict setValue:lng forKey:@"lon"];
    [dict setValue:YoUserDefault.city forKey:@"city_name"];
    [dict setValue:[KeyChainStore getUUID] forKey:@"device_id"];
    NSString *loginData = [dict mj_JSONString];
    
    NSString *auth = [NSString stringWithFormat:@"%@", YoUserDefault.token];
    NSDictionary *headerDictionary=@{@"platform": @"ios",
                                     @"Authorization": auth,
                                     @"login-data": loginData,
                                     };
    return headerDictionary;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

- (id)requestArgument {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//
//    [_params setValue:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
//    [_params setValue:appVersion forKey:@"appVersion"];
//    [_params setValue:[JSTool getDeviceName] forKey:@"model"];
//    [_params setValue:[KeyChainStore getUUID] forKey:@"serialNumber"];

    return _params;
}


- (void)js_startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success
                                       failure:(JSNetRequestFailedBlock)failure {
    [super startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        JSLogInfo(@"request:%@",request);
        JSLogInfo(@"requestToken:%@",YoUserDefault.token);
        JSLogInfo(@"responseJSONObject:%@",request.responseJSONObject);
        NSInteger resCode = [[request.responseJSONObject objectForKey:@"status"] integerValue];
        NSString *msg = [request.responseJSONObject objectForKey:@"message"];
        if (200 <= resCode && resCode <= 299) {
            success(request);
        } else {
//            if (resCode == 100007 || resCode == 100008) {  // token过期或者错误需要登录
//                LGLoginViewController *loginVc = [[LGLoginViewController alloc] init];
//                LGNavigationController *navVc = [[LGNavigationController alloc] initWithRootViewController:loginVc];
//                [[QMUIHelper visibleViewController] presentViewController:navVc animated:YES completion:nil];
//                [QMUITips showError:JSLocalizedString(@"Toast_label_tokensOutDate") inView:loginVc.view hideAfterDelay:1.5];
//                // 这里还要返回错误信息，否则刷新不回停止
//                JSError *error = [JSError errorWithDescription:JSLocalizedString(@"Toast_label_tokensOutDate") code:resCode];
//                failure(error);
//            } else {
                JSError *error = [JSError errorWithDescription:msg code:resCode];
                failure(error);
//            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        JSLogInfo(@"--------请求报错--------request:%@",request);
        JSLogInfo(@"--------requestToken--------:%@",YoUserDefault.token);
        JSLogInfo(@"--------responseJSONObject----------:%@,request.responseStatusCode:%ld",request.responseJSONObject, request.responseStatusCode);
        JSError *error = [JSError errorWithDescription:@"网络连接失败" code:request.responseStatusCode];
        if (request.responseStatusCode == 401) { // token过期或者错误需要登录
            YoIndexViewController *loginVc = [[YoIndexViewController alloc] init];
            YoCommonNavigationController *navVc = [[YoCommonNavigationController alloc] initWithRootViewController:loginVc];
            [[QMUIHelper visibleViewController] presentViewController:navVc animated:YES completion:nil];
            return ;
        }
        if (request.responseStatusCode != 0) {
           NSString *msg = [request.responseJSONObject objectForKey:@"message"];
           error = [JSError errorWithDescription:msg code:request.responseStatusCode];
        }
        
        failure(error);
    }];
    
}



@end
