//
//  YoPortraitNavigationController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitNavigationController.h"
#import <HWPanModal/HWPanModal.h>
#import "YoPortraitCommentViewController.h"

@interface YoPortraitNavigationController ()<HWPanModalPresentable>


@end

@implementation YoPortraitNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YoPortraitCommentViewController *comment = [[YoPortraitCommentViewController alloc] init];
    comment.portrait = self.portrait;
    [self pushViewController:comment animated:YES];
}


- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        id<HWPanModalPresentable> obj = VC;
        return [obj panScrollable];
    }
    return nil;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}

@end
