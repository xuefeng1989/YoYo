//
//  YoPortraitCreaeteViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/8.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCreaeteViewController.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry.h>
#import "YoPortraitCreateCell.h"
#import "YoUploadManager.h"
#import "ZYTagImageView.h"
#import "UIImage+Extension.h"
#import "UploadImageService.h"
#import "YoUploadImageService.h"
#import "YoAlbumCreatGetService.h"
@interface YoPortraitCreaeteViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QMUILabel *detailsLabel;
@property (nonatomic, strong) QMUIButton *commitButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YoPortraitCreaeteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = _imageArray.mutableCopy;
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F0F0F0"];
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(NORMAL_Y);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(RatioZoom(158));
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(RatioZoom(15));
        make.top.mas_equalTo(NORMAL_Y);
        make.right.mas_equalTo(self.view).offset(-RatioZoom(15));
        make.height.mas_equalTo(RatioZoom(158));
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(RatioZoom(1));
        make.height.mas_equalTo(RatioZoom(110));
    }];
    
    [self.view addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(RatioZoom(15));
    }];
    
    [self.view addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.detailsLabel.mas_bottom).offset(RatioZoom(24));
        make.width.mas_equalTo(RatioZoom(288));
        make.height.mas_equalTo(RatioZoom(50));
    }];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"发布写真集";
    
}

#pragma mark - method
- (void)commitButtonDidClicked {
//    JSLogInfo(@"%@",_imageArray);
//    NSMutableArray *tagsArray = [NSMutableArray array];
//    NSMutableArray *images = [NSMutableArray array];
//    for (NSDictionary *dict in _imageArray) {
//        UIImage *img = dict[@"image"];
//        NSArray *tags = dict[@"tags"];
//        NSMutableArray *tagsStringArray = [NSMutableArray array];
//        for (int i = 0; i < tags.count; i++) {
//            ZYTagInfo *tagInfo =  tags[i];
//            NSDictionary *dict = [tagInfo mj_keyValues];
//            [tagsStringArray addObject:dict];
//        }
//        [images addObject:img];
//        [tagsArray addObject:tagsStringArray];
//    }
//    [YoUploadManager uploadWithFile:images sueecss:^(NSDictionary * _Nullable success) {
//
//    } failure:^(NSString * _Nullable errorString) {
//
//    }];
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *widthArr = [NSMutableArray array];
    NSMutableArray *heightArr = [NSMutableArray array];
    NSMutableArray *tagArr = [NSMutableArray array];
    for (NSDictionary *dict in _imageArray) {
        UIImage *img = dict[@"image"];
        NSArray *tags = dict[@"tags"];
        UIImage *nowImage = [img scaleToWidth:400];
        NSData *data = UIImageJPEGRepresentation(nowImage, 1.0);
        double dataLength = [data length] * 1.0;
        if (dataLength > 1024 * 1024) {
            data = UIImageJPEGRepresentation(nowImage, 0.1);
        } else {
            data = UIImageJPEGRepresentation(nowImage, 0.9);
        }
        UIImage *finalImage = [UIImage imageWithData:data];
        NSNumber *width = [NSNumber numberWithFloat:finalImage.size.width];
        NSNumber *height = [NSNumber numberWithFloat:finalImage.size.height];
        [tagArr addObject:tags];
        [imageArr addObject:finalImage];
        [widthArr addObject:width];
        [heightArr addObject:height];
       
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
                    for (int i = 0; i < tagArray.count; i++) {
                        ZYTagInfo *tagInfo =  tagArray[i];
                        NSMutableDictionary *tagDIC = [NSMutableDictionary dictionary];
                        [tagDIC setObject:tagInfo.title forKey:@"label"];
                        [tagDIC setObject:@"0" forKey:@"lat"];
                        [tagDIC setObject:@"0" forKey:@"lon"];
                        [tagDIC setObject:@"北京" forKey:@"position"];
                        [tagPicArr addObject:tagDIC];
                    }
                }
                NSString *url = tempImageArr[i];
                [picture setObject:tagPicArr forKey:@"tags"];
                [picture setObject:url forKey:@"picture"];
                [pictures addObject:picture];
            }
            [param setObject:pictures forKey:@"pictures"];
            [param setObject:(weakSelf.textView.text ? weakSelf.textView.text:@"wu") forKey:@"content"];
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
    
}

- (void)delete:(UIButton *)button {
    [self.dataArray removeObjectAtIndex:button.tag];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitCreateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.portraitImageView.image = self.dataArray[indexPath.row][@"image"];
    cell.tag = indexPath.row;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}


#pragma mark - Lazy load
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}


- (QMUITextView *)textView {
    if (!_textView) {
        _textView = [[QMUITextView alloc] init];
        _textView.placeholder = @"谈吐文明的人更受欢迎，请勿发布低俗/色请交易/或曝光他人隐私的内容...";
        _textView.font = UIFontMake(13);
        _textView.textColor = [UIColor qmui_colorWithHexString:@"#999999"];
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(RatioZoom(100), RatioZoom(96));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,NORMAL_Y,self.view.bounds.size.width, RatioZoom(430)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[YoPortraitCreateCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}

- (QMUILabel *)detailsLabel {
    if (!_detailsLabel) {
        _detailsLabel = [QMUILabel new];
        _detailsLabel.text = @"请勿上传裸露低俗的照片，严重者将做封号处理";
        _detailsLabel.textColor = UIColorGray7;
        _detailsLabel.font = UIFontMake(11);
    }
    return _detailsLabel;
}

- (QMUIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:@"发布写真集" forState:UIControlStateNormal];
        _commitButton.backgroundColor = UIColorGlobal;
        _commitButton.layer.cornerRadius = RatioZoom(25);
        [_commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
