//
//  YoReportViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoReportViewController.h"
#import "YoMinePhotoPickerCell.h"
#import "YoReportFooterView.h"
#import "YoReportUserService.h"
#import "UIImage+Extension.h"
#import "UploadImageService.h"
#import "YoUploadImageService.h"

@interface YoReportViewController ()<UITableViewDelegate, UITableViewDataSource,HXPhotoViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) YoReportFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *tempImageArr;
@end

@implementation YoReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemArray = @[
                       @{@"item":@"骚扰广告",@"sub":@"",@"selected":@"true"}.mutableCopy,
                       @{@"item":@"暴力色情",@"sub":@"",@"selected":@"fasle"}.mutableCopy,
                       @{@"item":@"虚假信息",@"sub":@"",@"selected":@"false"}.mutableCopy,
                       @{@"item":@"不能联系",@"sub":@"",@"selected":@"false"}.mutableCopy,
                       @{@"item":@"她是骗子",@"sub":@"",@"selected":@"false"}.mutableCopy,
                       @{@"item":@"其他",@"sub":@"",@"selected":@"false"}.mutableCopy,
                       ];
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"提交" target:self action:@selector(commit)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - method

- (void)commit {
    if (!_tempImageArr) {
        [QMUITips showError:@"请上传图片"];
    }
    for (int i = 0; i < self.itemArray.count; i++) {
        NSDictionary *item = self.itemArray[i];
        if ([item[@"selected"] isEqualToString:@"true"]) {
            YoReportUserService *service = [[YoReportUserService alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.userNo forKey:@"reportedNo"];
            [dic setObject:item[@"item"] forKey:@"content"];
            [dic setObject:_tempImageArr forKey:@"images"];
            service.params = dic;
            [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
                NSLog(@"request %@",data);
                [QMUITips showInfo:@"举报成功"];
                [self.navigationController popViewControllerAnimated:NO];
            } failure:^(JSError *error) {
                
            }];
            break;
        }
    }
}


- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *widthArr = [NSMutableArray array];
    NSMutableArray *heightArr = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak __typeof(self)weakSelf = self;
    for (NSInteger i = 0;i < photos.count;i ++ ){
        HXPhotoModel *model =photos[i];
        [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
            UIImage *nowImage = [image scaleToWidth:400];
            JSLogInfo(@"---size:%@", NSStringFromCGSize(nowImage.size));
            
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
            [imageArr addObject:finalImage];
            [widthArr addObject:width];
            [heightArr addObject:height];
            if (i == photos.count - 1) {
                UploadImageService *imgApi = [[UploadImageService alloc] initWithImageArray:imageArr type:YoUploadImgTypeAvatar widthArray:widthArr heightArray:heightArr];
                [imgApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSArray *imgArr = request.responseJSONObject[@"result"][@"list"];
                    weakSelf.tempImageArr = [NSMutableArray array];
                    for (NSInteger j =0; j < imgArr.count; j ++) {
                        NSDictionary *dic  = imgArr[j];
                        if (dic[@"url"]) {
                            [weakSelf.tempImageArr addObject:dic[@"url"]];
                        }
                    }
                    weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                } failure:^(JSError *error) {
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    [QMUITips showError:error.errorDescription inView:self.view hideAfterDelay:1.5];
                }];
            }
        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height+NORMAL_Y);
    [self.tableView reloadData];
}


#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoMinePhotoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.config = self.itemArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSMutableDictionary *item in self.itemArray) {
        item[@"selected"] = @"fasle";
    }
    NSMutableDictionary *item = self.itemArray[indexPath.row];
    item[@"selected"] = @"true";
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RatioZoom(40);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请选择举报原因";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RatioZoom(40);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"请提供相关截图，以使我们跟进核实";
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[YoMinePhotoPickerCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = RatioZoom(50);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (YoReportFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[YoReportFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RatioZoom(200))];
        _footerView.photoView.delegate = self;
    }
    return _footerView;
}
@end
