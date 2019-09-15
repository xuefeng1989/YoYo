//
//  YoMineFemaleTableViewCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/25.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMineFemaleTableViewCell.h"
#import <Masonry.h>
#import "Const.h"

@interface ItemView : UIView

@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, strong) UILabel *unitL;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.numberL];
        [self.numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(22));
            make.top.mas_equalTo(RatioZoom(20));
        }];
        
        [self addSubview:self.unitL];
        [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numberL.mas_right).offset(RatioZoom(2));
            make.bottom.mas_equalTo(self.numberL).offset(-RatioZoom(2));
        }];
        
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(-RatioZoom(20));
        }];
    }
    return self;
}

- (UILabel *)numberL {
    if (!_numberL) {
        _numberL = [UILabel new];
        _numberL.font = UIFontBoldMake(25);
        _numberL.textColor = UIColorContentFont;
    }
    return _numberL;
}

- (UILabel *)unitL {
    if (!_unitL) {
        _unitL = [UILabel new];
        _unitL.font = UIFontMake(13);
        _unitL.textColor = UIColorGray;
    }
    return _unitL;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = UIFontMake(13);
        _titleL.textColor = UIColorGray;
    }
    return _titleL;
}

@end

@interface YoMineFemaleTableViewCell()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) ItemView *heightV;
@property (nonatomic, strong) ItemView *weightV;
@property (nonatomic, strong) ItemView *braV;
@end

@implementation YoMineFemaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.contentView.backgroundColor = UIColorGlobal;
        
        [self.contentView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.contentView);
        }];

        [self.contentView addSubview:self.heightV];
        [self.contentView addSubview:self.weightV];
        [self.contentView addSubview:self.braV];
        [self.heightV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(20));
            make.width.mas_equalTo(RatioZoom(100));
            make.height.mas_equalTo(RatioZoom(90));
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.weightV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(RatioZoom(100));
            make.height.mas_equalTo(RatioZoom(90));
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.braV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(20));
            make.width.mas_equalTo(RatioZoom(100));
            make.height.mas_equalTo(RatioZoom(90));
            make.centerY.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        UIImage *image = [UIImage qmui_imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, RatioZoom(120)) cornerRadiusArray:@[@(20), @(0), @(0), @(20)]];
        _backImageView.image = image;
    }
    return _backImageView;
}

- (ItemView *)heightV {
    if (!_heightV) {
        _heightV = [ItemView new];
        _heightV.numberL.text = @"130";
        _heightV.unitL.text = @"CM";
        _heightV.titleL.text = @"身高";
    }
    return _heightV;
}

- (ItemView *)weightV {
    if (!_weightV) {
        _weightV = [ItemView new];
        _weightV.numberL.text = @"130";
        _weightV.unitL.text = @"KG";
        _weightV.titleL.text = @"体重";
    }
    return _weightV;
}

- (ItemView *)braV {
    if (!_braV) {
        _braV = [ItemView new];
        _braV.numberL.text = @"30";
        _braV.unitL.text = @"A";
        _braV.titleL.text = @"胸围";
    }
    return _braV;
}
- (void)setWeight:(NSString *)weight Height:(NSString *)heigh Chest:(NSString *)chest andText:(NSString *)text{
    _weightV.numberL.text = weight;
    _heightV.numberL.text = heigh;
    _braV.numberL.text = [chest substringWithRange:NSMakeRange(0, chest.length - 1)];
    _braV.unitL.text = [chest substringWithRange:NSMakeRange(chest.length - 1, 1)];;
}
@end
