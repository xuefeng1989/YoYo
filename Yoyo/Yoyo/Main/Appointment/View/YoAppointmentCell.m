//
//  YoAppointmentCell.m
//  Yoyo
//
//  Created by ning on 2019/6/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAppointmentCell.h"

#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

const UIEdgeInsets kInsets = {15, 15, 15, 15};
const CGFloat kAvatarSize = 45;
const CGFloat kNicknameAvatarTopPadding = 6;
const CGFloat kNicknameAvatarLeftPadding = 15;
const CGFloat kContentMargin = 8;
const CGFloat kPicSize = 90;
const CGFloat kPicMargin = 5;
const NSInteger kRowCount = 3;


@interface YoAppointmentCell()
@property(nonatomic, strong) UIImageView *portaritView;
@property(nonatomic, strong) QMUILabel *nicknameLabel;
@property(nonatomic, strong) UIImageView *sexView;
@property(nonatomic, strong) UIImageView *tagView;
@property(nonatomic, strong) QMUILabel *createTimeLabel;
@property(nonatomic, strong) QMUIFillButton *joinBtn;
@property(nonatomic, strong) QMUILabel *contentLabel;
@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, strong) UIView *picContentView;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *picViewArray;

@end
@implementation YoAppointmentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = nil;
    if (CellIdentifier == nil) {
        CellIdentifier = [NSString stringWithFormat:@"%@CellIdentifier", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.portaritView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAvatarSize, kAvatarSize)];
        self.portaritView.backgroundColor = UIColorRed;
        self.portaritView.layer.cornerRadius = kAvatarSize/2;
        self.portaritView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.portaritView];
        
        
        self.nicknameLabel = [[QMUILabel alloc] init];
        self.nicknameLabel.text = @"陆然";
        self.nicknameLabel.textColor = UIColorBlackFont;
        self.nicknameLabel.font = UIFontBoldMake(16);
        [self.contentView addSubview:self.nicknameLabel];
        
      
        self.sexView = [[UIImageView alloc] init];
        self.sexView.image = [UIImage imageNamed:@"icon_fill_sex_man"];
        [self.contentView addSubview:self.sexView];
        
        
        
        self.tagView = [[UIImageView alloc] init];
        self.tagView.image = [UIImage imageNamed:@"icon_appointment_tag_true"];
        [self.contentView addSubview:self.tagView];
        
        
        self.createTimeLabel = [[QMUILabel alloc] init];
        self.createTimeLabel.text = @"发布于2019.01.22 13.14";
        self.createTimeLabel.textColor = UIColorGrayFont;
        self.createTimeLabel.font = UIFontMake(12);
        [self.contentView addSubview:self.createTimeLabel];
        
        
        self.joinBtn = [[QMUIFillButton alloc] initWithFillColor:UIColorGlobal titleTextColor:UIColorWhite];
        [self.joinBtn setTitle:@"报名" forState:UIControlStateNormal];
        self.joinBtn.titleLabel.font = UIFontMake(14);
        self.joinBtn.cornerRadius = 3;
        [self.joinBtn addTarget:self action:@selector(didClickJoinHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.joinBtn];
        
        self.contentLabel = [[QMUILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = UIColorBlackFont;
        self.contentLabel.font = UIFontMake(14);
        [self.contentView addSubview:self.contentLabel];
        
        
        self.lineView = [[UIImageView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.lineView];
        
        
        self.picContentView = [[UIView alloc] init];
        [self.contentView addSubview:self.picContentView];
        
        for (int i = 0; i < 9; i++) {
            UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RatioZoom(kPicSize), RatioZoom(kPicSize))];
            picView.backgroundColor = UIColorBlue;
            picView.layer.cornerRadius = 3;
            picView.layer.masksToBounds = YES;
            [self.picContentView addSubview:picView];
            picView.tag = i;
            picView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickPicHandler:)];
            [picView addGestureRecognizer:tap];
            picView.hidden = YES;
            [self.picViewArray addObject:picView];
        }
    }
    return self;
}

