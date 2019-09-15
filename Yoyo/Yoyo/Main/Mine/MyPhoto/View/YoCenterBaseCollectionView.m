//
//  YoCenterBaseCollectionView.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/26.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCenterBaseCollectionView.h"

@implementation YoCenterBaseCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
