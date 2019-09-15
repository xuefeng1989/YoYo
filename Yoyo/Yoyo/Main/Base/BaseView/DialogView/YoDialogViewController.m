//
//  YoDialogViewController.m
//  Yoyo
//
//  Created by ning on 2019/6/6.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoDialogViewController.h"

#import "Const.h"

@interface YoDialogViewController ()
@property(nonatomic, strong) UIView *cusContentView;
@property(nonatomic, strong) QMUILabel *label;
@end

@implementation YoDialogViewController

- (void)didInitialize {
    [super didInitialize];
    
    // 头部背景颜色
    self.headerViewBackgroundColor = UIColorWhite;
    self.titleView.horizontalTitleFont = UIFontBoldMake(16);
    self.titleTintColor = UIColorBlack;
    
    // 分割线颜色
    self.headerSeparatorColor = nil;
    self.footerSeparatorColor = UIColorSeparator;
    // 按钮点击高亮颜色
    self.buttonHighlightedBackgroundColor = UIColorWhite;
    
    self.buttonTitleAttributes = @{NSForegroundColorAttributeName: UIColorGlobal};
    
    
    
    
}


- (void)setContentLabelString:(NSString *)contentLabelString {
    _contentLabelString = [contentLabelString copy];

    self.cusContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    self.cusContentView.backgroundColor = UIColorWhite;
    self.label = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorBlack];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = contentLabelString;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
//    self.label.center = CGPointMake(CGRectGetWidth(self.cusContentView.bounds) / 2.0, CGRectGetHeight(self.cusContentView.bounds));
    self.label.center = CGPointMake(CGRectGetWidth(self.cusContentView.bounds) / 2.0, self.label.qmui_height / 2.0);

    [self.cusContentView addSubview:self.label];

    self.contentView = self.cusContentView;
}




@end
