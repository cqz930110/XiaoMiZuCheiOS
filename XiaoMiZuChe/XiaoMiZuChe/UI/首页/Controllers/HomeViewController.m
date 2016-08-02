//
//  HomeViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface HomeViewController ()
@property (nonatomic, assign) UIImageView *bgview;

@end

@implementation HomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"小米租车"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"登录" img:nil];
    [self.rightBtn setTitleColor:hexColor(F08200) forState:0];
    self.rightBtn.titleLabel.font = Font_15;
    
}
#pragma mark - getters and setters
#pragma mark - event respose
- (void)rightBtnAction
{
    LoginViewController *loginVC = [LoginViewController new];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
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