#pragma mark - event
- (void)didClickJoinHandler {
    if ([self.delegate respondsToSelector:@selector(YoAppointmentCell:didClickJoinBtn:)]) {
        [self.delegate YoAppointmentCell:self didClickJoinBtn:1];
    }
}

- (void)didClickPicHandler:(UITapGestureRecognizer *)tap {
    
}


- (void)setContentLabelString:(NSString *)contentLabelString {
    _contentLabelString = contentLabelString;
    
    self.contentLabel.text = contentLabelString;
}


- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    
    NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
    
    for (UIImageView *picView in self.picViewArray) {
        picView.hidden = YES;
    }
    
    for (int i=0; i < picArray.count; i++) {
        UIImageView *picView = self.picViewArray[i];
        [picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
        picView.hidden = NO;
        
        NSInteger row = i / kRowCount;
        NSInteger col = i % kRowCount;
        CGFloat picX = (RatioZoom(kPicSize) + kPicMargin) * col;
        CGFloat picY = (RatioZoom(kPicSize) + kPicMargin) * row;
        
        picView.frame = CGRectMake(picX, picY, RatioZoom(kPicSize), RatioZoom(kPicSize));
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = size;
    CGFloat contentLabelWidth = size.width - kAvatarSize - kNicknameAvatarLeftPadding - UIEdgeInsetsGetHorizontalValue(kInsets) ;
    CGSize nicknameLabelSize = [self.nicknameLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    CGSize createTimeLabelSize = [self.createTimeLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    
    // 把间距都加起来，要和layoutSubviews中的一致
    CGFloat resultHeight = UIEdgeInsetsGetVerticalValue(kInsets) + kNicknameAvatarTopPadding + nicknameLabelSize.height + kContentMargin + createTimeLabelSize.height + kContentMargin + kContentMargin;
    
    // 计算文本的高度
    if (self.contentLabel.text.length > 0) {
        CGSize conentLabelSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += conentLabelSize.height;
    }
    
    // 计算内容九宫格图片高度
    CGFloat picHeight = 0;
    if ( 0 < _picArray.count &&  _picArray.count < 4) {
        picHeight = (RatioZoom(kPicSize) + kPicMargin) * 1;
    } else if (_picArray.count < 7) {
        picHeight = (RatioZoom(kPicSize) + kPicMargin) * 2;
    } else if (_picArray.count < 10) {
        picHeight = (RatioZoom(kPicSize) + kPicMargin) * 3;
    }
    resultHeight += picHeight;
    
    resultSize.height = resultHeight;
    
    return resultSize;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.portaritView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kAvatarSize, kAvatarSize));
        make.top.equalTo(self.contentView).offset(kInsets.top);
        make.left.equalTo(self.contentView).offset(kInsets.left);
    }];
    
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portaritView.mas_top).offset(kNicknameAvatarTopPadding);
        make.left.equalTo(self.portaritView.mas_right).offset(kNicknameAvatarLeftPadding);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(0);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.sexView.mas_right).offset(0);
    }];
    
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(kContentMargin);
        make.left.equalTo(self.nicknameLabel);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createTimeLabel.mas_bottom).offset(kContentMargin);
        make.left.equalTo(self.nicknameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-kInsets.right);
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.centerY.equalTo(self.portaritView);
        make.right.equalTo(self.contentView.mas_right).offset(-kInsets.right);
    }];
    
    [self.picContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(kContentMargin);
        make.left.equalTo(self.contentLabel);
        make.width.equalTo(self.contentLabel);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.bottom.equalTo(self.contentView).offset(-PixelOne);
        make.left.equalTo(self.nicknameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];

    
}


- (NSMutableArray<UIImageView *> *)picViewArray {
    if (_picViewArray == nil) {
        _picViewArray = [NSMutableArray array];
    }
    return _picViewArray;
}
@end
