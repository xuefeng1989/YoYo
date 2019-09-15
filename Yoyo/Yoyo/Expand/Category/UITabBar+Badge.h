//
//  UITabBar+Badge.h
//  QiJi
//
//  Created by ningcol on 9/2/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

-(void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点
-(void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点
@end
