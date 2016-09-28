//
//  ModifyViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "ModifyViewController.h"
#import "JKCountDownButton.h"
#import "EditKeyViewController.h"

@interface ModifyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIView *phoneLiveView;
@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (copy, nonatomic) NSString *codeString;//验证码
@property (copy, nonatomic) NSString *expireTime;//验证码过期时间

@end

@implementation ModifyViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"找回密码"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(_nextBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_sendBtn, 3.f, 1, hexColor(999999));

    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeText.keyboardType  = UIKeyboardTypeNumberPad;
    self.phoneText.delegate = self;
    self.codeText.delegate = self;
    self.phoneText.tag = 2888;
    self.codeText.tag = 2887;
    
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
    if (textField.tag == 2888) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11 ];
        }
        if (textField.text.length >0) {
            self.phoneImgView.image = kGetImage(@"icon_phone_active");
            self.phoneLiveView.backgroundColor = hexColor(F8B62A);
        }else {
            self.phoneImgView.image = kGetImage(@"icon_phone_no");
            self.phoneLiveView.backgroundColor = hexColor(999999);
        }
    }else {
        if (textField.text.length >0) {
            self.codeImgView.image = kGetImage(@"icon_code_active");
            self.codeLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.codeImgView.image = kGetImage(@"icon_code");
            self.codeLineView.backgroundColor = hexColor(999999);
        }
    }
}

#pragma mark - event response

- (IBAction)sendCodeEvent:(id)sender {WEAKSELF;
    [self dismissKeyBoard];
    
    if (_phoneText.text.length == 11  && [QZManager isPureInt:_phoneText.text] == YES)
    {
        
        [APIRequest rcheckUserByPhoneWithPhone:_phoneText.text RequestSuccess:^{
            
            /*********************发送短信***********************************/
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SENDUPDATEPASSWORD];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneText.text,@"phone", nil];
            [APIRequest sendSMStWithURLString:urlString withDictionary:dict RequestSuccess:^(NSString *code, NSString *expireTime) {
                
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

        } fail:^{
            
        }];
    }
}

- (IBAction)nextStepEvent:(id)sender {
    
    [self dismissKeyBoard];
    DLog(@"下一步");
    if (_phoneText.text.length<=0) {
        [JKPromptView showWithImageName:nil message:@"请您检查手机号码是否填写"];
        return;
    }else if (_codeText.text.length ==0){
        [JKPromptView showWithImageName:nil message:@"请您检查验证码是否填写"];
        return;
    }else if (![_codeText.text isEqualToString:_codeString]){
        
        [JKPromptView showWithImageName:nil message:@"验证码错误"];
        return;
    }else if ([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[_expireTime doubleValue]]] == 1){
        
        [JKPromptView showWithImageName:nil message:@"验证码已失效，请您重新获取"];
        return;
    }
    EditKeyViewController *vc = [EditKeyViewController new];
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
