//
//  NSString+RegularExpression.m
//  JianGuo
//
//  Created by ningcol on 12/4/15.
//  Copyright © 2015 ningcol. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

/**
 *  手机号
 */
- (BOOL)isValidNumber{
    NSString *number = @"(13\\d|14[57]|15[^4,\\D]||166\\d{8}|17[678]|18\\d)\\d{8}||199\\d{8}|170[059]\\d{7}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [predicate evaluateWithObject:self];
}
/**
 *  邮箱
 */
- (BOOL)isValidEmail{
    NSString *email = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",email];
    return [predicate evaluateWithObject:self];
}
/**
 *  注册密码（第一个位必须为英文）
 */
- (BOOL)isValidPwd{
    if (self.length <8) {
        return NO;
    }
    NSString *hha = @"^[A-Za-z]([\\w_]*){1,8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",hha];
    return [predicate evaluateWithObject:self];
}
/**
 *  身份证
 */
- (BOOL)isValidIdentityCard{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *IDCard = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDCard];
    return [predicate evaluateWithObject:self];
}

/**
 *  真实姓名
 */
- (BOOL)isValidRealName{
    NSString *email = @"[\u4e00-\u9fa5]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",email];
    return [predicate evaluateWithObject:self];
}

/**
  *  手机验证码
  */
- (BOOL)isValidVerificationCode{
    NSString *email = @"^\\d{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",email];
    return [predicate evaluateWithObject:self];
}



@end
