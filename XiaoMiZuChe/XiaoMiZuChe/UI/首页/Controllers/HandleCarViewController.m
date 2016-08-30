//
//  HandleCarViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HandleCarViewController.h"
#import "HandleCardView.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "AFNetworking.h"
#import "WXApiRequestHandler.h"

@interface HandleCarViewController ()<HandleCardViewPro>

@property (nonatomic, strong) UIImageView *vipCardImgView;
@property (nonatomic, strong) UIButton *immediatelyBtn;
@property (nonatomic, strong) HandleCardView *payView;

@end

@implementation HandleCarViewController
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_payView);
    TTVIEW_RELEASE_SAFELY(_vipCardImgView);
    TTVIEW_RELEASE_SAFELY(_immediatelyBtn);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBarWithTitle:@"办理租车卡"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];

    [self.view addSubview:self.vipCardImgView];
    [self.view addSubview:self.immediatelyBtn];
    
}
#pragma mark - event respose
- (void)immediatelyToDealWith:(UIButton *)btn
{WEAKSELF;
    DLog(@"立即办理获取年费");
    [APIRequest getVipYearPriceRequestSuccess:^(NSString *moneyString) {
        
        weakSelf.payView = [[HandleCardView alloc] initWithFrame:kMainScreenFrameRect
                                               WithMoney:moneyString];
        weakSelf.payView.delegate = self;
        [self.view addSubview:weakSelf.payView];
        
    } fail:^{
        
    }];
    
}
#pragma mark - HandleCardViewPro
- (void)choiceOfPaymentWithIndex:(NSInteger)index
{
    DLog(@"%ld",index);
    switch (index) {
        case 0:
        {//微信
            [self payMethodsWithWeiXin];
        }
            break;
        case 1:
        {//支付宝
            
            [self getOrderInfoAndPay:@"88888" Withamount:[NSString stringWithFormat:@"%.2f", 0.01]];
        }
            break;
        case 2:
        {//银联
            
        }
            break;

        default:
            break;
    }
}
#pragma mark
#pragma mark - 微信支付
- (void)payMethodsWithWeiXin
{
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }

    
   /*2
    NSMutableDictionary *dataDic = [NSMutableDictionary  dictionary];
    NSMutableString *stamp  = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"partnerid"];
    req.prepayId            = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"prepayid"];
    req.nonceStr            = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"packageValue"];
    req.sign                = [ [dataDic objectForKey:@"callOrderBean"] objectForKey:@"sign"];
    [WXApi sendReq:req];
    */

    /*3
    ////////////  第一步 统一下单
    // 添加商品信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:WeChatAppID forKey:@"appid"];
    [dict setObject:@"PayDemo_WeChatPayTest_body" forKey:@"body"];
    [dict setObject:WeChatMCH_ID forKey:@"mch_id"];
    [dict setObject:[QZManager getRandomString] forKey:@"nonce_str"];
    [dict setObject:WeChatNOTIFY_URL forKey:@"notify_url"];
    [dict setObject:[QZManager getRandomString] forKey:@"out_trade_no"];
    [dict setObject:[QZManager getIPAddress] forKey:@"spbill_create_ip"];
    [dict setObject:@"1" forKey:@"total_fee"];
    [dict setObject:@"APP" forKey:@"trade_type"];
    
    // 签名
    NSDictionary *params = [QZManager partnerSignOrder:dict];
    // 转化成XML格式 引用三方框架XMLDictionary
    NSString *postStr = [params XMLString];
    
    // 调用微信"统一下单"API
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 转换成Dictionary格式
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:responseObject];
        if(dict != nil)
        {
            ////////////  第二步 调起支付接口
            // 添加调起数据
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = WeChatMCH_ID;
            req.prepayId            = [dict objectForKey:@"prepay_id"];
            req.nonceStr            = [dict objectForKey:@"nonce_str"];
            req.timeStamp           = [[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] intValue];
            req.package             = @"Sign=WXPay";
            
            // 添加签名数据并生成签名
            NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
            [rdict setObject:WeChatAppID forKey:@"appid"];
            [rdict setObject:req.partnerId forKey:@"partnerid"];
            [rdict setObject:req.prepayId forKey:@"prepayid"];
            [rdict setObject:req.nonceStr forKey:@"noncestr"];
            [rdict setObject:[NSString stringWithFormat:@"%u",(unsigned int)req.timeStamp] forKey:@"timestamp"];
            [rdict setObject:req.package forKey:@"package"];
            NSDictionary *result = [QZManager partnerSignOrder:rdict];
            req.sign                = [result objectForKey:@"sign"];
            
            // 调起客户端
            [WXApi sendReq:req];
            // 返回结果 在WXApiManager中
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    */

}

#pragma mark -支付宝
- (void)getOrderInfoAndPay:(NSString *)orderNumber Withamount:(NSString *)amountM
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"009999";
    NSString *privateKey = AlipayRSA_PRIVATE;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [Order new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *app_build = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];
    order.version = app_build;
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    order.notify_url = AlipayBackURL;// NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"租车卡年费支付宝支付";//商品描述
    order.biz_content.subject = @"租车卡年费"; //商品标题
    order.biz_content.out_trade_no = orderNumber; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = amountM; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    DLog(@"orderSpec = %@",orderInfo);
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            DLog(@"reslut = %@",resultDic);
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            /*9000:订单支付成功。8000:正在处理中。4000:订单支付失败。6001:用户中途取消。6002:网络连接出错*/
            if (resultStatus == 9000)
            {
                DLog(@"订单编号－－－－－－%@",resultDic[@"out_trade_no"]);
            }
            else
            {
                if (resultStatus == 6001)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还未支付" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    
                }
                if (resultStatus == 6002)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接出错" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                }
            }

        }];
    }

}

    
#pragma mark - getters and setters
- (UIImageView *)vipCardImgView
{
    if (!_vipCardImgView) {
        _vipCardImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 94, kMainScreenWidth -60, (kMainScreenWidth - 60)*170.f/287.f)];
        _vipCardImgView.image = kGetImage(@"pic_vip_card");
    }
    return _vipCardImgView;
}
- (UIButton *)immediatelyBtn
{
    if (!_immediatelyBtn) {
        _immediatelyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyBtn.frame = CGRectMake(30 , Orgin_y(_vipCardImgView) + 30, kMainScreenWidth - 60, 41);
        [_immediatelyBtn setBackgroundColor:hexColor(F08200)];
        [_immediatelyBtn setTitle:@"立即办理" forState:0];
        [_immediatelyBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_immediatelyBtn addTarget:self action:@selector(immediatelyToDealWith:) forControlEvents:UIControlEventTouchUpInside];
        _immediatelyBtn.layer.masksToBounds = YES;
        _immediatelyBtn.layer.cornerRadius = 5.f;
    }
    return _immediatelyBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
