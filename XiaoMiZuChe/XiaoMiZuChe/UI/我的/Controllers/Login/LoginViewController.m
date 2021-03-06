//
//  LoginViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterController.h"
#import "NSString+MHCommon.h"
#import "ModifyViewController.h"
#import "GcNoticeUtil.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *nameImgView;
@property (weak, nonatomic) IBOutlet UIImageView *keyImgView;

@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;
@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)dealloc
{
    [GcNoticeUtil removeAllNotification:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LRViewBorderRadius(_loginBtn, 5.f, 0, [UIColor whiteColor]);

    self.phoneText.delegate = self;
    self.codeText.delegate  = self;
    self.phoneText.tag = 2889;
    self.codeText.tag  = 2890;
    self.codeText.secureTextEntry = YES;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.codeText];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return true;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    if (textField.tag == 2889) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11 ];
        }
        if (textField.text.length >0) {
            self.nameImgView.image = kGetImage(@"icon_id_active");
            self.phoneLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.nameImgView.image = kGetImage(@"icon_menu_my");
            self.phoneLineView.backgroundColor = hexColor(999999);
        }
    }else {
        if (textField.text.length >0) {
            self.keyImgView.image = kGetImage(@"icon_pass_active");
            self.codeLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.keyImgView.image = kGetImage(@"icon_pass");
            self.codeLineView.backgroundColor = hexColor(999999);
        }
    }

}

#pragma mark - getters and setters

#pragma mark - event respose
- (void)leftBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)registerBtnEvent:(id)sender {
    
    RegisterController *vc = [RegisterController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginBtnEvent:(id)sender {
    [self dismissKeyBoard];
    
    if (_phoneText.text.length == 0) {
        
        [JKPromptView showWithImageName:nil message:@"请您填写手机号码/租车卡号"];
        return;
    }else if (_codeText.text.length == 0){
        
        [JKPromptView showWithImageName:nil message:@"请您输入密码"];
        return;
    }
    
    WEAKSELF;
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceUDID = [[device identifierForVendor] UUIDString];
    DLog(@"设备标识符:%@",deviceUDID);
    NSString *tempStr = [deviceUDID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *aliasString = [tempStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [APIRequest checkLoginUserWithLoginName:_phoneText.text withpassword:[_codeText.text md5] withclientId:aliasString withplatform:[NSString stringWithFormat:@"iOS%@",device.systemVersion] RequestSuccess:^{

        
        [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];

        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    } fail:^{
    }];
}
- (IBAction)forgetBtnEvent:(id)sender {
    
    ModifyViewController *vc = [ModifyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
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
