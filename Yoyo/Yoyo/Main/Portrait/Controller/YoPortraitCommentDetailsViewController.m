//
//  YoPortraitCommentDetailsViewController.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCommentDetailsViewController.h"
#import "YoPortraitCommentModel.h"
#import "YoPortraitCommentMultipleCell.h"
#import <Masonry.h>
#import "Const.h"
#import <HWPanModal/HWPanModal.h>
#import <QMUIKit/QMUIKit.h>
#import "YoPortraitCommentService.h"

@interface YoPortraitCommentDetailsViewController ()<HWPanModalPresentable>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) QMUITextField *textField;
@property (nonatomic, strong) QMUIButton *sendButton;

@end

@implementation YoPortraitCommentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[YoPortraitCommentMultipleCell class] forCellReuseIdentifier:@"cell"];
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
    
    [self.tableView setContentInset:UIEdgeInsetsMake(RatioZoom(40), 0, (RatioZoom(55+40)+NORMAL_Bottom), 0)];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = [NSString stringWithFormat:@"共%zd条回复", _comment.childrenList.count];
}


#pragma mark - method
- (void)sendComment {
    
    YoPortraitCommentService *service = [[YoPortraitCommentService alloc] initWithAlbumId:self.comment.albumId targetUserId:self.comment.targetUserId comment:@"测试第二级评论" parentId:self.comment.ID type:YoPortraitCommentServiceTypeCreate];
    [QMUITips showInfo:@"正在加载..."];
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        JSLogInfo(@"%@",request);
        NSDictionary *result = [request.responseJSONObject valueForKey:@"data"];
        
        [self.tableView reloadData];
        [QMUITips hideAllTips];
    } failure:^(JSError *error) {
        JSLogInfo(@"%@",error);
        [QMUITips showError:error.description];
        
    }];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _comment.childrenList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoPortraitCommentMultipleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.comment.childrenList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.comment.childrenList[indexPath.row].cellHeight;
}

#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    return self.tableView;
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
