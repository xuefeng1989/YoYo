//
//  UILabel+Additions.m
//  DamaiHD
//
//  Created by lixiang on 13-11-5.
//  Copyright (c) 2013年 damai. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (void)adjustFontWithMaxSize:(CGSize)maxSize {
    CGSize stringSize;
    if (CGSizeEqualToSize(maxSize, CGSizeZero)) {
  
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        stringSize = [self.text boundingRectWithSize:self.frame.size options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:NULL].size;
#else
        stringSize = [self.text sizeWithFont:self.font
                     constrainedToSize:self.frame.size
                         lineBreakMode:NSLineBreakByWordWrapping];
#endif
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        stringSize = [self.text boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:NULL].size;
#else
        stringSize = [self.text sizeWithFont:self.font
                           constrainedToSize:maxSize
                               lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    CGRect frame = self.frame;
    frame.size.width = stringSize.width;
    if (stringSize.height > frame.size.height) {
        frame.size.height = stringSize.height;
    }
    self.frame = frame;
    NSInteger lines = (int)stringSize.height / self.font.pointSize;
    self.numberOfLines = lines;
}

+(UILabel *)createLabel:(UIFont *)font withColor:(UIColor *)color
{
    UILabel *label =[[UILabel alloc]init];
    label.font=font;
    label.textColor=color;
    label.backgroundColor = [UIColor clearColor];
    //
    //    [self addSubview:label];
    //
    return label;
}

- (void)withAttributesForString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    NSRange range = [self.text rangeOfString:string];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:range];
    self.attributedText = attributedStr;
}

@end
