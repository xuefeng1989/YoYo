//
//  NSData+gzip.h
//  QJ
//
//  Created by ningcol on 2017/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"
@interface NSData (gzip)

- (NSData*)ungzipData;  //解压缩
@end
