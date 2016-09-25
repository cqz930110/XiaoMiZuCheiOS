//
//  EditKeyViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "EditKeyViewController.h"
#import "NSString+MHCommon.h"

@interface EditKeyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *keyImgView;
@property (weak, nonatomic) IBOutlet UIImageView *sureKeyImgView;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UITextField *sureKeyText;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *keyLineView;
@property (weak, nonatomic) IBOutlet UIView *sureKeyLineView;

@end

@implementation EditKeyViewController
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
    LRViewBorderRadius(_sureBtn, 5.f, 0, [UIColor whiteColor]);

    self.keyText.delegate = self;
    self.sureKeyText.delegate = self;
    self.keyText.tag = 2891;
    self.sureKeyText.tag = 2892;
    self.keyText.secureTextEntry = YES;
    self.sureKeyText.secureTextEntry = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.keyText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.sureKeyText];
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
    if (textField.tag == 2891) {
        
        if (textField.text.length >0) {
            self.keyImgView.image = kGetImage(@"icon_pass_active");
            self.keyLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.keyImgView.image = kGetImage(@"icon_pass");
            self.keyLineView.backgroundColor = hexColor(999999);
        }
    }else {
        if (textField.text.length >0) {
            self.sureKeyImgView.image = kGetImage(@"icon_pass_active");
            self.sureKeyLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.sureKeyImgView.image = kGetImage(@"icon_pass");
            self.sureKeyLineView.backgroundColor = hexColor(999999);
        }
    }
}

#pragma mark - event response
- (IBAction)sureKeyButtonEvent:(id)sender {WEAKSELF;
    [self dismissKeyBoard];
    DLog(@"确定");
    if (_keyText.text.length<=0) {
        [JKPromptView showWithImageName:nil message:@"请您填写密码"];
        return;
    }else if (_sureKeyText.text.length <=0){
        [JKPromptView showWithImageName:nil message:@"请您再次确认密码"];
        return;
    }else if ([QZManager isValidatePassword:_keyText.text] == NO)
    {
        [JKPromptView showWithImageName:nil message:@"密码为6-16位数字和字母组合，请您仔细检查"];
        return;
    }else if ([QZManager isIncludeSpecialCharact:_keyText.text]){
        [JKPromptView showWithImageName:nil message:@"密码中包含非法字符，请您检查"];
        return;
    }
    
    if (![_keyText.text isEqualToString:_sureKeyText.text]) {
        [JKPromptView showWithImageName:nil message:@"两次密码不一致"];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%@",GET([PublicFunction shareInstance].userId)];
    [APIRequest resetPasswordWithuserId:userId withpassword:[_keyText.text  md5] RequestSuccess:^{
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } fail:^{
    }];
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
