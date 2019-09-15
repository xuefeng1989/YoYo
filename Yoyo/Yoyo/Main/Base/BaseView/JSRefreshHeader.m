//
//  JSRefreshHeader.m
//  LGRestaurant
//
//  Created by ning on 2019/3/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "JSRefreshHeader.h"

#import "YoCommonUI.h"
#import "Const.h"

@interface JSRefreshHeader()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, assign) BOOL hasRefreshed;

@end

@implementation JSRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.hasRefreshed = NO;//初始化的时候，肯定是没有刷新过的
    
    [self addSubview:self.logoView];
    [self.layer addSublayer:self.circleLayer];
    
    self.mj_h = 64;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    self.logoView.bounds = CGRectMake(0, 0, 26, 26);
    self.logoView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0);// +10是为了logoView在中心点往下一点的位置，方便观看
    
    self.circleLayer.frame = CGRectMake(self.mj_w/2 - 40/2, self.mj_h/2 - 40/2, 40, 40);
}

#pragma mark - setter & getter
- (UIImageView *)logoView{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_refresh"]];
//        _logoView.text = @"🤮";
//        _logoView.textAlignment = NSTextAlignmentCenter;
//        [_logoView.layer addSublayer:self.circleLayer];
    }
    return _logoView;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 40, 40)];//先写剧本
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path          = path.CGPath;//安排剧本
        _circleLayer.fillColor     = [UIColor clearColor].CGColor;//填充色要为透明，不然会遮挡下面的图层
        _circleLayer.strokeColor   = UIColorGlobal.CGColor;
        _circleLayer.lineWidth     = 3.0;
        _circleLayer.frame         = path.bounds;
        _circleLayer.strokeEnd = 0;
    }
    return _circleLayer;
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            self.hasRefreshed = YES;//刷新过了
            [self.circleLayer addAnimation:[self createRefreshAnimation] forKey:@"1"];
            break;
        default:
            break;
    }
    [JSNSNotificationCenter postNotificationName:LG_JSRefreshHeaderNotification object:[NSNumber numberWithInteger:state]];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    if (self.hasRefreshed) {//刷新返回的时候，strokeEnd = 0.0
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeEnd = 1.0;
        [CATransaction commit];
        self.hasRefreshed = NO;//重置状态为未刷新
        [self.circleLayer removeAnimationForKey:@"1"];
    }else{
        self.circleLayer.strokeEnd = pullingPercent;
    }
    
}

- (void)endRefreshing{
    [self.circleLayer removeAllAnimations];
    [super endRefreshing];
}


- (CAAnimationGroup *)createRefreshAnimation {
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(-0.5);
    startAnimation.toValue = @(1);
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0);
    endAnimation.toValue = @(1);
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[startAnimation, endAnimation];
    groupAnimation.duration = 1.5;
    groupAnimation.repeatCount = INFINITY;
    
    return groupAnimation;
    
}

@end
