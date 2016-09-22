//
//  MineViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineSettingVC.h"
#import "LCActionSheet.h"
#import "AboutViewController.h"
#import "GcNoticeUtil.h"
#import "ServiceViewController.h"
#import "HandleCarViewController.h"
#import "LoginViewController.h"

static NSString *const MINECELLIDENTIFER = @"mineCellIdentifer";
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIButton *logOutBtn;
@property (strong,nonatomic) UIView *footView;
@property (nonatomic, strong) UIWebView *callPhoneWebView;

@end

@implementation MineViewController
-(void)dealloc
{
    [GcNoticeUtil removeAllNotification:self];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    ([PublicFunction shareInstance].m_bLogin == NO)?[self.footView setHidden:YES]:[self.footView setHidden:NO];

}
#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"我的"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.footView addSubview:self.logOutBtn];
    self.tableView.tableFooterView = self.footView;
    
    [GcNoticeUtil handleNotification:LOGINSUCCESS
                            Selector:@selector(LoginSuccessMethods)
                            Observer:self];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = (MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MINECELLIDENTIFER   ];
    [cell settingCellStyle:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?95.f:44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 0) {
        if ([PublicFunction shareInstance].m_bLogin == YES) {
            MineSettingVC *vc = [MineSettingVC new];
            [self.navigationController  pushViewController:vc animated:YES];
        }else {
            LoginViewController *loginVC = [LoginViewController new];
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
        }
    }else if (row == 4) {
        AboutViewController *vc = [AboutViewController new];
        [self.navigationController  pushViewController:vc animated:YES];
    }else if (row == 3) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"0531-67805000"]]];
        [self.callPhoneWebView loadRequest:request];
    }else if (row == 2){
        ServiceViewController *vc = [ServiceViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row == 1){
        HandleCarViewController *vc = [HandleCarViewController new];
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
#pragma mark - event response
- (void)LoginSuccessMethods
{
    DLog(@"登录成功");
    self.footView.hidden = NO;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)logOutBtnEvent:(UIButton *)btn
{WEAKSELF;
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"退出账号" buttonTitles:@[@"退出"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0){
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@?userId=%@",kProjectBaseUrl,LOGOUTURLSTRING,[PublicFunction shareInstance].m_user.userId];
            [APIRequest getLogoutWithURLString:urlString RequestSuccess:^{
                
                DLog(@"退出登录");
                [USER_D removeObjectForKey:USERNAME];
                [USER_D removeObjectForKey:USERKEY];
                [USER_D synchronize];
                [PublicFunction shareInstance].m_bLogin = NO;
                [PublicFunction shareInstance].m_user = nil;

                [GcNoticeUtil sendNotification:DECIDEISLOGIN];
                
                [UIView animateWithDuration:0.35f animations:^{
                    
                    weakSelf.tabBarController.selectedIndex = 0;
                }];
                
            } fail:^{
            }];
        }
    }];
    [sheet show];
    
}
#pragma mark - setters and getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 109.f) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:MINECELLIDENTIFER];
    }
    return _tableView;
}
- (UIButton *)logOutBtn
{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 44.f);
        [_logOutBtn setImage:kGetImage(@"icon_logout") forState:0];
        [_logOutBtn setTitle:@"退出登录" forState:0];
        [_logOutBtn setTitleColor:hexColor(333333) forState:0];
        [_logOutBtn addTarget:self action:@selector(logOutBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        _logOutBtn.backgroundColor = [UIColor whiteColor];
        _logOutBtn.titleLabel.font = Font_15;
    }
    return _logOutBtn;
}
- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44.6f)];
        _footView.backgroundColor = LINECOLOR;
    }
    return _footView;
}
#pragma mark -打电话
- (UIWebView *)callPhoneWebView {
    if (!_callPhoneWebView) {
        _callPhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _callPhoneWebView;
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
