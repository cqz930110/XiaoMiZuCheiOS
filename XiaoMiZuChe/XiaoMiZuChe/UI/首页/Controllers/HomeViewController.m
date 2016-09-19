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
#define BUTTONWITH    ([UIScreen mainScreen].bounds.size.width - 1.2f)/3.f
#define kMenuButtonBaseTag 7700

@interface HomeViewController ()<XMAlertViewPro>

@property (nonatomic, strong) CustomMenuBtn *handleCardBtn;//办卡
@property (nonatomic, strong) CustomMenuBtn *applydBtn;//申请用车
@property (nonatomic, strong) CustomMenuBtn *repayCarBtn;//还车
@property (nonatomic, strong) UIView *topLineView;//顶部的线

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
        [self.rightBtn setTitleColor:hexColor(F08200) forState:0];
        self.rightBtn.titleLabel.font = Font_15;
    }else {
        [self.rightBtn setTitle:@"" forState:0];
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
            
            UIWindow *window = [QZManager getWindow];
            XMAlertView *alertView = [[XMAlertView alloc] initWithVerificationCodeWithStyle:XMAlertViewStyleVerCode];
            alertView.delegate = self;
            [window addSubview:alertView];

        }
            break;
        default:
            break;
    }
}
#pragma mark - 
- (void)alertView:(XMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [APIRequest getUserCarRecordRequestSuccess:^{
//        
//    } fail:^{
//        
//    }];
}
#pragma mark - getters and setters
- (CustomMenuBtn *)handleCardBtn
{
    if (!_handleCardBtn) {
       _handleCardBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
        _handleCardBtn.frame = CGRectMake(0, kMainScreenHeight - 149.f, BUTTONWITH, 100);
        [_handleCardBtn setImage:kGetImage(@"bg_manage_card") forState:0];
        [_handleCardBtn setTitle:@"办租车卡" forState:0];
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
        _applydBtn.frame = CGRectMake(.6f+BUTTONWITH , kMainScreenHeight - 149.f, BUTTONWITH, 100);
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
