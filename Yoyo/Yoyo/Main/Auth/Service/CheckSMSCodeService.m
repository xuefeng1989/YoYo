//
//  CheckSMSCodeService.m
//  Yoyo
//
//  Created by ningcol on 2019/7/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "CheckSMSCodeService.h"

@implementation CheckSMSCodeService {
    NSString *_phone;
    NSString *_typeStr;
    NSString *_codeStr;
}

- (id)initWithPhone:(NSString *)phone sendType:(YoSendSMSType)type code:(nonnull NSString *)codeStr{
    self = [super init];
    if (self) {
        _phone = phone;
        _codeStr = codeStr;
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
    NSString *url = [NSString stringWithFormat:@"v1/sms/captcha/check"];
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    
    [self.params setValue:_typeStr forKey:@"smsType"];
    [self.params setValue:_phone forKey:@"mobile"];
    [self.params setValue:_codeStr forKey:@"captcha"];
    
    return self.params;
}


@end
