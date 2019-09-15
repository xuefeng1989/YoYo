//
//  YoBaseInfoTagView.m
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBaseInfoTagView.h"

#import "Const.h"
#import <Masonry.h>

@interface YoBaseInfoTagView()

@property(nonatomic, strong) NSMutableArray<QMUIFillButton *> *tagBtnArray;
@property(nonatomic, strong) NSMutableArray<NSString *> *selectedArray;

@end
@implementation YoBaseInfoTagView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tagBtnArray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            QMUIFillButton *tagBtn = [[QMUIFillButton alloc] init];
            tagBtn.cornerRadius = 4;
            tagBtn.titleLabel.font = UIFontMake(14);
            tagBtn.hidden = YES;
            [tagBtn addTarget:self action:@selector(didClickTagHandler:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:tagBtn];
            [self.tagBtnArray addObject:tagBtn];
        }
        
    }
    return self;
}

- (void)setDataArray:(NSArray<NSString *> *)dataArray {
    _dataArray = dataArray;
    
    int count = 4;
    CGFloat pic_width = RatioZoom(83);
    CGFloat pic_height = RatioZoom(35);
    CGFloat left_margin = 6;
    
    for (int i=0; i < dataArray.count; i++) {
        QMUIFillButton *tagBtn = self.tagBtnArray[i];
        [tagBtn setTitle:dataArray[i] forState:UIControlStateNormal];
        tagBtn.hidden = NO;
        tagBtn.fillColor = UIColorGrayBackGround1;
        tagBtn.titleTextColor = UIColorGrayFont;
        
        NSInteger row = i / count;
        NSInteger col = i % count;
        CGFloat marginX = (self.bounds.size.width - left_margin*2 - (pic_width * count)) / (count + 1);
//        CGFloat marginY = (self.bounds.size.height - (pic_height * count)) / (count + 1);
        CGFloat marginY = 5;

        CGFloat picX = marginX + left_margin + (pic_width + marginX) * col;
        CGFloat picY = marginY + (pic_height + marginY + 5) * row;
        
        tagBtn.frame = CGRectMake(picX, picY, pic_width, pic_height);

    }
    
}

#pragma mark - didClickTagHandler
- (void)didClickTagHandler:(QMUIFillButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.fillColor = UIColorGlobal;
        btn.titleTextColor = UIColorWhite;
        [self.selectedArray addObject:btn.titleLabel.text];
    } else {
        btn.fillColor = UIColorGrayBackGround1;
        btn.titleTextColor = UIColorGrayFont;
        [self.selectedArray removeObject:btn.titleLabel.text];
    }
    
    if ([self.delegate respondsToSelector:@selector(YoBaseInfoTagView:didSelectedTagArray:)]) {
        [self.delegate YoBaseInfoTagView:self didSelectedTagArray:[self.selectedArray copy]];
    }
}

- (void)setSelectedArr:(NSArray<NSString *> *)selectedArr {
    _selectedArr = selectedArr;
    
    for (int i =0; i < _dataArray.count; i++) {
        if ([selectedArr containsObject:_dataArray[i]]) {
            QMUIFillButton *tagBtn = self.tagBtnArray[i];
            tagBtn.fillColor = UIColorGlobal;
            tagBtn.titleTextColor = UIColorWhite;
            tagBtn.selected = YES;
            [self.selectedArray addObject:tagBtn.titleLabel.text];
        }
    }
    

}


-(NSMutableArray<NSString *> *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


@end
