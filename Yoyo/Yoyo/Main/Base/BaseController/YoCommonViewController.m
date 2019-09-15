//
//  YoCommonViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonViewController.h"
#import "Reachability.h"

@interface YoCommonViewController()
@property(nonatomic, weak) Reachability *reachbility;
@end

@implementation YoCommonViewController
- (void)didInitialize {
    [super didInitialize];
    
    //监听网络变化
    self.reachbility = [Reachability reachabilityWithHostName:Reachability_Test_Url];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(netStatusChange:) name:kReachabilityChangedNotification object:nil];
    //实现监听
    [self.reachbility startNotifier];
    
}

- (void)netStatusChange:(NSNotification *)noti {
    //判断网络状态
    switch (self.reachbility.currentReachabilityStatus) {
        case NotReachable:
            //            [MBProgressHUD showInfo:@"当前网络连接失败，请查看设置" ToView:self.view];
            JSLogInfo(@"网络异常");
            break;
        case ReachableViaWiFi:
            JSLogInfo(@"wifi上网");
            break;
        case ReachableViaWWAN:
            JSLogInfo(@"手机上网");
            break;
        default:
            break;
    }
}


#pragma mark - QMUI
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}


- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

// 当用户点击界面上某个 view 时，如果此时键盘处于升起状态，则可通过重写这个方法并返回一个 YES 来达到“点击空白区域自动降下键盘”的需求
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}
@end
