//
//  YoCommonUI.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCommonUI.h"
#import "YoUIHelper.h"


@implementation YoCommonUI
+ (void)renderGlobalAppearances {
    [YoUIHelper customMoreOperationAppearance];
    [YoUIHelper customAlertControllerAppearance];
    [YoUIHelper customDialogViewControllerAppearance];
    [YoUIHelper customImagePickerAppearance];
    [YoUIHelper customEmotionViewAppearance];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    searchBar.searchTextPositionAdjustment = UIOffsetMake(4, 0);
}

@end

@implementation YoCommonUI (ThemeColor)
static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9];
    }
    return themeColors[arc4random() % 9];
}

+ (UIColor *)themeColor {
    return UIColorTheme;
}

@end

@implementation YoCommonUI (Layer)
+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
    [layer qmui_removeDefaultAnimations];
    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}

@end
