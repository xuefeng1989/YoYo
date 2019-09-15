//
//  YoUserProtocolViewController.m
//  Yoyo
//
//  Created by ningcol on 2019/7/24.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoUserProtocolViewController.h"

#import <Masonry.h>
#import "NSString+Extension.h"


@interface YoUserProtocolViewController ()
@property(nonatomic, strong) QMUILabel *contentLabel;
@end

@implementation YoUserProtocolViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.contentLabel = [[QMUILabel alloc] init];
    self.contentLabel.text = @"你好： 感谢阅读和遵守平台的提现规则，我是“小面”很荣幸能帮到你。 提现规则如下： 满足以下条件 首先你必须是认证的 在本月收益期间未收到任何投诉 你要有支付宝账号（平台只接受支付宝转账） 每天要有一条广播发送（平台会核验你的广播发送达标） 每月要有5个写真集发发布（平台会核验你的写真集发 布达标） 相册至少要上传5张照片 满足以上条件的情况下，平台会在每个月度周期结束后的1-7天内通过支付宝结算至你的支付宝账户（释：提现每月一次，上个月的所有收益会在下月1-7天内完成结算，第一次结算后会告知下一次结算时间，具体到几号） 提现开放时间： 提现开放时间为每月1-5号，如果你未在规定时间内提现，系统会默认下月提现 结算额度的计算： 因为本平台使用的是苹果支付，所以每一比比交易苹果会收取30%的手续费（释：如果你当月收益为";
    self.contentLabel.textColor = UIColorBlackFont;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = UIFontMake(14);
    
    [self.tableView addSubview:self.contentLabel];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize labelSize = [self.contentLabel.text sizeWithFont:14 maxW:SCREEN_WIDTH];
    self.contentLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, labelSize.height);
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"用户协议";
}


@end
