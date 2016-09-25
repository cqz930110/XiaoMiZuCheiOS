//
//  RegisterController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/7/23.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "RegisterController.h"
#import "JKCountDownButton.h"
#import "PerfectInformationVC.h"
#import "NSString+MHCommon.h"
#import "GcNoticeUtil.h"
#import "FCUUID.h"
#import "ServiceViewController.h"

@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *keyImgView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UIView *phoneLineView;
@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (weak, nonatomic) IBOutlet UIView *keyLineView;
@property (copy, nonatomic) NSString *codeString;//验证码
@property (copy, nonatomic) NSString *expireTime;//验证码过期时间

@property (assign, nonatomic) BOOL isAgree;//是否同意
@end

@implementation RegisterController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
#pragma mark -private methods
- (void)initUI{
    
    _isAgree = YES;
    [self setupNaviBarWithTitle:@"注册会员"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(_nextBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_sendCodeBtn, 3.f, 1, hexColor(999999));
    self.phoneText.delegate = self;
    self.codeText.delegate  = self;
    self.keyText.delegate   = self;
    self.phoneText.tag      = 2015;
    self.codeText.tag       = 2016;
    self.keyText.tag        = 2017;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeText.keyboardType  = UIKeyboardTypeNumberPad;
    self.keyText.secureTextEntry = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.codeText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.keyText];
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
    if (textField.tag == 2015) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11 ];
        }
        if (textField.text.length >0) {
            self.phoneImgView.image = kGetImage(@"icon_phone_active");
            self.phoneLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.phoneImgView.image = kGetImage(@"icon_phone_no");
            self.phoneLineView.backgroundColor = hexColor(999999);
        }

    }else if (textField.tag == 2016){
        if (textField.text.length >0) {
            self.codeImgView.image = kGetImage(@"icon_code_active");
            self.codeLineView.backgroundColor = hexColor(F8B62A);

        }else {
            self.codeImgView.image = kGetImage(@"icon_code");
            self.codeLineView.backgroundColor = hexColor(999999);

        }
    }else if (textField.tag == 2017){
        if (textField.text.length >0) {
            self.keyImgView.image = kGetImage(@"icon_pass_active");
            self.keyLineView.backgroundColor = hexColor(F8B62A);

        }else {
            self.keyImgView.image = kGetImage(@"icon_pass");
            self.keyLineView.backgroundColor = hexColor(999999);

        }
    }
}

#pragma mark -getters and setters

#pragma mark - event response
- (IBAction)sendCodeBtnEvent:(id)sender {WEAKSELF;
    [self dismissKeyBoard];
    
    if (_phoneText.text.length == 11  && [QZManager isPureInt:_phoneText.text] == YES)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SENDREGISTERCODEURL];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneText.text,@"phone", nil];

        [APIRequest sendSMStWithURLString:urlString withDictionary:dict RequestSuccess:^(NSString *code, NSString *expireTime){
            
            weakSelf.codeString = code;
            weakSelf.expireTime = expireTime;
            JKCountDownButton *btn = (JKCountDownButton *)sender;
            btn.enabled = NO;
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];

            
        } fail:^{
            
        }];
        
    }
//    [SMSSDK getVerificationCodeBySMSWithPhone:@"13162079587" zone:@"86" result:^(NSError *error) {
//        DLog(@"error---%@",error);
//        
//    }];

}
- (IBAction)nextBtnEvent:(id)sender {
    [self dismissKeyBoard];
    DLog(@"下一步");
    if (_isAgree == NO) {
        
        [JKPromptView showWithImageName:nil message:@"请同意服务条款后继续操作"];
        return;
    }
    
    if (_phoneText.text.length<=0) {
        [JKPromptView showWithImageName:nil message:@"请您检查手机号码是否填写"];
        return;
    }else if (_keyText.text.length <=0){
        [JKPromptView showWithImageName:nil message:@"请您检查密码是否填写"];
        return;
    }else if(_codeText.text.length <=0){
        [JKPromptView showWithImageName:nil message:@"请您检查验证码是否填写"];
        return;
    }else if (![_codeText.text isEqualToString:_codeString]){
        
        [JKPromptView showWithImageName:nil message:@"验证码错误"];
        return;
    }else if ([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[_expireTime doubleValue]]] == 1){
        
        [JKPromptView showWithImageName:nil message:@"验证码已失效，请您重新获取"];
        return;
    }else if ([QZManager isValidatePassword:_keyText.text] == NO)
    {
        [JKPromptView showWithImageName:nil message:@"密码为6-16位数字和字母组合，请您仔细检查"];
        return;
    }else if ([QZManager isIncludeSpecialCharact:_keyText.text]){
        [JKPromptView showWithImageName:nil message:@"密码中包含非法字符，请您检查"];
        return;
    }

    
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceUDID = [FCUUID uuid];
    DLog(@"设备标识符:%@",deviceUDID);
    NSString *tempStr = [deviceUDID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *aliasString = [APIRequest trimStringUUID:(NSMutableString *)tempStr];
    
    [APIRequest registerUserWithPhone:_phoneText.text withpassword:[_keyText.text md5] withclientId:aliasString withplatform:[NSString stringWithFormat:@"iOS%@",device.systemVersion] RequestSuccess:^(NSMutableDictionary *dict) {
        
        PerfectInformationVC *vc = [PerfectInformationVC new];
        [self.navigationController pushViewController:vc animated:YES];

    } fail:^{
    }];
    
    PerfectInformationVC *vc = [PerfectInformationVC new];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)agreeORNOagreeEvent:(UIButton *)sender {
    
    _isAgree  = !_isAgree;
    
    if (_isAgree == YES) {
        
        [_agreeBtn setImage:kGetImage(@"icon_circle_sel") forState:0];
    }else {
        [_agreeBtn setImage:kGetImage(@"icon_circle_nosel") forState:0];
    }
    
}

- (IBAction)lookAtTheTermsOfService:(UIButton *)sender {
    
    ServiceViewController *vc = [ServiceViewController new];
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
