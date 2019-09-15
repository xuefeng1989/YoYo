//
//  YoWithDrawRulesViewController.m
//  Yoyo
//
//  Created by ningcol on 2019/7/22.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoWithDrawRulesViewController.h"

#import <Masonry.h>

@interface YoWithDrawRulesViewController ()
@property(nonatomic, strong) QMUILabel *titleLabel;
@end

@implementation YoWithDrawRulesViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.titleLabel = [[QMUILabel alloc] init];
    self.titleLabel.text = @"欢迎阅读提现规则";
    self.titleLabel.textColor = UIColorBlackFont;
    self.titleLabel.font = UIFontBoldMake(16);
    
    [self.tableView addSubview:self.titleLabel];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView).offset(15);
        make.top.equalTo(self.tableView).offset(20);
    }];
}



- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"提现规则";
}
@end
