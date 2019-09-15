//
//  YoBaseInfoCellView.m
//  Yoyo
//
//  Created by ning on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBaseInfoCellView.h"
#import "YoSinglePickerView.h"

#import "Const.h"
#import <Masonry.h>

@interface YoBaseInfoCellView()
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUITextField *textFieldView;
@property(nonatomic, strong) QMUILabel *textLabelView;

@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, assign) YoBaseInfoCellViewType type;

@property(nonatomic, strong) YoBasePickerView *agePickerView;

@end
@implementation YoBaseInfoCellView

- (instancetype)initWithFrame:(CGRect)frame viewType:(YoBaseInfoCellViewType)type title:(nonnull NSString *)titleString;
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.font = UIFontMake(16);
        self.titleLabel.text = titleString;
        
        self.textFieldView = [[QMUITextField alloc] init];
        self.textFieldView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textFieldView.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.textFieldView.textAlignment = NSTextAlignmentRight;
        self.textFieldView.font = UIFontMake(16);
        self.textFieldView.textColor = UIColorGrayFont;

        
        self.textLabelView = [[QMUILabel alloc] init];
        self.textLabelView.textAlignment = NSTextAlignmentRight;
        self.textLabelView.font = UIFontMake(16);
        self.textLabelView.textColor = UIColorGrayFont;
//        if ([titleString isEqualToString:@"所在地"]) {
//            self.textLabelView.text = YoUserDefault.city;
//        }

        self.lineView = [[UIImageView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        
        if (type == YoBaseInfoCellViewTypeTextField) {
            [self.textFieldView addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
            [self.textFieldView addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [self addSubview:self.textFieldView];

        }
        if (type == YoBaseInfoCellViewTypeLabel) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTextLabel:)];
            [self.textLabelView addGestureRecognizer:tap];
            [self addSubview:self.textLabelView];
            self.textLabelView.userInteractionEnabled = YES;
        }
    }
    return self;
}


- (void)setTextFieldString:(NSString *)textFieldString {
    _textFieldString = textFieldString;
    self.textFieldView.text = textFieldString;
}

- (void)setTextLabelString:(NSString *)textLabelString {
    self.textLabelView.text = textLabelString;
}

- (void)changedTextField:(QMUITextField *)textField {
    if (self.didChangeTextFieldblock) {
        self.didChangeTextFieldblock(textField.text, textField);
    }
}

- (void)didEndEditing:(QMUITextField *)textField {
    if (self.didEndEditTextFieldblock) {
        self.didEndEditTextFieldblock(textField.text);
    }
}


- (void)didClickTextLabel:(UITapGestureRecognizer *)tap {
    [self becomeFirstResponder];
    if (self.didClickLabelblock) {
        self.didClickLabelblock(self.textLabelView);
    }
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat margin = 18;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin);
    }];
    
    if (_type == YoBaseInfoCellViewTypeTextField) {
        [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.qmui_width - 100, self.qmui_height - 10));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-margin);
        }];
        
    }
    
    if (_type == YoBaseInfoCellViewTypeLabel) {
        [self.textLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.qmui_width - 100, self.qmui_height - 10));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-margin);
        }];
        
    }
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(PixelOne);
    }];
    

    
}

@end
