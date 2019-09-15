//
//  YoMindPortraitDetailViewController.m
//  Yoyo
//
//  Created by ningcol on 2019/7/20.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoMindMomentDetailViewController.h"
#import "YoMineFansViewController.h"
#import "YoPortraitPersonalViewController.h"
#import "YoMineNormalCell.h"
#import "YoBaseSelectedCellView.h"

@interface YoMindMomentDetailViewController ()<YoBaseSelectedCellViewDelegate>
@property(nonatomic, strong) QMUIModalPresentationViewController *modalVc;
@property(nonatomic, strong) YoBaseSelectedCellView *seletedView;
@end

@implementation YoMindMomentDetailViewController
- (void)initSubviews {
    [super initSubviews];
    
    self.dataArray = @[
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"可约否" titleImageString:@"icon_menu_mine_active"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我的写真集" titleImageString:@"icon_menu_mine_portrait"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我喜欢的写真集" titleImageString:@"icon_menu_mine_like"],
                    [[YoMineNormalCellConfig alloc] initWithTitle:@"我的粉丝" titleImageString:@"icon_menu_mine_fans"],
                    ];
    
    [self.tableView registerClass:[YoMineNormalCell class] forCellReuseIdentifier:@"normalCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorGrayBackGround;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YoMineNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    YoMineNormalCellConfig *item = self.dataArray[indexPath.row];
    cell.config = item;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self presentPayTypeView];
    }
    if (indexPath.row == 1) {
        YoPortraitPersonalViewController *personalVC = [[YoPortraitPersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:YES];
    }
    if (indexPath.row == 2) {
        
    }
    if (indexPath.row == 3) {
        YoMineFansViewController *fansVc = [[YoMineFansViewController alloc] init];
        fansVc.title = @"我的粉丝";
        [self.navigationController pushViewController:fansVc animated:YES];
    }
}


#pragma mark - YoBaseSelectedCellViewDelegate
- (void)YoBaseSelectedCellView:(YoBaseSelectedCellView *)view didSelect:(BOOL)selected {
    JSLogInfo(@"seleted:%@",view.titleLabel.text);
    if (self.seletedView != view) {
        self.seletedView.selected = NO;
        view.selected = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.modalVc hideWithAnimated:YES completion:^(BOOL finished) {
            
        }];
    });
}

- (void)presentPayTypeView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    contentView.backgroundColor = UIColorWhite;
    
    CGFloat headerHeight = 50;
    NSArray *array = @[@"可约", @"不可约", @"看礼物", @"在国外", @"高素质"];
    for (int i = 0; i < array.count; i ++) {
        YoBaseSelectedCellView *view = [[YoBaseSelectedCellView alloc] initWithFrame:CGRectMake(0, headerHeight * i, SCREEN_WIDTH, headerHeight)];
        view.titleLabel.text = array[i];
        if (i == 1) {
            view.selected = YES;
            self.seletedView = view;
        }
        view.delegate = self;
        [contentView addSubview:view];
    }
    
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    self.modalVc = modalViewController;
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), CGRectGetHeight(containerBounds) - CGRectGetHeight(contentView.frame));
    };
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}



- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"写真集";
}


@end
