//
//  JSSliderView.m
//  Master
//
//  Created by ningcol on 2017/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JSSliderView.h"
#import "Masonry.h"
#import "Const.h"

static const CGFloat topViewHeight = 42;
static CGFloat scaleSize = 1;

typedef NS_ENUM(NSUInteger, CollectionViewType) {
    TITLE,
    CONTENT
};

/*============== SliderTitleCell ===================*/

@interface JSSliderTitleCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIColor *themeColor;

- (void)initCellStyleWithImage:(NSString *)imageStr Status:(BOOL)isSelected;

@end

@implementation JSSliderTitleCell

- (void)initCellStyleWithImage:(NSString *)imageStr Status:(BOOL)isSelected {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    UIImage *image = nil;
    if (isSelected) {
       image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select",imageStr]];
    }else{
        image = [UIImage imageNamed:imageStr];
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0.75);
        make.left.right.bottom.equalTo(self);
    }];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_NAVBAR_COLOR;
    }
    return self;
}

@end


/*============== SliderView ===================*/

@interface JSSliderView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong) UICollectionView *titleCollectionView;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableDictionary *statusDic;
@property (nonatomic, strong) UIView *sliderLine;
@property (nonatomic, strong) NSMutableArray *imageStrArray;
@end

@implementation JSSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollEnabled = YES;
        
    }
    return self;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
}

- (void)reloadData {
    [self.contentCollectionView reloadData];
    [self.titleCollectionView reloadData];
    [self setUpLabels];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"JSSliderContentCell"];
    [self.titleCollectionView registerClass:[JSSliderTitleCell class] forCellWithReuseIdentifier:@"JSSliderTitleCell"];
    NSAssert(scaleSize >= 1, @"YJSliderView -- Title放大倍数需要不小于1");
    [self setUpLabels];
}


- (void)setUpLabels {
    self.imageStrArray = [NSMutableArray new];
    for (NSInteger index = 0; index < [self.delegate numberOfItemsInJSSliderView:self]; index ++) {
        NSString *imageStr = [self.delegate JSSliderView:self imageStrForItemAtIndex:index];
        [self.imageStrArray addObject:imageStr];
    }
}

/**
 *  更新下划线位置
 *
 *  @param index 当前位置
 */
- (void)updateSliderLinePosition:(CGFloat)index {
    //    NSNumber *indexNum = [NSNumber numberWithFloat:index];
    UICollectionViewFlowLayout *topLayout = (UICollectionViewFlowLayout *)self.titleCollectionView.collectionViewLayout;
    //    UIButton *button = self.buttonArray[indexNum.integerValue];
    //    NSDictionary *attrs = @{NSFontAttributeName : button.titleLabel.font};
    //    CGSize size = [[self.delegate yj_SliderView:self titleForItemAtIndex:indexNum.integerValue] sizeWithAttributes:attrs];
    //    CGFloat precent = (index - indexNum.integerValue);
    [self.sliderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(index * topLayout.itemSize.width);
        //        make.width.mas_equalTo( size.width);
        make.width.mas_equalTo(topLayout.itemSize.width);
    }];
}

#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfItemsInJSSliderView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewType type = collectionView.tag;
    switch (type) {
        case TITLE: {
            JSSliderTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSSliderTitleCell" forIndexPath:indexPath];
            cell.themeColor = self.themeColor;
            BOOL isSelected = [[self.statusDic objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
            [cell initCellStyleWithImage:self.imageStrArray[indexPath.item] Status:isSelected];
            return cell;
        }
        case CONTENT: {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSSliderContentCell" forIndexPath:indexPath];
            while (cell.contentView.subviews.count) {
                [cell.contentView.subviews.lastObject removeFromSuperview];
            }
            UIView *view = [self.delegate JSSliderView:self viewForItemAtIndex:indexPath.row];
            
            
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewType type = collectionView.tag;
    if (type == TITLE) {
        [self manageButtonStatus:indexPath.item];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.titleCollectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(JSSliderView:didSelectItemAtIndex:)]) {
            [self.delegate JSSliderView:self didSelectItemAtIndex:indexPath.row];
        }
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.tag == CONTENT) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        self.currentIndex = index;
        [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self manageButtonStatus:index];
        [self.titleCollectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(JSSliderView:didSelectItemAtIndex:)]) {
            [self.delegate JSSliderView:self didSelectItemAtIndex:index];
        }

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == CONTENT) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == CONTENT) {
        CGFloat indexValue = (CGFloat)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        [self updateSliderLinePosition:indexValue];
    }
}

