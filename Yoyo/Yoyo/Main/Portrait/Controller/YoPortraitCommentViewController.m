//
//  YoPortraitCommentViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/6.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCommentViewController.h"
#import <HWPanModal.h>
#import "YoPortraitCommentModel.h"
#import "YoPortraitCommentNormalCell.h"
#import "YoPortraitCommentDetailsViewController.h"
#import "NSObject+YoRootViewController.h"
#import <Masonry.h>
#import "Const.h"
#import "YoPortraitCommentService.h"
#import "YoAlbumService.h"

@interface YoPortraitCommentViewController () <HWPanModalPresentable>
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) QMUITextField *textField;
@property (nonatomic, strong) QMUIButton *sendButton;
@end

@implementation YoPortraitCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setPortrait:(YoPortraitModel *)portrait {
    _portrait = portrait;
    [self loadNewData];
}

- (void)initSubviews {
    [super initSubviews];
    [self.tableView registerClass:[YoPortraitCommentNormalCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setContentInset:UIEdgeInsetsMake(RatioZoom(40), 0, NORMAL_Bottom+RatioZoom(55), 0)];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(RatioZoom(55)+NORMAL_Bottom);
    }];
    
    [self.bottomView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView).offset(RatioZoom(15));
        make.top.mas_equalTo(self.bottomView).offset(RatioZoom(10));
        make.width.mas_equalTo(RatioZoom(303));
        make.height.mas_equalTo(RatioZoom(35));
    }];
    
    [self.bottomView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-RatioZoom(15));
        make.centerY.mas_equalTo(self.textField);
    }];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"评论";
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - method
- (void)sendComment {
    [_textField resignFirstResponder];
    NSString *comment = _textField.text;
    if (comment && comment.length > 0) {
        YoPortraitCommentService *service = [[YoPortraitCommentService alloc] initWithAlbumId:self.portrait.albumId targetUserId:self.portrait.userNo comment:comment parentId:@"" type:YoPortraitCommentServiceTypeCreate];
        [QMUITips showInfo:@"正在加载..."];
        [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
             NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
            [self.dataArray addObject:[YoPortraitCommentModel mj_objectWithKeyValues:result]];
            [QMUITips showSucceed:@"评论成功"];
            [self.tableView reloadData];
            [QMUITips hideAllTips];
        } failure:^(JSError *error) {
            JSLogInfo(@"%@",error);
            [QMUITips showError:error.description];
        }];
    }else{
        [QMUITips showError:@"填写评论"];
    }
    
}
#pragma mark - request
- (void)loadNewData {
    self.pageIndex = 1;
    YoPortraitCommentService *service = [[YoPortraitCommentService alloc] initWithAlbumId:self.portrait.albumId pageIndex:self.pageIndex pageSize:20 type:YoPortraitCommentServiceTypeGetList];
    [QMUITips showInfo:@"正在加载..."];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        JSLogInfo(@"%@",request);
        NSDictionary *result = [request.responseJSONObject valueForKey:@"result"];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray: [YoPortraitCommentModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
        [self.tableView reloadData];
        [QMUITips hideAllTips];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips showError:error.description];

    }];
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitCommentNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArray[indexPath.row];
    MJWeakSelf;
    cell.moreBlock = ^(YoPortraitCommentModel *model) {
        YoPortraitCommentDetailsViewController *detailsVC = [[YoPortraitCommentDetailsViewController alloc] init];
        detailsVC.comment = model;
        [weakSelf.navigationController pushViewController:detailsVC animated:YES];
    };
    cell.likeBlock = ^(YoPortraitCommentModel * model) {
        [weakSelf likeButtonDidClicked:model AtIndexPath:indexPath];
    };
    return cell;
}
- (void)likeButtonDidClicked:(YoPortraitCommentModel *)model AtIndexPath:(NSIndexPath *)indexPath  {
    // 点赞
//    if (model.like) {
//        [self likeCancel:model AtIndexPath:indexPath];
//    }else{
        [self like:model AtIndexPath:indexPath];
//    }
}
// 点赞
- (void)like:(YoPortraitCommentModel *)model AtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf;
    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.ID sendType:YoAlbumTypePraise];
    [QMUITips showLoadingInView:weakSelf.view];
    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        model.likeCount = [NSNumber numberWithInteger:model.likeCount.integerValue + 1];
//        model.like = YES;
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showError:error.errorDescription];
    }];
}

// 取消点赞
- (void)likeCancel:(YoPortraitCommentModel *)model AtIndexPath:(NSIndexPath *)indexPath  {
    MJWeakSelf;
//    YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:model.albumId authorId:model.authorId sendType:YoAlbumTypePraiseCancel];
//    [QMUITips showLoadingInView:weakSelf.view];
//    [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [QMUITips hideAllTipsInView:weakSelf.view];
//        model.countAlbumLike = [NSNumber numberWithInteger:model.countAlbumLike.integerValue - 1];
//        model.like = NO;
//        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    } failure:^(JSError *error) {
//        JSLogInfo(@"%@",error);
//        [QMUITips hideAllTipsInView:weakSelf.view];
//        [QMUITips showError:error.errorDescription];
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitCommentModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}
#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    if (self.tableView.contentOffset.y <= 0) {
        return nil;
    }else{
        return self.tableView;
    }
}
- (BOOL)anchorModalToLongForm {
    return YES;
}
#pragma mark - lazy load
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (QMUITextField *)textField {
    if (!_textField) {
        _textField = [[QMUITextField alloc] init];
        _textField.placeholder = @"矜持点赞也可以，知音难觅聊一句";
        _textField.font = UIFontMake(13);
        _textField.textColor = UIColorContentFont;
        _textField.layer.cornerRadius = RatioZoom(17.5);
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = UIColorGray9.CGColor;
    }
    return _textField;
}

- (QMUIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:UIColorGlobal forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end
