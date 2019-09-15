//
//  YoShowBigImageViewCell.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/11.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoShowBigImageViewCell.h"
#import <UIImageView+WebCache.h>
@interface  YoShowBigImageViewCell()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation YoShowBigImageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}
- (void)setModel:(YoImageModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_scrollView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [_scrollView addGestureRecognizer:tap2];
        _scrollView.frame= self.contentView.bounds;
    }
    return _scrollView;
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    
}
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGPoint touchPoint;
        touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = self.contentView.bounds;
    }
    return _imageView;
}
- (CGFloat)getScrollViewZoomScale {
    return self.scrollView.zoomScale;
}
- (void)setScrollViewZoomScale:(CGFloat)zoomScale {
    [self.scrollView setZoomScale:zoomScale];
}
- (CGSize)getScrollViewContentSize {
    return self.scrollView.contentSize;
}
- (void)setScrollViewContnetSize:(CGSize)contentSize {
    [self.scrollView setContentSize:contentSize];
}
- (CGPoint)getScrollViewContentOffset {
    return self.scrollView.contentOffset;
}
- (void)setScrollViewContentOffset:(CGPoint)contentOffset {
    [self.scrollView setContentOffset:contentOffset];
}
- (void)resetScale:(BOOL)animated {
    [self resetScale:1.0f animated:animated];
}
- (void)resetScale:(CGFloat)scale animated:(BOOL)animated {
    [self.scrollView setZoomScale:scale animated:animated];
}

@end
