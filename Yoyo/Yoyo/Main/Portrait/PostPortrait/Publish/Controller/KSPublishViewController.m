//
//  KSPublishViewController.m
//  
//
//  Created by kinsun on 2018/11/26.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSPublishViewController.h"
#import "KSPublishView.h"
#import "KSPublishViewUploadModel.h"
#import "KSPublishViewPictureCell.h"
#import "Yoyo-Swift.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface KSPublishViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) KSPublishView *view;

@end

@implementation KSPublishViewController {
    NSMutableArray <KSMediaPickerOutputModel *> *_dataModelArray;
}
@dynamic view;

- (instancetype)initWithOutputModelArray:(NSArray <KSMediaPickerOutputModel *> *)outputModelArray {
    if (self = [super init]) {
        _dataModelArray = outputModelArray != nil ? [NSMutableArray arrayWithArray:outputModelArray] : NSMutableArray.array;
    }
    return self;
}

static NSString * const k_iden = @"KSPublishViewPictureCell";
- (void)loadView {
    KSPublishView *view = [[KSPublishView alloc] init];
    
    UICollectionView *collectionView = view.collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:KSPublishViewPictureCell.class forCellWithReuseIdentifier:k_iden];
    
    [view.navigationView.closeButton addTarget:self action:@selector(_didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [view.publishButton addTarget:self action:@selector(_didClickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = view;
}

- (void)_didClickCloseButton:(UIButton *)closeButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_didClickPublishButton:(UIButton *)publishButton {

}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSPublishViewPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:k_iden forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [cell setDidClickRemoveButtonCallback:^(KSPublishViewPictureCell *b_cell) {
        [weakSelf didClickRemoveButtonWithCell:b_cell];
    }];
    cell.model = [_dataModelArray objectAtIndex:indexPath.item];
    return cell;
}

- (void)didClickRemoveButtonWithCell:(KSPublishViewPictureCell *)cell {
    KSPublishView *view = self.view;
    UICollectionView *collectionView = view.collectionView;
    NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
    if (indexPath != nil) {
        if (_dataModelArray.count <= 1) {
            [SVProgressHUD showInfoWithStatus:@"发布动态至少需要一个媒体资源！"];
            return;
        }
        [_dataModelArray removeObject:cell.model];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)didClickPublishButton {
    [self.view endEditing:YES];
//    self.view.publishButton.enabled = NO;
//    [self uploadAliyunImages];
}

- (NSArray<KSMediaPickerOutputModel *> *)outputModelArray {
    return [NSArray arrayWithArray:_dataModelArray];
}

@end
