//
//  YoBaseTableView.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBaseTableView.h"
#import "QMUICore.h"
static const CGFloat HGCategoryViewDefaultHeight = 41;

@implementation YoBaseTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    CGFloat segmentViewContentScrollViewHeight = self.tableFooterView.frame.size.height - self.categoryViewHeight ?: HGCategoryViewDefaultHeight;
    BOOL isContainsPoint = CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint);
    return isContainsPoint ? YES : NO;
}

@end
