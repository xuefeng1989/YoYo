//
//  YoMinePickerCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/17.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMinePickerCell.h"
#import "Const.h"
#import <Masonry.h>

@implementation YoMinePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = UIFontMake(16);
        _titleL.textColor = UIColorGlobal;
    }
    return _titleL;
}
@end
