//
//  YoSingleChatViewController.m
//  Yoyo
//
//  Created by guzhichao on 2019/9/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoSingleChatViewController.h"
#import "QMUINavigationButton.h"

@interface YoSingleChatViewController ()
@property (nonatomic, copy)UIColor *oldNavBg;
@end

@implementation YoSingleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oldNavBg = self.navigationController.navigationBar.backgroundColor;
    [self setNavBg];
}
- (void)setNavBg{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_back_black"] target:self action:@selector(handleNavLeftBarButtonEvent)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)handleNavLeftBarButtonEvent{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = _oldNavBg;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.title = userName;
    
}
@end
