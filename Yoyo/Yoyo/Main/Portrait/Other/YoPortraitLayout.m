//
//  YoProtraitLayout.m
//  Yoyo
//
//  Created by yunxin bai on 2019/5/30.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitLayout.h"

@interface YoPortraitLayout()

@property(nonatomic,strong) NSMutableArray *columnHeights;
@property(nonatomic,strong) NSMutableArray *attributesArray;
@property(nonatomic,assign) CGFloat rowMargin;
@property(nonatomic,assign) CGFloat columnMargin;
@property(nonatomic,assign) NSInteger columnCount;
@property(nonatomic,assign) UIEdgeInsets edgeInsets;

@end


/** 默认的列数 */
static const NSInteger YoDefaultColumnCount = 2;
/** 每一列之间的间距 */
static const CGFloat YoDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat YoDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets YoDefaultEdgeInsets = {10, 10, 10, 10};




@implementation YoPortraitLayout


- (void)prepareLayout {
    [super prepareLayout];
    //清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    //清除之前所有的布局属性
    [self.attributesArray removeAllObjects];
    //开始创建新的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置对应的cell布局属性
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}

//返回布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSLog(@"layoutAttributesForElementsInRect");
    return self.attributesArray;
}

//返回每个indexPath对应的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    //布局的宽度和高度
    CGFloat width = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin) / self.columnCount;
    CGFloat height = [self.delegate waterFlowLayout:self heigthForItemAtIndex:indexPath.item itemWidth:width];
    
    //查找对短的一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        //第i列高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minColumnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn*(width + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attributes.frame = CGRectMake(x, y, width, height);
    
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}

//contentSize
- (CGSize)collectionViewContentSize {
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}
#pragma 懒加载
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [[NSMutableArray alloc]init];
    }
    return _columnHeights;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc]init];
    }
    return _attributesArray;
}

- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return YoDefaultRowMargin;
    }
}

- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return YoDefaultColumnMargin;
    }
}

- (NSInteger)columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return YoDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return YoDefaultEdgeInsets;
    }
}

@end
