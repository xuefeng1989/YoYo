//
//  YoBaseSelectedCellView.m
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBaseSelectedCellView.h"


@interface YoBaseSelectedCellView()
@property(nonatomic, strong) UIImageView *selectView;
@property(nonatomic, strong) UIImageView *lineView;
@end
@implementation YoBaseSelectedCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectType)];
        [self addGestureRecognizer:tap];
        
        
//        self.iconView = [[UIImageView alloc] init];
//        [self addSubview:self.iconView];
//        self.iconView.frame = CGRectMake(15, (CGRectGetHeight(frame) - 25) / 2 , 25, 25);
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.textColor = UIColorBlackFont;
        self.titleLabel.font = UIFontMake(15);
        [self addSubview:self.titleLabel];
        self.titleLabel.frame = CGRectMake(25, 0, 150, CGRectGetHeight(frame));
        
        UIImage *img = [UIImage imageNamed:@"mine_photo_unselected"];
        self.selectView = [[UIImageView alloc] init];
        [self.selectView setImage:img];
        [self addSubview:self.selectView];
        self.selectView.frame = CGRectMake(CGRectGetMaxX(frame) - 50, (CGRectGetHeight(frame) - img.size.width) / 2 , img.size.width, img.size.width);
        
        self.lineView = [[UIImageView alloc] init];
        self.lineView.layer.backgroundColor = UIColorSeparator.CGColor;
        [self addSubview:self.lineView];
        self.lineView.frame = CGRectMake(0, CGRectGetHeight(frame) - PixelOne, CGRectGetWidth(frame), PixelOne);
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        [self.selectView setImage:[UIImage imageNamed:@"mine_photo_selected"]];
    } else {
        [self.selectView setImage:[UIImage imageNamed:@"mine_photo_unselected"]];
    }
    
}

- (void)didSelectType {
    if ([self.delegate respondsToSelector:@selector(YoBaseSelectedCellView:didSelect:)]) {
        [self.delegate YoBaseSelectedCellView:self didSelect:_selected];
    }
}


@end
