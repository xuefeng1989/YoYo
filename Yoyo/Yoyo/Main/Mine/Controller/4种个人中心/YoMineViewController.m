//
//  YoMineViewController.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineViewController.h"
#import "YoMineMaleViewController.h"
#import "YoOtherMaleViewController.h"
#import "YoOtherFemaleViewController.h"
#import "YoAuthenticationViewController.h"

@interface YoMineViewController ()

@property (nonatomic, assign) BOOL isFemale;

@end

@implementation YoMineViewController

- (instancetype)initWithType:(YoMineViewControllerType)type {
    
    YoMineViewController *vc;
    
    switch (type) {
        case YoMineViewControllerTypeMineAndSexTypeMale:
            vc = [[YoMineMaleViewController alloc] init];
            break;
        case YoMineViewControllerTypeOtherAndSexTypeMale:
            vc = [[YoOtherMaleViewController alloc] init];
            break;
        case YoMineViewControllerTypeOtherAndSexTypeFemale:
            vc = [[YoOtherFemaleViewController alloc] init];
            break;

    }
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - QMUINavigationControllerAppearanceDelegate
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)preferredNavigationBarHidden {
    return NO;
}
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}



#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorClear];;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorClear size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}

- (UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoMineViewController";
}
#pragma mark  身份认证
- (void)goToauthenticate{
    YoAuthenticationViewController *authVC = [[YoAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authVC animated:YES];
}
@end
