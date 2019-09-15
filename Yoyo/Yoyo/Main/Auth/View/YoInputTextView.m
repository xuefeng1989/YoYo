//
//  YoInputTextView.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoInputTextView.h"

#import "Const.h"
#import <Masonry.h>

@interface YoInputTextView()
@property(nonatomic, assign) YoInputTextViewType inputViewType;
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUITextField *textFieldView;
@property(nonatomic, strong) QMUIButton *getCodeBtn;
@property(nonatomic, strong) UIImageView *lineView;

@end

@implementation YoInputTextView

- (instancetype)initWithFrame:(CGRect)frame textViewType:(YoInputTextViewType)type textViewTitle:(nonnull NSString *)titleString;
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputViewType = type;
        
        self.lineView = [[UIImageView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.text = titleString;
        
        NSString *placeholder = nil;
        if (type == YoInputTextViewTypePhone) {
            placeholder = @"请输入您的号码";
        }
        if (type == YoInputTextViewTypePWD) {
            placeholder = @"请输入您的密码";
        }
        if (type == YoInputTextViewTypeCode) {
            placeholder = @"请输入验证码";
        }
        self.textFieldView = [[QMUITextField alloc] init];
        self.textFieldView.placeholder = placeholder;
        self.textFieldView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textFieldView.clearButtonMode = UITextFieldViewModeAlways;
        [self.textFieldView addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

        switch (type) {
            case YoInputTextViewTypePhone:
                self.textFieldView.clearButtonPositionAdjustment = UIOffsetMake(-20, 0);
                self.textFieldView.keyboardType = UIKeyboardTypeNumberPad;
                self.textFieldView.secureTextEntry = NO;
                break;
            case YoInputTextViewTypePWD:
                self.textFieldView.clearButtonPositionAdjustment = UIOffsetMake(-20, 0);
                self.textFieldView.keyboardType = UIKeyboardTypeASCIICapable;
                self.textFieldView.secureTextEntry = YES;
                if (@available(iOS 10.0, *)) {
                    self.textFieldView.textContentType = UITextContentTypeName;
                }
                break;
            case YoInputTextViewTypeCode:
                self.textFieldView.clearButtonPositionAdjustment = UIOffsetMake(-100, 0);
                self.textFieldView.keyboardType = UIKeyboardTypeNumberPad;
                self.textFieldView.secureTextEntry = NO;
                if (@available(iOS 12.0, *)) {
                    self.textFieldView.textContentType = UITextContentTypeOneTimeCode;
                }
                break;
        }
        
        
        self.getCodeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [self.getCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        self.getCodeBtn.backgroundColor = UIColorClear;
        self.getCodeBtn.titleLabel.font = UIFontMake(15);
        [self.getCodeBtn addTarget:self action:@selector(didClickCodeHandler:) forControlEvents:UIControlEventTouchUpInside];

        
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textFieldView];
        [self addSubview:self.getCodeBtn];
        [self addSubview:self.lineView];


    }
    return self;
}




- (void)didClickCodeHandler:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(YoInputTextView:clickDownBtn:)]) {
        [self.delegate YoInputTextView:self clickDownBtn:btn];
    }
}

- (void)changedTextField:(QMUITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(YoInputTextView:textViewType:inputTextViewChanged:)]) {
        [self.delegate YoInputTextView:self textViewType:_inputViewType inputTextViewChanged:textField.text];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
   
    CGFloat margin = 18;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin);
    }];
    
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.qmui_width - 100, self.qmui_height - 10));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(100);
    }];
    
    if (_inputViewType == YoInputTextViewTypeCode) {
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(60, 30));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-margin);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(PixelOne);
    }];
    
}

@end
