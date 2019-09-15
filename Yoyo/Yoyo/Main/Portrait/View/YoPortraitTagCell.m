//
//  YoPortraitTagCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitTagCell.h"
#import "UIView+ZYTagView.h"
#import <Masonry.h>
#import "Const.h"
@interface YoPortraitTagCell()

@end

@implementation YoPortraitTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.tagImageView];
//        [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView).offset(RatioZoom(15));
//            make.top.mas_equalTo(self.contentView).offset(RatioZoom(10));;
//            make.right.mas_equalTo(self.contentView).offset(-RatioZoom(15));
//            make.height.mas_equalTo(RatioZoom(400));
//        }];
    }
    return self;
}


- (ZYTagImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[ZYTagImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tagImageView.clipsToBounds = YES;
    }
    return _tagImageView;
}

@end
