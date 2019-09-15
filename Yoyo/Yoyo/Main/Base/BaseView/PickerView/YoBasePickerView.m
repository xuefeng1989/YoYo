//
//  YoBasePickerVIew.m
//  Yoyo
//
//  Created by ning on 2019/5/31.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBasePickerView.h"

#import "Const.h"

@interface YoBasePickerView() <UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *lineView;
/// 标题栏
@property(nonatomic, strong) UIView *titleBarView;

@property(nonatomic, strong) QMUIButton *comfirmBtn;
@property(nonatomic, strong) QMUIButton *cancelBtn;

@end

@implementation YoBasePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bounds = [UIScreen mainScreen].bounds;
//        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        
        CGFloat content_height = 264;
        CGFloat titleBar_height = 50;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, content_height)];
        [self addSubview:self.contentView];
        
        
        self.titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleBar_height)];
        self.titleBarView.backgroundColor = UIColorWhite;
        [self.contentView addSubview:self.titleBarView];
        
        self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height - PixelOne, SCREEN_WIDTH, PixelOne)];
        self.lineView.backgroundColor = UIColorSeparator;
        [self.titleBarView addSubview:self.lineView];
        
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.titleBarView.qmui_height, SCREEN_WIDTH, self.contentView.qmui_height - self.titleBarView.qmui_height)];
        self.pickerView.backgroundColor = UIColorWhite;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.contentView addSubview:self.pickerView];
        
        
        CGFloat width = 60;
        self.comfirmBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(self.titleBarView.qmui_width - width, 0, width, self.titleBarView.qmui_height)];
        [self.comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.comfirmBtn setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        self.comfirmBtn.titleLabel.font = UIFontMake(14);
        [self.comfirmBtn addTarget:self action:@selector(didClickComfirmHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBarView addSubview:self.comfirmBtn];
        
        self.cancelBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.titleBarView.qmui_height)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorGrayFont forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = UIFontMake(14);
        [self.cancelBtn addTarget:self action:@selector(didClickCancelHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBarView addSubview:self.cancelBtn];
        
        
        [self initPickerView];
    
    }
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y -= self.contentView.frame.size.height;
    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = contentViewFrame;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss {
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y += self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = contentViewFrame;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
//        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}


- (void)initPickerView {
    
}

- (void)didClickComfirmHandler {
    [self dismiss];
}

- (void)didClickCancelHandler {
    [self dismiss];
}


#pragma mark - UIPickerViewDataSource 去除警告
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

@end
