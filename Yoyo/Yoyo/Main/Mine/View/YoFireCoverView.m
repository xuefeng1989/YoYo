//
//  YoFireCoverView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoFireCoverView.h"
#import <Masonry.h>

@interface YoFireCoverView()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation YoFireCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self);
        }];
        [self addSubview:self.timerLabel];
        [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    
    self.coverView.hidden = YES;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)changeTimer {
    static NSTimeInterval duration = 0;
    duration++;
    if (duration >= self.duration) {
        [self.timer invalidate];
        self.coverView.hidden = NO;
    }
}

- (void)setCover:(BOOL)isShow withDuration:(NSTimeInterval)duration {
    if (isShow) {
        self.hidden = NO;
        self.duration = duration;
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeTimer) userInfo:nil repeats:YES];
    }
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [UILabel new];
        _timerLabel.textColor = [UIColor redColor];
    }
    return _timerLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor grayColor];
    }
    return _coverView;
}

@end
