//
//  YoPortraitCreateCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCreateCell.h"
#import "Const.h"
#import <Masonry.h>

@implementation YoPortraitCreateCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.deleteImage];
        [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [UIImageView new];
        _portraitImageView.frame = CGRectMake(RatioZoom(10), RatioZoom(6), RatioZoom(84), RatioZoom(84));
        _portraitImageView.layer.cornerRadius = RatioZoom(8);
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds = YES;
    }
    return _portraitImageView;
}

- (UIImageView *)deleteImage {
    if (!_deleteImage) {
        _deleteImage = [UIImageView new];
        _deleteImage.image = [UIImage imageNamed:@"icon_home_add"];
    }
    return _deleteImage;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   CGPoint point = [[touches anyObject] locationInView:self];
    
    if (CGRectContainsPoint(_deleteImage.frame, point)) {
        
        [super touchesEnded:touches withEvent:event];
    }
    
}

@end
