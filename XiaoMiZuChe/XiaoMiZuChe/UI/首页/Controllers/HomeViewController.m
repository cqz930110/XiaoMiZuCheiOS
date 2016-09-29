//
//  HomeViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "GcNoticeUtil.h"
#import "CustomMenuBtn.h"
#import "HandleCarViewController.h"
#import "XMAlertView.h"
#import "UIWebView+Load.h"
#import "carRecord.h"

#define BUTTONWITH    ([UIScreen mainScreen].bounds.size.width - 1.2f)/3.f
#define kMenuButtonBaseTag 7700

@interface HomeViewController ()<XMAlertViewPro>

@property (nonatomic, strong) CustomMenuBtn *handleCardBtn;//办卡
@property (nonatomic, strong) CustomMenuBtn *applydBtn;//申请用车
@property (nonatomic, strong) CustomMenuBtn *repayCarBtn;//还车
@property (nonatomic, strong) UIView *topLineView;//顶部的线
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HomeViewController

#pragma mark - life cycle
-(void)dealloc
{
    [GcNoticeUtil removeNotification:DECIDEISLOGIN
                            Observer:self
                              Object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"共享电动车"];
    self.view.backgroundColor = [UIColor whiteColor];

    [GcNoticeUtil handleNotification:DECIDEISLOGIN
                                Selector:@selector(autoLoginSuccessMethods)
                                Observer:self];
    
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.topLineView];
    [self.view addSubview:self.handleCardBtn];
    [self.view addSubview:self.applydBtn];
    [self.view addSubview:self.repayCarBtn];

}
#pragma mark - 通知
- (void)autoLoginSuccessMethods
{
    if ([PublicFunction shareInstance].m_bLogin == NO) {
        [self setupNaviBarWithBtn:NaviRightBtn title:@"登录" img:nil];
        [self.rightBtn setTitleColor:hexColor(F8B62A) forState:0];
        self.rightBtn.titleLabel.font = Font_15;
        [_handleCardBtn setTitle:@"办理租车卡" forState:0];

    }else {
        [self.rightBtn setTitle:@"" forState:0];
        [_handleCardBtn setTitle:@"我的租车卡" forState:0];

    }
}
#pragma mark - event respose
- (void)rightBtnAction
{
    if ([PublicFunction shareInstance].m_bLogin == YES) {
        [self.rightBtn setTitle:@"" forState:0];
        self.rightBtn = nil;
        return;
    }
    LoginViewController *loginVC = [LoginViewController new];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
}
- (void)selectdBtnEvent:(CustomMenuBtn *)btn
{
    NSInteger index = btn.tag - kMenuButtonBaseTag;
    switch (index) {
        case 1:
        {
            HandleCarViewController *vc = [HandleCarViewController new];
            [self.navigationController   pushViewController:vc animated:YES];
            
        }
            break;
        case 2:
        {
            self.tabBarController.selectedIndex = 1;
        }
            break;
        case 3:
        {
            if ([PublicFunction shareInstance].m_bLogin == NO) {
                [JKPromptView showWithImageName:nil message:@"请您先登录账号,再进行还车"];
                return;
            }
            
            if ([PublicFunction shareInstance].m_user.carRecord.expectEndTime.length >0) {
                
                UIWindow *window = [QZManager getWindow];
                XMAlertView *alertView = [[XMAlertView alloc] initWithVerificationCodeWithStyle:XMAlertViewStyleVerCode];
                alertView.delegate = self;
                [window addSubview:alertView];

            }else {
                
                [JKPromptView showWithImageName:nil message:@"您没有未还车辆"];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -  XMAlertViewPro
- (void)xMalertView:(XMAlertView *)alertView withClickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [APIRequest getUserCarRecordRequestSuccess:^{
//        
//    } fail:^{
//        
//    }];
    
    if (buttonIndex == 1) {
        
        [APIRequest backCarEventWithForce:@"1" RequestSuccess:^{
            
        } fail:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统检测到电动车未归还到指定车棚！是否执行强制换车？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 10099;
            [alertView show];
        }];
    }
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10099 && buttonIndex == 1){
        
        [APIRequest backCarEventWithForce:@"2" RequestSuccess:^{
            
            [PublicFunction shareInstance].m_user.carRecord = nil;
        } fail:^{
        }];
    }
}

#pragma mark - getters and setters
- (CustomMenuBtn *)handleCardBtn
{
    if (!_handleCardBtn) {
       _handleCardBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _handleCardBtn.frame = CGRectMake(0, kMainScreenHeight - 149.f, BUTTONWITH, 100);
        [_handleCardBtn setImage:kGetImage(@"bg_manage_card") forState:0];
        [_handleCardBtn setTitle:@"办理租车卡" forState:0];
        [_handleCardBtn setTag:1 + kMenuButtonBaseTag];
        [_handleCardBtn setTitleColor:hexColor(333333) forState:0];
        [_handleCardBtn addTarget:self action:@selector(selectdBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_handleCardBtn.frame.size.width - 0.6f, 15, .6f, _handleCardBtn.frame.size.height - 30.f)];
        lineView.backgroundColor = LINECOLOR;
        [_handleCardBtn addSubview:lineView];
    }
    return _handleCardBtn;
}
- (CustomMenuBtn *)applydBtn
{
    if (!_applydBtn) {
        _applydBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _applydBtn.frame = CGRectMake(BUTTONWITH , kMainScreenHeight - 149.f, BUTTONWITH, 100);
        [_applydBtn setImage:kGetImage(@"bg_hire_car") forState:0];
        [_applydBtn setTitle:@"申请用车" forState:0];
        [_applydBtn setTag:2 + kMenuButtonBaseTag];
        [_applydBtn setTitleColor:hexColor(333333) forState:0];
        [_applydBtn addTarget:self action:@selector(selectdBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_applydBtn.frame.size.width - 0.6f, 15, .6f, _applydBtn.frame.size.height - 30.f)];
        lineView.backgroundColor = LINECOLOR;
        [_applydBtn addSubview:lineView];

    }
    return _applydBtn;
}
- (CustomMenuBtn *)repayCarBtn
{
    if (!_repayCarBtn) {
        _repayCarBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _repayCarBtn.frame = CGRectMake(1.2f+ 2*BUTTONWITH , kMainScreenHeight - 149.f, BUTTONWITH, 100);
        [_repayCarBtn setTag:3 + kMenuButtonBaseTag];
        [_repayCarBtn setImage:kGetImage(@"bg_back_car") forState:0];
        [_repayCarBtn setTitle:@"还车" forState:0];
        [_repayCarBtn setTitleColor:hexColor(333333) forState:0];
        [_repayCarBtn addTarget:self action:@selector(selectdBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayCarBtn;
}
- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 149.6f, kMainScreenWidth, .6f)];
        _topLineView.backgroundColor = LINECOLOR;
    }
    return _topLineView;
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView.backgroundColor = [UIColor whiteColor];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-213.6)];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;//禁止用户缩放页面
        [_webView loadURL:@"http://api.xiaomiddc.com/app/h5/service_descrip.html"];
        [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
    }
    return _webView;
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
