//
//  NSString+RegularExpression.h
//  JianGuo
//
//  Created by ningcol on 12/4/15.
//  Copyright © 2015 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)


- (BOOL)isValidNumber;
- (BOOL)isValidEmail;
- (BOOL)isValidPwd;
- (BOOL)isValidIdentityCard;

- (BOOL)isValidRealName;

- (BOOL)isValidVerificationCode;
@end
