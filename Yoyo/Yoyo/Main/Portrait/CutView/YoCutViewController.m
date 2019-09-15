//
//  YoCutViewController.m
//  Yoyo
//
//  Created by guzhichao on 2019/9/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoCutViewController.h"
#import "Const.h"

@interface YoCutViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
//选取取消按钮
@property (nonatomic, strong) UIButton *button_3_4;
@property (nonatomic, strong) UIButton *button_1_1;
@property (nonatomic, strong) UIButton *button_4_3;
@end

@implementation YoCutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self xc_setupController];
    }
    return self;
}

/**
 设置默认值
 */
- (void)xc_setupController
{
    _cutFrame = CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) *4/3);
    _cutBorderColor = [UIColor whiteColor];
    _maxScale = 3;
    _cutBorderWidth = 0.5;
    _cutCoverColor = [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xc_initSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark UI
/**
 初始化view
 */
- (void)xc_initSubViews
{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.borderView];
    
    _borderView.frame = _cutFrame;
    [self setCoverView];
    [self.view addSubview:self.button_3_4];
    [self.view addSubview:self.button_1_1];
    [self.view addSubview:self.button_4_3];
}
- (void)setCutFrame:(CGRect)cutFrame
{
    _cutFrame = cutFrame;
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    _borderView.frame = _cutFrame;
    [self setCoverView];
    _button_1_1.backgroundColor = [UIColor clearColor];
    _button_4_3.backgroundColor = [UIColor clearColor];
    _button_3_4.backgroundColor = [UIColor clearColor];
    if (self.cutIndex == 0) {
        _button_3_4.backgroundColor = UIColorGlobal;
    }else if (self.cutIndex == 1){
        _button_1_1.backgroundColor = UIColorGlobal;
    }else if (self.cutIndex == 2){
        _button_4_3.backgroundColor = UIColorGlobal;
    }
}
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.multipleTouchEnabled=YES; //是否支持多点触控
        _scrollView.minimumZoomScale = 1.0;  //表示与原图片最小的比例
        _scrollView.maximumZoomScale = _maxScale; //表示与原图片最大的比例
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _scrollView.clipsToBounds = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(_cutFrame.origin.y, _cutFrame.origin.x, SCREEN_HEIGHT - _cutFrame.origin.y - _cutFrame.size.height, SCREEN_WIDTH -  _cutFrame.origin.x - _cutFrame.size.width);
        [_scrollView addSubview:self.showImageView];
    }
    
    return _scrollView;
}

- (UIImageView*)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
        if (_originalImage) {
            _showImageView.image = _originalImage;
            [self setShowImageFrame];
        }
    }
    
    return _showImageView;
}

- (void)setShowImageFrame{
    _showImageView.frame = CGRectMake(0, 0, _cutFrame.size.width, _cutFrame.size.width * _originalImage.size.height / _originalImage.size.width);
    
    if (_showImageView.frame.size.height < _cutFrame.size.height) {
        _showImageView.frame = CGRectMake(0, 0,_cutFrame.size.height * _originalImage.size.width / _originalImage.size.height, _cutFrame.size.height);
    }
    
    _scrollView.contentSize = CGSizeMake(_showImageView.frame.size.width, _showImageView.frame.size.height);
    
    //调节图片位置
    if (_showImageView.frame.size.height > _scrollView.contentSize.height) {
        _scrollView.contentSize = CGSizeMake(_showImageView.frame.size.width, _showImageView.frame.size.height);
    }
    
    //调节图片位置
    if (_showImageView.frame.size.width > _scrollView.contentSize.width) {
        _scrollView.contentSize = CGSizeMake( _showImageView.frame.size.width, _showImageView.frame.size.height);
    }
}
- (UIView*)borderView
{
    if (!_borderView) {
//        _borderView = [[UIView alloc]initWithFrame:_cutFrame];
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderWidth = _cutBorderWidth;
        _borderView.layer.borderColor = _cutBorderColor.CGColor;
        _borderView.userInteractionEnabled = NO;
    }
    
    return _borderView;
}

- (UIButton*)button_3_4
{
    if (!_button_3_4) {
        _button_3_4 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80 * 3 - 40)/2, (SCREEN_WIDTH - 40) *4/3 + 20, 60, 30)];
        [_button_3_4 setTitle:@" 3:4 " forState:UIControlStateNormal];
        [_button_3_4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button_3_4 addTarget:self action:@selector(action3_4) forControlEvents:UIControlEventTouchUpInside];
        _button_3_4.backgroundColor = UIColorGlobal;
        _button_3_4.layer.masksToBounds = YES;
        _button_3_4.layer.cornerRadius = 15.0f;
    }
    
    return _button_3_4;
}
- (void)action3_4{
    _cutFrame = CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) *4/3);
