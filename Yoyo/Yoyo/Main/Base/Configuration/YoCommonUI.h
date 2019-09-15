//
//  YoCommonUI.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit/QMUIKit.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Colors
#define UIColorGrayFont UIColorMake(153, 153, 153)
#define UIColorGrayBackGround1 UIColorMake(230, 230, 230)
#define UIColorGrayBackGround UIColorMake(245, 245, 245)
#define UIColorBlackFont UIColorMake(74, 74, 74)
#define UIColorYellowFont UIColorMake(255, 207, 18)
#define UIColorOrangeFont UIColorMake(254, 112, 18)
#define UIColorContentFont UIColorMake(51,51,51)
#define UIColorSUBContentFont UIColorMake(102,102,102)


#define UIColorGrayLine UIColorMake(1, 37, 17)


#define UIColorGray1 UIColorMake(53, 60, 70)
#define UIColorGray2 UIColorMake(73, 80, 90)
#define UIColorGray3 UIColorMake(93, 100, 110)
#define UIColorGray4 UIColorMake(113, 120, 130)
#define UIColorGray5 UIColorMake(133, 140, 150)
#define UIColorGray6 UIColorMake(153, 160, 170)
#define UIColorGray7 UIColorMake(173, 180, 190)
#define UIColorGray8 UIColorMake(196, 200, 208)
#define UIColorGray9 UIColorMake(216, 220, 228)


#define UIColorTheme UIColorMake(249, 249, 249);  // 主题颜色
#define UIColorGlobal UIColorMake(102, 69, 251)  // 全局紫色


#define UIColorTheme1 UIColorMake(239, 83, 98) // Grapefruit
#define UIColorTheme2 UIColorMake(254, 109, 75) // Bittersweet
#define UIColorTheme3 UIColorMake(255, 207, 71) // Sunflower
#define UIColorTheme4 UIColorMake(159, 214, 97) // Grass
#define UIColorTheme5 UIColorMake(63, 208, 173) // Mint
#define UIColorTheme6 UIColorMake(49, 189, 243) // Aqua
#define UIColorTheme7 UIColorMake(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UIColorMake(172, 143, 239) // Lavender
#define UIColorTheme9 UIColorMake(238, 133, 193) // Pink Rose

#define NavgationSubMinY (IS_NOTCHED_SCREEN ? 24 : 0)
#define Size(x)    ((x)*SCREEN_WIDTH*1.0/375.0)

#define is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0

#define CodeFontMake(_pointSize) [UIFont fontWithName:@"Menlo" size:_pointSize]
#define CodeAttributes(_fontSize) @{NSFontAttributeName: CodeFontMake(_fontSize), NSForegroundColorAttributeName: [QDThemeManager sharedInstance].currentTheme.themeCodeColor}

/// QMUIButton 系列 Demo 里的一行高度
extern const CGFloat QDButtonSpacingHeight;

@interface YoCommonUI : NSObject

+ (void)renderGlobalAppearances;
@end

@interface YoCommonUI (ThemeColor)

+ (UIColor *)randomThemeColor;

+ (UIColor *)themeColor;

@end

@interface YoCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer;
@end


NS_ASSUME_NONNULL_END
