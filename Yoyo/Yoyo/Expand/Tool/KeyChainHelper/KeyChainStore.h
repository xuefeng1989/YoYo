//
//  KeyChainStore.h
//  ZZB
//
//  Created by ningcol on 3/23/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;



+ (NSString *)getUUID;

@end
