//
//  YoTestViewController.m
//  Yoyo
//
//  Created by ningcol on 2019/8/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoTestViewController.h"

#import "YoMineHeaderView.h"

#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"
#import "UIImageEffects.h"

static CGFloat const kCellHeight = 50;
static CGFloat const kMaxScrollContentSizeY = 480;
static CGFloat const kTableViewContentOffsetY = 100;



@interface YoTestViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *backImageView;
@property(nonatomic, strong) UIImageView *blurredDimmingView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) CGFloat headerViewHeight;
@end

@implementation YoTestViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.view.backgroundColor = UIColorBlue;
    self.headerViewHeight = 200;
    
   
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewHeight)];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    NSString *url = @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg";
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
//    self.backImageView.image = UIImageMake(@"icon_auth_man");
    [self.view addSubview:self.backImageView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorClear;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kTableViewContentOffsetY, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kTableViewContentOffsetY);
    
    
    UIImage *blurredBackgroundImage = [UIImage qmui_imageWithView:self.backImageView];
    blurredBackgroundImage = [UIImageEffects imageByApplyingTintEffectWithColor:UIColorMakeWithRGBA(102, 69, 251, 0.5) toImage:blurredBackgroundImage];
    self.blurredDimmingView = [[UIImageView alloc] initWithImage:blurredBackgroundImage];
    self.blurredDimmingView.frame = self.backImageView.bounds;
    
    
    [self.backImageView addSubview:self.blurredDimmingView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.blurredDimmingView.frame = self.backImageView.bounds;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 控制表头图片的放大
    JSLogInfo(@"-----:%f",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat width = self.view.frame.size.width;
    CGRect frame = self.backImageView.frame;
    
    CGFloat offset = kTableViewContentOffsetY + self.qmui_navigationBarMaxYInViewCoordinator;
    
    if (offsetY < -offset) {
        // 向下拉
        frame.size.height = (self.headerViewHeight + ABS(offsetY) -offset)>kMaxScrollContentSizeY ? kMaxScrollContentSizeY:(self.headerViewHeight + ABS(offsetY) -offset);
        frame.origin.y = 0;//及时归零
        
        CGFloat f = (self.headerViewHeight + ABS(offsetY) - offset) / self.headerViewHeight;//缩放比
        //拉伸后的图片的frame应该是同比例缩放。
        frame =  CGRectMake(- (width * f - width) / 2, 0, width * f, (self.headerViewHeight + ABS(offsetY) -offset));
        self.backImageView.frame = frame;
    }else{
        // 复原
        self.backImageView.y = 0;
        self.backImageView.height = 200;
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 9;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (indexPath.section == 0){
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"444";
        return cell;
        
    } else {
        if (!cell) {
            cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = UIColorBlackFont;
        }
        if (indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"icon_mine_menu_store"];
            cell.textLabel.text = @"我的店铺";
            CGFloat margin = 40;
            QMUILabel *subTitleLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(self.tableView.qmui_width - 200 - margin, 0, 200, kCellHeight)];
            subTitleLabel.text = @"1个店铺";
            subTitleLabel.font = UIFontMake(14);
            subTitleLabel.textAlignment = NSTextAlignmentRight;
            subTitleLabel.textColor = UIColorGrayFont;
            [cell.contentView addSubview:subTitleLabel];
        } else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"icon_mine_menu_member"];
            cell.textLabel.text = @"会员中心";
        } else if (indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"icon_mine_menu_help"];
            cell.textLabel.text = @"帮助与反馈";
        } else {
            cell.imageView.image = [UIImage imageNamed:@"icon_mine_menu_help"];
            cell.textLabel.text = @"帮助与反馈";
        }
        UIImageView *arrowsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kCellHeight - 20)/2, 12, 20)];
        arrowsView.image = UIImageMake(@"icon_mine_arrows");
        cell.accessoryView = arrowsView;
        
        cell.imageEdgeInsets = UIEdgeInsetsZero;
        cell.textLabelEdgeInsets = UIEdgeInsetsZero;
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
        cell.accessoryEdgeInsets = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 180;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 12;
    }
}


#pragma mark - QMUINavigationControllerAppearanceDelegate
- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:UIColorClear];;
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:UIColorClear size:CGSizeMake(4, PixelOne) cornerRadius:0];;
}

- (UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>
- (NSString *)customNavigationBarTransitionKey {
    return @"YoMineViewController";
}


@end