#pragma mark - Actions

/**
 *  线性改变按钮颜色
 *
 *  @param label  改色label
 *  @param toColor 改变后的颜色
 *  @param scale   改色进度
 */
- (void)changeLabelColor:(UILabel *)label To:(UIColor *)toColor WithScale:(CGFloat)scale {
    CGFloat originRed, originGreen, originBlue;
    [label.textColor getRed:&originRed green:&originGreen blue:&originBlue alpha:nil];
    CGFloat targetRed, targetGreen, targetBlue;
    [toColor getRed:&targetRed green:&targetGreen blue:&targetBlue alpha:nil];
    CGFloat currentRed, currentGreen, currentBlue;
    currentRed = originRed + (targetRed - originRed) * scale;
    currentGreen = originGreen + (targetGreen - originGreen) * scale;
    currentBlue = originBlue + (targetBlue - originBlue) * scale;
    label.textColor = [UIColor colorWithRed:currentRed green:currentGreen blue:currentBlue alpha:1];
}

#pragma mark - Collection Init

- (UICollectionView *)titleCollectionView {
    if (_titleCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, topViewHeight) collectionViewLayout:layout];
        _titleCollectionView.tag = TITLE;
        _titleCollectionView.bounces = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.pagingEnabled = YES;
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleCollectionView];
    }
    
    UICollectionViewFlowLayout *topLayout = (UICollectionViewFlowLayout *)_titleCollectionView.collectionViewLayout;
    NSInteger totalNum = [self.delegate numberOfItemsInJSSliderView:self];
    if ( totalNum <= 4) {
        topLayout.itemSize = CGSizeMake(self.frame.size.width / totalNum, topViewHeight);
    } else {
        topLayout.itemSize = CGSizeMake(self.frame.size.width / 4, topViewHeight);
    }
    
    return _titleCollectionView;
}

- (UICollectionView *)contentCollectionView {
    if (_contentCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - topViewHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titleCollectionView.frame.size.height, self.frame.size.width, self.frame.size.height - topViewHeight) collectionViewLayout:layout];
        _contentCollectionView.tag = CONTENT;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.scrollEnabled = _scrollEnabled;
        [self addSubview:_contentCollectionView];
    }
    return _contentCollectionView;
}

- (void)manageButtonStatus:(NSInteger)index {
    for (NSNumber *number in self.statusDic.allKeys) {
        if ([number integerValue] == index) {
            [self.statusDic setObject:[NSNumber numberWithBool:YES] forKey:number];
        } else {
            [self.statusDic setObject:[NSNumber numberWithBool:NO] forKey:number];
        }
    }
}

/**
 *  存储初始化选择状态
 *
 *  @return 状态字典
 */
- (NSMutableDictionary *)statusDic {
    if (_statusDic == nil) {
        _statusDic = [[NSMutableDictionary alloc] init];
        for (int num = 0; num < [self.delegate numberOfItemsInJSSliderView:self]; num ++) {
            [_statusDic setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:num]];
            //带指定页面的初始化
            NSInteger initializeIndex = 0;
            if ([self.delegate respondsToSelector:@selector(initialzeIndexOfJSSliderView:)]) {
                initializeIndex = [self.delegate initialzeIndexOfJSSliderView:self];
            }
            if (num == initializeIndex) {
                self.currentIndex = num;
                [_statusDic setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:num]];
                [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                [self updateSliderLinePosition:num];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageStrArray[num]]];
                imageView.transform = CGAffineTransformMakeScale(scaleSize, scaleSize);
            }
        }
    }
    return _statusDic;
}

- (UIView *)sliderLine {
    if (_sliderLine == nil) {
        _sliderLine = [[UIView alloc] init];
        _sliderLine.backgroundColor = self.themeColor ? self.themeColor : [UIColor colorWithRed:0.15 green:0.71 blue:0.96 alpha:1.00];
        [self.titleCollectionView addSubview:_sliderLine];
        UICollectionViewFlowLayout *topLayout = (UICollectionViewFlowLayout *)self.titleCollectionView.collectionViewLayout;
        [_sliderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(self.titleCollectionView.mas_top).mas_offset(topViewHeight-2);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(topLayout.itemSize.width);
        }];
    }
    return _sliderLine;
}

@end
