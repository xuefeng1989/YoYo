//
//  YoUIHelper.h
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoUIHelper : NSObject
+ (void)forceInterfaceOrientationPortrait;

@end


@interface YoUIHelper (QMUIMoreOperationAppearance)

+ (void)customMoreOperationAppearance;

@end


@interface YoUIHelper (QMUIAlertControllerAppearance)

+ (void)customAlertControllerAppearance;

@end

@interface YoUIHelper (QMUIDialogViewControllerAppearance)

+ (void)customDialogViewControllerAppearance;

@end


@interface YoUIHelper (QMUIEmotionView)

+ (void)customEmotionViewAppearance;
@end


@interface YoUIHelper (QMUIImagePicker)

+ (void)customImagePickerAppearance;

@end


@interface YoUIHelper (UITabBarItem)

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;

@end


@interface YoUIHelper (Button)

+ (QMUIButton *)generateDarkFilledButton;
+ (QMUIButton *)generateLightBorderedButton;

@end


@interface YoUIHelper (Emotion)

+ (NSArray<QMUIEmotion *> *)qmuiEmotions;

/// 用于主题更新后，更新表情 icon 的颜色
+ (void)updateEmotionImages;
@end


@interface YoUIHelper (SavePhoto)

+ (void)showAlertWhenSavedPhotoFailureByPermissionDenied;

@end


@interface YoUIHelper (Calculate)

+ (NSString *)humanReadableFileSize:(long long)size;

@end


@interface YoUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
@end


@interface NSString (Code)

- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *codeString, NSRange codeRange))block;

@end

NS_ASSUME_NONNULL_END
