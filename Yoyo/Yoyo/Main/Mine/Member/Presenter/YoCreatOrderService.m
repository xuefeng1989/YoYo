//
//  YoCreatOrderService.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/28.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCreatOrderService.h"

@implementation YoCreatOrderService
- (NSString *)requestUrl {
    if (self.requestType == YoCreatOrderServiceOrderCreate) {
        NSString *url = [NSString stringWithFormat:@"v1/order/create"];
        return url;
    }else if (self.requestType == YoCreatOrderServiceOrderSubmit){
        NSString *url = [NSString stringWithFormat:@"v1/order/submit"];
        return url;
    }else{
        NSString *url = [NSString stringWithFormat:@"v1/order/verify"];
        return url;
    }
    
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
@end
