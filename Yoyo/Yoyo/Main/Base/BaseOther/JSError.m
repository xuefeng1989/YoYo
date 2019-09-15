//
//  JSError.m
//  Master
//
//  Created by ningcol on 2017/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JSError.h"



@implementation JSError {
    JSErrorCode _code;
    NSString *_errorDescription;
}

- (instancetype)initWithDescription:(NSString *)aDescription code:(JSErrorCode)aCode {
    self = [super init];
    if (self) {
        _errorDescription = aDescription;
        _code = aCode;
    }
    return self;
}



+ (instancetype)errorWithDescription:(NSString *)aDescription code:(JSErrorCode)aCode {
    JSError *error = [[JSError alloc] initWithDescription:aDescription code:aCode];
    return error;
}


- (NSString *)errorDescription {
    return _errorDescription;
}

- (JSErrorCode)code {
    return _code;
}


- (NSString *)description{
    return [NSString stringWithFormat:@"JSError:code:%ld,Description:%@", _code,_errorDescription];
}


@end
