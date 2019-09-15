//
//  UITabBar+Badge.m
//  QiJi
//
//  Created by ningcol on 9/2/16.
//  Copyright © 2016 ningcol. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums  4    //tabbar的数量 如果是5个设置为5

@implementation UITabBar (Badge)
//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点(颜色)
//    UIView *badgeView = [[UIView alloc]init];
//    badgeView.tag = 888 + index;
//    badgeView.layer.cornerRadius = 5.0;//圆形
//    badgeView.backgroundColor = [UIColor blueColor];//颜色：红色
    //图片
    UIImageView *badgeView = [[UIImageView alloc] init];
    badgeView.image = [UIImage imageNamed:@"tabbar_point_"];
    badgeView.tag = 888 + index;
    
    
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x-2, y+4, 10.0, 10.0);//圆形大小为10
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
