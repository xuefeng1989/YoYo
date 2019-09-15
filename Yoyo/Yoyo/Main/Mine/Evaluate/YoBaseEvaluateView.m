//
//  YoBaseEvaluateView.m
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBaseEvaluateView.h"
#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "YoEvaluateModel.h"
#import "UIView+Recognizer.h"

static CGFloat const kAvatarHeight = 70;
@interface YoBaseEvaluateView()
@property(nonatomic, strong) QMUILabel *nicknameLabel;
@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) NSMutableArray *tagBtnArray;
@property(nonatomic, strong) QMUIFillButton *evaluateBtn;
@property(nonatomic, strong) QMUILabel *introLabel;
@property(nonatomic, strong) NSMutableArray *seletedTagArray;
@property(nonatomic, strong) QMUIFillButton *selectBtn;
@end

@implementation YoBaseEvaluateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        self.layer.cornerRadius = 15;
        self.userInteractionEnabled = YES;
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAvatarHeight, kAvatarHeight)];
        self.avatarImageView.layer.cornerRadius = kAvatarHeight/2;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.borderWidth = 2;
        self.avatarImageView.layer.borderColor = UIColorWhite.CGColor;
        NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [self addSubview:self.avatarImageView];
        self.nicknameLabel = [[QMUILabel alloc] init];
        self.nicknameLabel.text = @"慕言";
        self.nicknameLabel.font = UIFontBoldMake(16);
        self.nicknameLabel.textColor = UIColorBlackFont;
        [self addSubview:self.nicknameLabel];
        
        self.titleLabel = [[QMUILabel alloc] init];
        self.titleLabel.text = @"我收到的评价";
        self.titleLabel.font = UIFontMake(13);
        self.titleLabel.textColor = UIColorGrayFont;
        [self addSubview:self.titleLabel];
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorSeparator;
        [self addSubview:self.lineView];
        self.tagBtnArray = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            QMUIFillButton *tagBtn = [[QMUIFillButton alloc] init];
            tagBtn.cornerRadius = RatioZoom(35)/2;
            tagBtn.titleLabel.font = UIFontMake(14);
            tagBtn.hidden = YES;
            [tagBtn whenTapped:^{
                [self didClickTagHandler:tagBtn];
            }];
            [self addSubview:tagBtn];
            [self.tagBtnArray addObject:tagBtn];
        }
        self.evaluateBtn = [[QMUIFillButton alloc] init];
        self.evaluateBtn.fillColor = UIColorGrayBackGround1;
        self.evaluateBtn.titleTextColor = UIColorBlackFont;
        [self.evaluateBtn setTitle:@"评价他" forState:UIControlStateNormal];
        [self.evaluateBtn addTarget:self action:@selector(didClickEvaluateHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.evaluateBtn];
        self.introLabel = [[QMUILabel alloc] init];
        self.introLabel.text = @"严重问题请举报";
        self.introLabel.font = UIFontMake(12);
        self.introLabel.textColor = UIColorGrayFont;
        [self addSubview:self.introLabel];
        self.evaluateBtn.hidden = YES;
        self.introLabel.hidden = YES;
        self.seletedTagArray = [NSMutableArray array];
    }
    return self;
}

- (void)setIsShowEvaluateBtn:(BOOL)isShowEvaluateBtn {
    _isShowEvaluateBtn = isShowEvaluateBtn;
    
    self.frame = CGRectMake(30, 0, SCREEN_WIDTH - 60, 250);
    self.userInteractionEnabled = NO;
    if (isShowEvaluateBtn) {
        self.frame = CGRectMake(30, 0, SCREEN_WIDTH - 60, 350);
        self.evaluateBtn.hidden = NO;
        self.introLabel.hidden = NO;
        self.userInteractionEnabled = YES;

    }
    
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    int count = 3;
    CGFloat pic_width = RatioZoom(75);
    CGFloat pic_height = RatioZoom(35);
    CGFloat left_margin = 0;
    
    for (NSInteger i=0; i < (dataArray.count > 9 ? 9:dataArray.count); i++) {
        QMUIFillButton *tagBtn = self.tagBtnArray[i];
        YoEvaluateModel *model = dataArray[i];
        NSString *contentStr = [NSString stringWithFormat:@"%@ %@",model.dictValue, model.count];
        [tagBtn setTitle:contentStr forState:UIControlStateNormal];
        tagBtn.hidden = NO;
        tagBtn.fillColor = UIColorGrayBackGround1;
        tagBtn.titleTextColor = UIColorGrayFont;
        if (model.count.integerValue > 0) {
            tagBtn.fillColor = UIColorGlobal;
            tagBtn.titleTextColor = UIColorWhite;
        }
        tagBtn.tag = i;
        
        NSInteger row = i / count;
        NSInteger col = i % count;
        CGFloat marginX = (self.bounds.size.width - left_margin*2 - (pic_width * count)) / (count + 1);
        //        CGFloat marginY = (self.bounds.size.height - (pic_height * count)) / (count + 1);
        CGFloat marginY = 3;
        
        CGFloat picX = marginX + left_margin + (pic_width + marginX) * col;
        CGFloat picY = marginY + (pic_height + marginY + 5) * row;
        
        tagBtn.frame = CGRectMake(picX, 100 + picY, pic_width, pic_height);
        
    }
}

#pragma mark - Event
- (void)didClickTagHandler:(QMUIFillButton *)btn {
    if (_selectBtn) {
        YoEvaluateModel *model  = _dataArray[_selectBtn.tag];
        if (model.count.integerValue == 0) {
            _selectBtn.fillColor = UIColorGrayBackGround1;
            _selectBtn.titleTextColor = UIColorGrayFont;
        }
    }
    if (self.seletedTagArray.count > 0) {
        for (YoEvaluateModel *model in self.seletedTagArray) {
            model.isSelected = NO;
        }
        [self.seletedTagArray removeAllObjects];
    }
    btn.selected = !btn.selected;
    YoEvaluateModel *model  = _dataArray[btn.tag];
    model.isSelected = YES;
    NSString *name = model.dictValue;
    NSInteger num = [model.count integerValue];
    num = num + 1;
    [self.seletedTagArray addObject:model];
    NSString *contentStr = [NSString stringWithFormat:@"%@ %ld",name, (long)num];
    [btn setTitle:contentStr forState:UIControlStateNormal];
    btn.fillColor = UIColorGrayBackGround1;
    btn.titleTextColor = UIColorGrayFont;
    if (num > 0) {
        btn.fillColor = UIColorGlobal;
        btn.titleTextColor = UIColorWhite;
    }
     _selectBtn = btn;
}
- (void)didClickEvaluateHandler {
    if ([self.delegate respondsToSelector:@selector(YoBaseEvaluateViewSelectedEvaluateTagArray:)]) {
        [self.delegate YoBaseEvaluateViewSelectedEvaluateTagArray:[self.seletedTagArray copy]];
    }
}
- (void)setNicknameString:(NSString *)nicknameString {
    _nicknameString = nicknameString;
    
    self.nicknameLabel.text = nicknameString;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    self.titleLabel.text = titleString;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kAvatarHeight, kAvatarHeight));
        make.top.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(6);
        make.centerX.equalTo(self);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(6);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_offset(PixelOne);
    }];
    
    [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(250);
        make.size.mas_offset(CGSizeMake(270, 50));
        make.centerX.equalTo(self);
    }];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.evaluateBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}


@end
