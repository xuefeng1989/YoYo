//
//  KSPublishViewPictureCell.m
//  
//
//  Created by kinsun on 2018/12/28.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSPublishViewPictureCell.h"
#import "Yoyo-Swift.h"
#import "KSLayout.h"

@implementation KSPublishViewPictureCell {
    __weak UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = UIColor.ks_white;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        CALayer *layer = imageView.layer;
        layer.cornerRadius = 3.0;
        layer.masksToBounds = YES;
        [contentView addSubview:imageView];
        _imageView = imageView;
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setImage:[UIImage imageNamed:@"icon_publishDevelopment_close"] forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(_didClickRemoveButton) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:removeButton];
        _removeButton = removeButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    _imageView.frame = bounds;
    k_creatFrameElement;
    viewW = viewH = 26.f; viewX = bounds.size.width-viewW;
    k_settingFrame(_removeButton);
}

- (CGRect)imageViewFrameInSuperView {
    UIView *imageView = _imageView;
    UIView *cellContentView = imageView.superview;
    UIView *cell = cellContentView.superview;
    UIView *wrapperView = cell.superview;
    UIView *tableView = wrapperView.superview;
    UIView *view = tableView.superview;
    return [cell convertRect:imageView.frame toView:view];
}

- (void)_didClickRemoveButton {
    if (_didClickRemoveButtonCallback != nil) {
        _didClickRemoveButtonCallback(self);
    }
}

- (void)setModel:(KSMediaPickerOutputModel *)model {
    _model = model;
    _imageView.image = model.thumb;
}

@end
