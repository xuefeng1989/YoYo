//
//  RechargeVC.m
//  Yoyo
//
//  Created by ningcol on 2019/7/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "RechargeVC.h"
#import "YoCreatOrderService.h"
#import "YoVIPConfigService.h"
#import "YoConfigVipModel.h"
@interface RechargeVC () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property(nonatomic, strong) NSMutableArray *netDataArray;
@end

@implementation RechargeVC
- (NSMutableArray *)netDataArray
{
    if (!_netDataArray) {
        _netDataArray = [NSMutableArray array];
    }
    return _netDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void)buy:(NSString *)productIdentifier {
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:productIdentifier];
    } else {
//        [self showMessage:@"用户禁止应用内付费购买"];
    }
}

// 从Apple查询用户点击购买的产品的信息
- (void)getProductInfo:(NSString *)productIdentifier {
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    [QMUITips showLoading:@"正在购买，请稍后" inView:self.view];
}

// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [QMUITips hideAllTipsInView:self.view];
    NSArray *myProduct = response.products;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
    }
    if (myProduct.count == 0) {
        [QMUITips showError:@"无法获取产品信息，请重试" inView:self.view];

        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [QMUITips hideAllTipsInView:self.view];
    [QMUITips showError:[error localizedDescription] inView:self.view];
}

// 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [QMUITips hideAllTipsInView:self.view];
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
//                self.receipt = [GTMBase64 stringByEncodingData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]]];
                [self checkReceiptIsValid]; //把self.receipt发送到服务器验证是否有效
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [QMUITips showInfo:@"恢复购买成功" inView:self.view];
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                [QMUITips showInfo:@"正在请求付费信息，请稍后" inView:self.view];

                break;
                
            default:
                break;
        }
    }
    
}

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建请求到苹果官方进行购买验证
    NSURL *url = [NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
//        [[CoreDataOperations sharedInstance] buyNoAds];
        [self.tableView reloadData];
        
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:@"123"]) {
            int purchasedCount = [defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"购买失败，请重试"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alertView show];
    } else {
        [QMUITips showInfo:@"用户取消交易" inView:self.view];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)setOrderType:(NSString *)orderType
{
    _orderType = orderType;
    YoVIPConfigService *service = [[YoVIPConfigService alloc] init];
    service.configType = orderType;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject objectForKey:@"result"];
        NSArray *dataList = data[@"list"];
        for (NSDictionary *dic  in dataList) {
            YoConfigVipModel *model = [[YoConfigVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.netDataArray addObject:model];
        }
    } failure:^(JSError *error) {
        NSLog(@" ***error %@  *** ",error);
    }];
}


- (void)checkReceiptIsValid{
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    JSLogInfo(@"receiptString:%@", receiptString);
    
    YoCreatOrderService *service = [[YoCreatOrderService alloc] init];
    service.requestType = YoCreatOrderServiceOrderCreate;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:YoUserDefault.userNo forKey:@"toUserNo"];
    [dic setObject:@"BUY_COIN" forKey:@"orderType"];
    [dic setObject:receiptString forKey:@"data"];
    if (self.netDataArray && self.netDataArray.count > 0) {
        YoConfigVipModel *model = [self.netDataArray firstObject];
         [dic setObject:model.dictCode forKey:@"dictCode"];
    }
    service.params = dic;
    __weak __typeof(self)weakSelf = self;
    [service js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QMUITips showSucceed:@"支付成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(JSError *error) {
        [QMUITips showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
}


-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    //解除监听
}

@end
