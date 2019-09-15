//
//  CreateOrderService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "CreateOrderService.h"

@implementation CreateOrderService  {
    YoCreateOrderType _type;
    NSString *_contentStr;
    double _money;
    NSInteger _userNo;
    
}

- (instancetype)initWithOrderType:(YoCreateOrderType)type contentJsonString:(NSString *)contentStr totalMoney:(double)money userNo:(NSInteger)userNo;
{
    self = [super init];
    if (self) {
        _type = type;
        _contentStr = contentStr;
        _money = money;
        _userNo = userNo;
    }
    return self;
}



- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/order/create"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:[NSNumber numberWithInteger:_type] forKey:@"orderType"];
    [self.params setValue:_contentStr forKey:@"content"];
    [self.params setValue:[NSNumber numberWithInteger:1] forKey:@"source"];
    [self.params setValue:[NSNumber numberWithDouble:_money] forKey:@"totalMoney"];
    [self.params setValue:[NSNumber numberWithInteger:_userNo] forKey:@"userNo"];

    return self.params;
}


@end
