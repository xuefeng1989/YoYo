//
//  YoMineNormalCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/13.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineNormalCell.h"
#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface YoMineNormalCell ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *subImageView;// sub 图片view
@property (nonatomic, strong) UIView *seeContentView;
@property (nonatomic, strong) UIView *sepV;
@end

@implementation YoMineNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.contentView);
        }];
        
        
        [self.contentView addSubview:self.titleImageView];
        [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.subTitleLabel];
        if (_config.hideArrowImage) {
            [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-15);
                make.centerY.mas_equalTo(self.contentView);
            }];
        } else {
            [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-5);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
        [self.contentView addSubview:self.sepV];
        [self.sepV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(PixelOne);
        }];
        
        [self.contentView addSubview:self.subImageView];
        [self.subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.seeContentView];
        [self.seeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 40));
            make.left.mas_equalTo(self.titleL.mas_right).offset(5);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setConfig:(YoMineNormalCellConfig *)config {
    _config = config;
    self.titleImageView.image = [UIImage imageNamed:config.titleImageString];
    self.titleL.text = config.title;
    self.subTitleLabel.text = config.subTitleString;
    self.subTitleLabel.textColor = config.rightTitleColor;
    self.subImageView.image = [UIImage imageNamed:config.subImageString];
    self.arrowImageView.hidden = config.hideArrowImage;
    self.arrowImageView.image = [UIImage imageNamed:config.arrowImageString];
    self.seeContentView.hidden = config.hideSeeContentView;
    if (config.photoOnce && _config.photoOnce.avatars) {
        [self setSeeContentViewImage];
    }else{
        for (UIView *view in self.seeContentView.subviews) {
            [view removeFromSuperview];
        }
    }
}
- (void)setSeeContentViewImage{
    for (UIView *view in self.seeContentView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger maX = _config.photoOnce.avatars.count > 3 ? 3:_config.photoOnce.avatars.count;
    NSInteger i = 0;
    for (; i < maX; i ++) {
        NSString *avatar = _config.photoOnce.avatars[i];
        UIImageView *image = [self seeConItemImageView];
        
        image.frame = CGRectMake(i * 18, 7.5, 25, 25);
        if (avatar && avatar.length > 0) {
            [image sd_setImageWithURL:[NSURL URLWithString:avatar]];
        }
        [self.seeContentView addSubview:image];
    }
    UILabel *label = [self watchLabel];
    label.frame = CGRectMake(i * 18 + 7, (40 - label.bounds.size.height) / 2,  label.bounds.size.width,  label.bounds.size.height);
    [self.seeContentView addSubview:label];
}
- (UILabel *)watchLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font =[UIFont systemFontOfSize:12.0];
    label.text = [NSString stringWithFormat:@"%@人看过你",_config.photoOnce.total];
    [label sizeToFit];
    return label;
}
- (UIImageView *)seeConItemImageView{//创建阅后即焚小头像
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    itemImageView.layer.cornerRadius = 12.5;
    itemImageView.contentMode = UIViewContentModeScaleAspectFill;
    itemImageView.clipsToBounds = YES;
    return itemImageView;
}
- (void)setItem:(NSDictionary *)item {
    _item = item;
    self.titleImageView.image = [UIImage imageNamed:item[@"image"]];
    self.titleL.text = item[@"title"];
}

- (void)setCornerRadius {
    UIImage *image = [UIImage qmui_imageWithColor:[UIColor whiteColor] size:self.contentView.bounds.size cornerRadiusArray:@[@(16), @(0), @(0), @(16)]];
    self.contentView.backgroundColor = UIColorMakeWithRGBA(125, 95, 223, 0.9);
    self.backImageView.image = image;
    self.backImageView.hidden = NO;
}

- (void)resetCornerRadius {
    self.backImageView.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
    }
    return _backImageView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
    }
    return _titleImageView;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = UIFontBoldMake(16);
        _titleL.textColor = UIColorContentFont;
    }
    return _titleL;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = UIFontBoldMake(14);
        _subTitleLabel.textColor = UIColorGrayFont;
        _subTitleLabel.text = @"100个";
    }
    return _subTitleLabel;
}

// 箭头
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"mine_arrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)subImageView {
    if (!_subImageView) {
        _subImageView = [UIImageView new];
    }
    return _subImageView;
}

- (UIView *)seeContentView {
    if (!_seeContentView) {
        _seeContentView = [UIView new];
        _seeContentView.backgroundColor = [UIColor clearColor];
    }
    return _seeContentView;
}

- (UIView *)sepV {
    if (!_sepV) {
        _sepV = [UIView new];
        _sepV.backgroundColor = UIColorSeparator;
    }
    return _sepV;
}

@end
@implementation YoMineNormalCellConfig

- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString subTitle:(NSString *)subTitleString {
    return [self initWithTitle:title titleImageString:titleImageString arrowImageString:@"mine_arrow" subTitle:subTitleString subTitleColor:UIColorGrayFont subImageString:@"" hideArrowImage:NO hideSeeContentView:YES];
}

- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString {
    return [self initWithTitle:title titleImageString:titleImageString hideArrowImage:NO];
}

- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString hideArrowImage:(BOOL)hideArrowImage {
    return [self initWithTitle:title titleImageString:titleImageString arrowImageString:@"mine_arrow" subTitle:@"" subTitleColor:UIColorClear subImageString:@"" hideArrowImage:hideArrowImage hideSeeContentView:YES];
}


- (instancetype)initWithTitle:(NSString *)title titleImageString:(NSString *)titleImageString  arrowImageString:(NSString *)arrowImageString  subTitle:(NSString *)subTitleString subTitleColor:(UIColor *)rightTitleColor subImageString:(NSString *)subImageString hideArrowImage:(BOOL)hideArrowImage hideSeeContentView:(BOOL)hideSeeContentView {
    if (self = [super init]) {
        _title = title;
        _titleImageString = titleImageString;
        _arrowImageString = arrowImageString;
        _subTitleString = subTitleString;
        _rightTitleColor = rightTitleColor;
        _subImageString = subImageString;
        
        _hideSeeContentView = hideSeeContentView;
        _hideArrowImage = hideArrowImage;
    }
    return self;
}

@end