//    [self.shapeLayer removeFromSuperlayer];
    [self setShowImageFrame];
    _borderView.frame = _cutFrame;
    [self setCoverView];
    _button_3_4.backgroundColor = UIColorGlobal;
    _button_1_1.backgroundColor = [UIColor clearColor];
    _button_4_3.backgroundColor = [UIColor clearColor];
    [self resetVCutFrame:0];
}
- (UIButton*)button_1_1
{
    if (!_button_1_1) {
        _button_1_1 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80 * 3 - 40)/2  + 100, (SCREEN_WIDTH - 40) *4/3 + 20, 60, 30)];
        [_button_1_1 setTitle:@" 1:1 " forState:UIControlStateNormal];
        [_button_1_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button_1_1 addTarget:self action:@selector(action_1_1) forControlEvents:UIControlEventTouchUpInside];
        _button_1_1.layer.masksToBounds = YES;
        _button_1_1.layer.cornerRadius = 15.0f;
    }
    return _button_1_1;
}
- (void)action_1_1{
    _cutFrame = CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40));
//    [self.shapeLayer removeFromSuperlayer];
    [self setShowImageFrame];
    _borderView.frame = _cutFrame;
    [self setCoverView];
    _button_3_4.backgroundColor = [UIColor clearColor];
    _button_1_1.backgroundColor = UIColorGlobal;
    _button_4_3.backgroundColor = [UIColor clearColor];
    [self resetVCutFrame:1];
}
- (UIButton*)button_4_3
{
    if (!_button_4_3) {
        _button_4_3 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80 * 3 - 40)/2  + 200, (SCREEN_WIDTH - 40) *4/3 + 20, 60, 30)];
        [_button_4_3 setTitle:@" 4:3 " forState:UIControlStateNormal];
        [_button_4_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button_4_3 addTarget:self action:@selector(action_4_3) forControlEvents:UIControlEventTouchUpInside];
        _button_4_3.layer.masksToBounds = YES;
        _button_4_3.layer.cornerRadius = 15.0f;
    }
    return _button_4_3;
}
- (void)action_4_3{
    _cutFrame = CGRectMake(20, 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)*3/4);
    _borderView.frame = _cutFrame;
    [self setShowImageFrame];
    [self setCoverView];
    _button_3_4.backgroundColor = [UIColor clearColor];
    _button_1_1.backgroundColor =[UIColor clearColor];
    _button_4_3.backgroundColor = UIColorGlobal;
    [self resetVCutFrame:2];
}
- (void)resetVCutFrame:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(imageCutViewControllerDidChangeFrame:andIndex:)]) {
        [self.delegate imageCutViewControllerDidChangeFrame:_cutFrame andIndex:index];
    }
}
/**
 覆盖层
 */
- (void)setCoverView
{
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    CGMutablePathRef path = CGPathCreateMutableCopy([UIBezierPath bezierPathWithRect:self.view.bounds].CGPath);
    UIBezierPath *cutBezierPath = [UIBezierPath bezierPathWithRect:_cutFrame];
    cutBezierPath.lineWidth = self.cutBorderWidth;
    CGMutablePathRef cutPath = CGPathCreateMutableCopy(cutBezierPath.CGPath);
    CGPathAddPath(path, nil, cutPath);
    _shapeLayer = [CAShapeLayer new];
    _shapeLayer.path = path;
    _shapeLayer.fillColor = self.cutCoverColor.CGColor;
    _shapeLayer.fillRule = kCAFillRuleEvenOdd;
    [self.view.layer addSublayer:_shapeLayer];
    CGPathRelease(cutPath);
    CGPathRelease(path);
}

/**
 裁剪照片
 
 @return 图片
 */
-(UIImage *)getCutImage{
    //算出截图位置相对图片的坐标
    CGRect rect = [self.view convertRect:_cutFrame toView:_showImageView];
    CGFloat scale = _originalImage.size.width / _showImageView.frame.size.width *
    _showImageView.transform.a;
    CGRect myImageRect= CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(_originalImage.CGImage, myImageRect);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    //释放资源
    CGImageRelease(subImageRef);
    
    return smallImage;
}


#pragma mark scrollView
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //缩放处理
}

#pragma mark action
- (void)confirmAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageCutViewController:finishedEidtImage:)]) {
        [_delegate imageCutViewController:self finishedEidtImage:[self getCutImage]];
    }
}
- (void)cancelAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageCutViewControllerDidCancel:)]) {
        [_delegate imageCutViewControllerDidCancel:self];
    }
}

@end
