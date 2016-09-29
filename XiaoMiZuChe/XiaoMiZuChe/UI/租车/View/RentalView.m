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
#import "HandleCarViewController.h"

@interface RentalView()<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)  UIImageView *carImgView;
@property (strong, nonatomic)  UIImageView *phoneImgView;
@property (strong, nonatomic)  UITextField *carText;
@property (strong, nonatomic)  UITextField *phoneText;
@property (strong, nonatomic)  JKCountDownButton *countDownCode;

@property (strong, nonatomic)  UIButton *immBtn;
@property (strong, nonatomic)  UIButton *nearBtn;
@property (strong, nonatomic)  UIView *codeLineView;
@property (strong, nonatomic)  UIView *phoneLineView;
@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, strong) UIView *xfView;//提醒续费

@property (copy, nonatomic) NSString *codeString;//验证码
@property (copy, nonatomic) NSString *expireTime;//验证码过期时间

@end
@implementation RentalView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initUIWithDelegate:(id<RentalViewDelegate>)delegate withViewController:(UIViewController *)superViewController{
    self = [super initWithFrame:CGRectMake(0, 64, 320, kMainScreenHeight - 64.f)];
    if (self) {
        [self addSubview:self.carText];
        [self addSubview:self.phoneText];
        [self addSubview:self.countDownCode];

        [self addSubview:self.carImgView];
        [self addSubview:self.phoneImgView];

        [self addSubview:self.immBtn];
        [self addSubview:self.nearBtn];
        [self addSubview:self.codeLineView];
        [self addSubview:self.phoneLineView];
        

        if ([PublicFunction shareInstance].m_user.expireTime.length >0) {
            NSDate *fireDate = [QZManager caseDateFromString:[PublicFunction shareInstance].m_user.expireTime];
            if ([QZManager compareOneDay:[NSDate date] withAnotherDay:fireDate] == 1)
            {
                [self addSubview:self.xfView];
                _countDownCode.hidden = YES;
            }
        }
        _superViewController = superViewController;
        _delegate = delegate;
        
    }
    return self;
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
            self.phoneLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.phoneImgView.image = kGetImage(@"icon_code");
            self.phoneLineView.backgroundColor = hexColor(999999);
        }
    }else {
        if (textField.text.length >0) {
            self.carImgView.image = kGetImage(@"icon_ebike_active");
            self.codeLineView.backgroundColor = hexColor(F8B62A);
        }else {
            self.carImgView.image = kGetImage(@"icon_ebike");
            self.codeLineView.backgroundColor = hexColor(999999);
        }
    }
}


#pragma mark - event response
- (void)sendCodeButtonEvent:(JKCountDownButton *)sender
{WEAKSELF;
    
    [self dismissKeyBoard];
    if ([PublicFunction shareInstance].m_bLogin == NO) {
        
        [JKPromptView showWithImageName:nil message:@"请您登陆以后再操作"];
        return;
    }
    if (_carText.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您填写车辆编号"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SENDHIRECARURL];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.phone,@"phone",_carText.text,@"carId", nil];

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

}

- (void)applyImmediatelyBtnEvent:(UIButton *)sender {
    WEAKSELF;
    [self dismissKeyBoard];
    if ([PublicFunction shareInstance].m_bLogin == YES) {
        if (_carText.text.length<=0) {
            [JKPromptView showWithImageName:nil message:@"请您填写车辆编号"];
            return;
        }else if(_phoneText.text.length <=0){
            [JKPromptView showWithImageName:nil message:@"请您检查验证码是否填写"];
            return;
        }else if (![_phoneText.text isEqualToString:_codeString]){
            
            [JKPromptView showWithImageName:nil message:@"验证码错误"];
            return;
        }else if ([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[_expireTime doubleValue]]] == 1){
            
            [JKPromptView showWithImageName:nil message:@"验证码已失效，请您重新获取"];
            return;
        }
        
        
        DLog(@"立即申请");
        
        [APIRequest applyForRentingACarWithCarId:_carText.text RequestSuccess:^{
            
            if ([weakSelf.delegate respondsToSelector:@selector(rentalCarSUccess)])
            {
                [weakSelf.delegate rentalCarSUccess];
            }
            [weakSelf removeFromSuperview];
        } fail:nil];
        
    }else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录，再进行租车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertView show];
    }
    
    
}

