//
//  JSRefreshFooter.m
//  LGRestaurant
//
//  Created by ning on 2019/3/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "JSRefreshFooter.h"
#import "YoCommonUI.h"
#import "Const.h"

@interface JSRefreshFooter()
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIButton * loadMoreBtn;
@property(nonatomic, strong) UIView *circelView;
@end
@implementation JSRefreshFooter

- (NSMutableDictionary *)stateTitles {
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}
- (void)prepare {
    [super prepare];
    
    self.stateTitles[@(MJRefreshStateIdle)] = @"上拉加载更多";
    self.stateTitles[@(MJRefreshStateRefreshing)] = @"刷新中...";
    self.stateTitles[@(MJRefreshStateNoMoreData)] = @"没有更多了";
    
    [self addSubview:self.loadMoreBtn];
    
    self.circelView = [[UIView alloc] init];
    [self.circelView.layer addSublayer:self.circleLayer];
    [self.loadMoreBtn addSubview:self.circelView];
}


- (void)placeSubviews {
    [super placeSubviews];
    
    self.loadMoreBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MJRefreshFooterHeight);
    CGFloat width = 15;
    self.circelView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, (MJRefreshFooterHeight - width)/2, width, width);
}



#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    [self.loadMoreBtn setTitle:self.stateTitles[@(state)] forState:UIControlStateNormal];
    
    if (state == MJRefreshStateRefreshing) {
        self.circelView.hidden = NO;
        [self.circleLayer addAnimation:[self createFooter] forKey:nil];
    } else {
        [self.circleLayer removeAllAnimations];
        self.circelView.hidden = YES;
    }
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 15)];//先写剧本
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path          = path.CGPath;//安排剧本
        _circleLayer.fillColor     = [UIColor clearColor].CGColor;//填充色要为透明，不然会遮挡下面的图层
        _circleLayer.strokeColor   = UIColorGlobal.CGColor;
        _circleLayer.lineWidth     = 2.0;
        _circleLayer.frame         = path.bounds;
        _circleLayer.strokeStart = 0;
        _circleLayer.strokeEnd = 0.4;
    }
    return _circleLayer;
}

- (void)endRefreshing{
    [self.circleLayer removeAllAnimations];
    [super endRefreshing];
}

- (CABasicAnimation *)createFooter {
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation1.duration = 1;
    animation1.fromValue = @0;
    animation1.toValue = @(M_PI * 2);
    animation1.repeatCount = INFINITY; // HUGE
    return animation1;
}

- (UIButton *)loadMoreBtn {
    if (_loadMoreBtn == nil) {
        _loadMoreBtn = [[UIButton alloc] init];
        _loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_loadMoreBtn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
    }
    return _loadMoreBtn;
}
@end
