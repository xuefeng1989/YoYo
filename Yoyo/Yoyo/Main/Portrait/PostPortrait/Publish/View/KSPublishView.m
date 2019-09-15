//
//  KSPublishView.m
//  
//
//  Created by kinsun on 2018/12/28.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSPublishView.h"
#import "Yoyo-Swift.h"
#import "KSLayout.h"

@interface KSPublishView () <UITextViewDelegate>

@end

@implementation KSPublishView {
    __weak UIView *_contentView;
    __weak UITextView *_inputTextView;
    __weak UILabel *_inputPlaceholderLabel;
    __weak UICollectionViewFlowLayout *_layout;
    __weak UICollectionView *_collectionView;
    __weak CALayer *_lineLayer;
    __weak UILabel *_tipLabel;
}
@synthesize inputTextView = _inputTextView, collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = UIColor.ks_background;
    
    KSMediaPickerHandlerNavigationView *navigationView = KSMediaPickerHandlerNavigationView.alloc.init;
    navigationView.title = @"发布写真集";
    navigationView.nextButton.hidden = YES;
    [self addSubview:navigationView];
    _navigationView = navigationView;
    
    UIView *contentView = UIView.alloc.init;
    contentView.backgroundColor = UIColor.ks_white;
    [self addSubview:contentView];
    _contentView = contentView;
    
    UIFont *font16 = [UIFont systemFontOfSize:13.f];
    UIColor *clearColor = UIColor.clearColor;
    
    UITextView *inputTextView = [[UITextView alloc] init];
    inputTextView.showsVerticalScrollIndicator = NO;
    inputTextView.bounces = NO;
    inputTextView.font = font16;
    inputTextView.textColor = UIColor.ks_wordMain_2;
    inputTextView.textContainer.lineFragmentPadding = 0;
    inputTextView.textContainerInset = (UIEdgeInsets){2.f, 18.f, 2.f, 18.f};
    inputTextView.returnKeyType = UIReturnKeyDone;
    inputTextView.backgroundColor = clearColor;
    inputTextView.delegate = self;
    [contentView addSubview:inputTextView];
    _inputTextView = inputTextView;
    
    UILabel *inputPlaceholderLabel = [[UILabel alloc] init];
    inputPlaceholderLabel.font = font16;
    inputPlaceholderLabel.textColor = UIColor.ks_wordMain_2;
    inputPlaceholderLabel.text = @"谈吐文明的人更受欢迎，请勿发布低俗/色请交易/或曝光他人隐私的内容...";
    inputPlaceholderLabel.numberOfLines = 0;
    [inputTextView addSubview:inputPlaceholderLabel];
    _inputPlaceholderLabel = inputPlaceholderLabel;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 5.f;
    layout.itemSize = (CGSize){83.0, 83.0};
    layout.sectionInset = (UIEdgeInsets){15.f, 15.f, 15.f, 15.f};
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = clearColor;
    [contentView addSubview:collectionView];
    _collectionView = collectionView;
    
    CALayer *linelayer = CALayer.layer;
    linelayer.backgroundColor = UIColor.ks_lightGray.CGColor;
    [contentView.layer addSublayer:linelayer];
    _lineLayer = linelayer;
    
    UILabel *tipLabel = UILabel.alloc.init;
    tipLabel.font = [UIFont systemFontOfSize:11.0];
    tipLabel.textColor = UIColor.ks_wordMain_2;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
    
    KSGradientButton *publishButton = KSGradientButton.alloc.init;
    [publishButton setTitle:@"发布写真集" forState:UIControlStateNormal];
    publishButton.layer.masksToBounds = YES;
    [self addSubview:publishButton];
    _publishButton = publishButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    CGSize windowSize = self.bounds.size;
    CGFloat windowWidth = windowSize.width;
    CGFloat windowHeight = windowSize.height;
    CGFloat egdeMargin = 15.f;
    
    viewW = windowWidth;
    viewH = UIView.statusBarNavigationBarSize.height;
    k_settingFrame(_navigationView);
    
    viewY = egdeMargin;
    viewH = 148.0;
    k_settingFrame(_inputTextView);
    
    viewX = 18.f; viewY = 2.f; viewW = windowWidth-egdeMargin*2.f;
    viewH = [_inputPlaceholderLabel sizeThatFits:(CGSize){viewW, windowHeight}].height;
    k_settingFrame(_inputPlaceholderLabel);
    
    viewX = egdeMargin; viewY = CGRectGetMaxY(_inputTextView.frame);
    viewH = 0.5f; viewW = windowWidth-viewX*2.0;
    k_settingFrame(_lineLayer);
    
    UIEdgeInsets sectionInset = _layout.sectionInset;
    viewX = 0.0; viewY = CGRectGetMaxY(_lineLayer.frame);
    viewW = windowWidth;
    viewH = ceil(sectionInset.top+_layout.itemSize.height+sectionInset.bottom);
    k_settingFrame(_collectionView);
    
    viewX = 0.0; viewY = CGRectGetMaxY(_navigationView.frame);
    viewW = windowWidth; viewH = CGRectGetMaxY(_collectionView.frame);
    k_settingFrame(_contentView);
    
    viewX = 0.0; viewY = CGRectGetMaxY(_contentView.frame)+egdeMargin;
    viewW = windowWidth; viewH = _tipLabel.font.lineHeight;
    k_settingFrame(_tipLabel);
    
    viewX = 44.0; viewY = CGRectGetMaxY(_tipLabel.frame)+egdeMargin;
    viewW = windowWidth-viewX*2.0; viewH = 50.0;
    k_settingFrame(_publishButton);
    _publishButton.layer.cornerRadius = viewH*0.5;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    BOOL enabled = textView.text.length > 0;
//    _sendButton.enabled = enabled;
    _inputPlaceholderLabel.hidden = enabled;
}

@end