- (void)nearTheVehicleBtnEvent:(UIButton *)sender {
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
- (UIView *)xfView
{WEAKSELF;
    if (!_xfView) {
        
        _xfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _xfView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 163)/2.f, 10, 20, 20)];
        imgView.image = kGetImage(@"icon_info");
        imgView.userInteractionEnabled = YES;
        [_xfView addSubview:imgView];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgView) +3, 10, 140, 20)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = hexColor(F44336);
        label2.font = Font_12;
        label2.text = @"租车卡已到期,点击去续费";
        [_xfView addSubview:label2];
        [label2 whenCancelTapped:^{
            
            HandleCarViewController *vc = [HandleCarViewController new];
            vc.isXF = YES;
            [weakSelf.superViewController.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _xfView;
}
- (UIImageView *)carImgView
{
    if (!_carImgView) {
        _carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 20, 25)];
        _carImgView.userInteractionEnabled = YES;
        _carImgView.image = kGetImage(@"icon_ebike");
    }
    return _carImgView;
}
- (UIImageView *)phoneImgView
{
    if (!_phoneImgView) {
        _phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 83, 20, 25)];
        _phoneImgView.userInteractionEnabled = YES;
        _phoneImgView.image = kGetImage(@"icon_code");
    }
    return _phoneImgView;
}
- (UITextField *)carText
{
    if (!_carText) {
        _carText = [[UITextField alloc] initWithFrame:CGRectMake(70, 40, kMainScreenWidth-110, 30)];
        _carText.backgroundColor = [UIColor clearColor];
        _carText.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
        _carText.tag = 3887;
        _carText.delegate = self;
        _carText.borderStyle = UITextBorderStyleNone;
        _carText.textAlignment = NSTextAlignmentLeft;
        _carText.keyboardType = UIKeyboardTypeNumberPad;
        _carText.placeholder = @"输入车辆编号";
        _carText.font = Font_14;
    }
    return _carText;
}
- (UITextField *)phoneText
{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(70, 83, kMainScreenWidth-182, 30)];
        _phoneText.backgroundColor = [UIColor clearColor];
        _phoneText.borderStyle = UITextBorderStyleNone;
        _phoneText.textAlignment = NSTextAlignmentLeft;
        _phoneText.placeholder = @"请输入收到的验证码号";
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.delegate = self;
        _phoneText.tag = 3888;
        _phoneText.font = Font_14;
    }
    return _phoneText;
}
- (JKCountDownButton *)countDownCode
{
    if (!_countDownCode) {
        _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        _countDownCode.frame = CGRectMake(kMainScreenWidth - 112, 85, 72, 26);
        [_countDownCode setTitle:@"获取验证码" forState:0];
        [_countDownCode setTitleColor:hexColor(999999) forState:0];
        _countDownCode.titleLabel.font = Font_12;
        [_countDownCode addTarget:self action:@selector(sendCodeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        LRViewBorderRadius(_countDownCode, 2.f, .6f, hexColor(999999));
    }
    return _countDownCode;
}
- (UIButton *)nearBtn
{
    if (!_nearBtn) {
        _nearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nearBtn.frame = CGRectMake(40, 212, kMainScreenWidth - 80, 40);
        LRViewBorderRadius(_nearBtn, 5.f, 0, [UIColor whiteColor]);
        _nearBtn.backgroundColor  = hexColor(09BB07);
        [_nearBtn setTitleColor:[UIColor whiteColor] forState:0];
        _nearBtn.titleLabel.font = Font_18;
        _nearBtn.tag = 3023;
        [_nearBtn setBackgroundImage:kGetImage(@"btn_around_car") forState:UIControlStateNormal];
        [_nearBtn setBackgroundImage:kGetImage(@"btn_around_car") forState:UIControlStateSelected];
        [_nearBtn addTarget:self action:@selector(nearTheVehicleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nearBtn;
}
- (UIButton *)immBtn
{
    if (!_immBtn) {
        _immBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _immBtn.frame = CGRectMake(40, 152, kMainScreenWidth - 80, 40);
        _immBtn.backgroundColor  = hexColor(F8B62A);
        [_immBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_immBtn setTitle:@"立即申请" forState:0];
        _immBtn.titleLabel.font = Font_18;
        _immBtn.tag = 3023;
        [_immBtn addTarget:self action:@selector(applyImmediatelyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        LRViewBorderRadius(_immBtn, 5.f, 0, [UIColor whiteColor]);

    }
    return _immBtn;
}
- (UIView *)codeLineView
{
    if (!_codeLineView) {
        _codeLineView = [[UIView alloc] initWithFrame:CGRectMake(40, 76, kMainScreenWidth - 80, 1)];
        _codeLineView.backgroundColor = hexColor(999999);
    }
    return _codeLineView;
}
- (UIView *)phoneLineView
{
    if (!_phoneLineView) {
        _phoneLineView = [[UIView alloc] initWithFrame:CGRectMake(40, 121, kMainScreenWidth - 80, 1)];
        _phoneLineView.backgroundColor = hexColor(999999);
    }
    return _phoneLineView;
}

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
