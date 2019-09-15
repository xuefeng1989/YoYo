//
//  YoBigImageViewViewController.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/11.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoBigImageViewViewController.h"
#import "UIView+HXExtension.h"
#import "YoShowBigImageViewCell.h"


@interface YoBigImageViewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@end

@implementation YoBigImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0,self.view.hx_w + 20, self.view.hx_h) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YoShowBigImageViewCell class] forCellWithReuseIdentifier:@"YoShowBigImageViewCell"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YoShowBigImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YoShowBigImageViewCell" forIndexPath:indexPath];
    YoImageModel *model = self.photoArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)setPhotoArr:(NSArray *)photoArr
{
    _photoArr = photoArr;
    [self.collectionView reloadData];
}
@end
