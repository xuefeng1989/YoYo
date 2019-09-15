//
//  SMSCodeService.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "SMSCodeService.h"

@implementation SMSCodeService {
    NSString *_phone;
    NSString *_typeStr;
}

- (id)initWithPhone:(NSString *)phone sendType:(YoSendSMSType)type {
    self = [super init];
    if (self) {
        _phone = phone;
        switch (type) {
            case YoSendSMSTypeRegister:
                _typeStr = @"REG";
                break;
            case YoSendSMSTypeBanding:
                _typeStr = @"BINDPHONE";
                break;
            case YoSendSMSTypeOutBanding:
                _typeStr = @"UNBINDPHONE";
                break;
            case YoSendSMSTypeForget:
                _typeStr = @"FORGETPASSWORD";
                break;
        }
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"v1/sms/%@/%@",_typeStr, _phone];
    return url;
}



@end
