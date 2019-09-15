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
#import "UploadImageService.h"
#import "YoAlbumCreatGetService.h"

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
    [self.view endEditing:YES];
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *widthArr = [NSMutableArray array];
    NSMutableArray *heightArr = [NSMutableArray array];
    NSMutableArray *tagArr = [NSMutableArray array];
    for (KSMediaPickerOutputModel *model in _dataModelArray) {
        NSData *data = UIImageJPEGRepresentation(model.image, 1.0);
        UIImage *finalImage = [UIImage imageWithData:data];
        NSNumber *width = [NSNumber numberWithFloat:finalImage.size.width];
        NSNumber *height = [NSNumber numberWithFloat:finalImage.size.height];
        [tagArr addObject:model.tags];
        [imageArr addObject:finalImage];
        [widthArr addObject:width];
        [heightArr addObject:height];
    }
    __weak __typeof(self)weakSelf = self;
    UploadImageService *imgApi = [[UploadImageService alloc] initWithImageArray:imageArr type:YoUploadImgTypeAlbum widthArray:widthArr heightArray:heightArr];
    [imgApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *imgArr = request.responseJSONObject[@"result"][@"list"];
        NSMutableArray *tempImageArr = [NSMutableArray array];
        for (NSInteger j =0; j < imgArr.count; j ++) {
            NSDictionary *dic  = imgArr[j];
            if (dic[@"url"]) {
                [tempImageArr addObject:dic[@"url"]];
            }
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSMutableArray *pictures = [NSMutableArray array];
        for (NSInteger i = 0; i < tempImageArr.count; i ++) {
            NSMutableDictionary *picture = [NSMutableDictionary dictionary];
            NSMutableArray *tagPicArr = [NSMutableArray array];
            if (i < heightArr.count) {
                NSNumber *height = heightArr[i];
                [picture setObject:height forKey:@"height"];
                NSNumber *width = widthArr[i];
                [picture setObject:width forKey:@"width"];
                NSArray *tagArray = tagArr[i];
            }
            NSString *url = tempImageArr[i];
            [picture setObject:tagPicArr forKey:@"tags"];
            [picture setObject:url forKey:@"picture"];
            [pictures addObject:picture];
        }
        [param setObject:pictures forKey:@"pictures"];
        [param setObject:(weakSelf.view.inputTextView.text ? weakSelf.view.inputTextView.text:@"wu") forKey:@"content"];
        YoAlbumCreatGetService *service = [[YoAlbumCreatGetService alloc] init];
        service.handlerType = BaseRequestHandlerTypePOST;
        service.params = param;
        [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips showSucceed:@"发布成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(JSError *error) {
            [QMUITips showError:@"发布失败，请稍后重试"];
        }];
    } failure:^(JSError *error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
    }];
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

}

- (NSArray<KSMediaPickerOutputModel *> *)outputModelArray {
    return [NSArray arrayWithArray:_dataModelArray];
}

@end
