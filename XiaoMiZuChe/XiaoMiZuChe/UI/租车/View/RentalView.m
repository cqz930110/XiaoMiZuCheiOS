//
//  RentalView.m
//  XiaoMiZuChe
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "RentalView.h"
#import "JKCountDownButton.h"
#import "GPSMapViewController.h"
#import "LoginViewController.h"

@interface RentalView()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UITextField *carText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *immBtn;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearBtn;
@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;
@property (nonatomic, strong) UIViewController *superViewController;

@end
@implementation RentalView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (RentalView *)instanceRentalViewWithViewController:(UIViewController *)superViewController
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RentalView" owner:self options:nil];
    RentalView *detailView = [nibView objectAtIndex:0];
    detailView.frame = CGRectMake(0, 64, 320, kMainScreenHeight - 64.f);
    [detailView initUIWithViewController:superViewController];
    return detailView;
}
- (void)initUIWithViewController:(UIViewController *)superViewController{
    
    _superViewController = superViewController;
    LRViewBorderRadius(_immBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_nearBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_sendCodeBtn, 3.f, 1, hexColor(999999));
    
    
    [self.nearBtn setBackgroundImage:kGetImage(@"btn_around_car") forState:UIControlStateNormal];
    [self.nearBtn setBackgroundImage:kGetImage(@"btn_around_car") forState:UIControlStateSelected];
    
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.carText.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneText.delegate = self;
    self.carText.delegate = self;
    self.phoneText.tag = 3888;
    self.carText.tag = 3887;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.carText];

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
    if (textField.tag == 3888) {
        if (textField.text.length >0) {
            self.phoneImgView.image = kGetImage(@"icon_code_active");
            self.phoneLineView.backgroundColor = hexColor(F08200);
        }else {
            self.phoneImgView.image = kGetImage(@"icon_code");
            self.phoneLineView.backgroundColor = hexColor(999999);
        }
    }else {
        if (textField.text.length >0) {
            self.carImgView.image = kGetImage(@"icon_ebike_active");
            self.codeLineView.backgroundColor = hexColor(F08200);
        }else {
            self.carImgView.image = kGetImage(@"icon_ebike");
            self.codeLineView.backgroundColor = hexColor(999999);
        }
    }
}


#pragma mark - event response
- (IBAction)sendCodeButtonEvent:(JKCountDownButton *)sender {
    
    [self dismissKeyBoard];
    /*********************发送短信***********************************/
    sender.enabled = NO;
    [sender startCountDownWithSecond:60];
    [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zd秒",second];
        return title;
    }];
    [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
}

- (IBAction)applyImmediatelyBtnEvent:(UIButton *)sender {
    [self dismissKeyBoard];
    
    
    if ([PublicFunction shareInstance].m_bLogin == YES) {
        if (_carText.text.length<=0) {
            [JKPromptView showWithImageName:nil message:@"请输入车辆编号"];
            return;
        }else if (_phoneText.text.length <=0){
            [JKPromptView showWithImageName:nil message:@"请输入收到的验证码"];
            return;
        }
        
    }else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录，再进行租车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertView show];
    }
    
    DLog(@"立即申请");
}

- (IBAction)nearTheVehicleBtnEvent:(UIButton *)sender {
    DLog(@"附近车辆");
    [self dismissKeyBoard];
    GPSMapViewController *gpsVC = [GPSMapViewController new];
    [_superViewController.navigationController pushViewController:gpsVC animated:YES];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *loginVC = [LoginViewController new];
        [_superViewController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
    }
}
#pragma mark - getters and setters
#pragma mark -手势
- (void)dismissKeyBoard{
    [self endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
