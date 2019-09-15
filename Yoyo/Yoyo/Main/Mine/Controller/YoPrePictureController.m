//
//  YoPrePictureController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/25.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPrePictureController.h"

@interface YoPrePictureController ()

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation YoPrePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    }
    return _collectionView;
}

@end
