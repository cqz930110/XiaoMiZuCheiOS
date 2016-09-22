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
@property (nonatomic, strong) UIView *xfView;//提醒续费

@property (copy, nonatomic) NSString *codeString;//验证码
@property (copy, nonatomic) NSString *expireTime;//验证码过期时间

@end
@implementation RentalView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (RentalView *)instanceRentalViewWithDelegate:(id<RentalViewDelegate>)delegate withViewController:(UIViewController *)superViewController
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RentalView" owner:self options:nil];
    RentalView *detailView = [nibView objectAtIndex:0];
    [detailView initUIWithDelegate:delegate withViewController:superViewController];
    return detailView;
}
- (void)initUIWithDelegate:(id<RentalViewDelegate>)delegate withViewController:(UIViewController *)superViewController{
    
    [self addSubview:self.xfView];

    if ([PublicFunction shareInstance].m_user.expireTime.length >0) {
        NSDate *fireDate = [QZManager caseDateFromString:[PublicFunction shareInstance].m_user.expireTime];
        if ([QZManager compareOneDay:[NSDate date] withAnotherDay:fireDate] == 1)
        {
            [self addSubview:self.xfView];
            _sendCodeBtn.hidden = YES;
        }
    }
    _superViewController = superViewController;
    _delegate = delegate;
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
- (IBAction)sendCodeButtonEvent:(JKCountDownButton *)sender
{WEAKSELF;
    
    [self dismissKeyBoard];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SENDHIRECARURL];
    [APIRequest sendSMStWithURLString:urlString withPhone:[PublicFunction shareInstance].m_user.phone RequestSuccess:^(NSString *code, NSString *expireTime) {
        
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
        
    } fail:nil];

}

- (IBAction)applyImmediatelyBtnEvent:(UIButton *)sender {
    WEAKSELF;
    [self dismissKeyBoard];
    if ([PublicFunction shareInstance].m_bLogin == YES) {
        if (_carText.text.length<=0) {
            [JKPromptView showWithImageName:nil message:@"请输入车辆编号"];
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
- (UIView *)xfView
{WEAKSELF;
    if (!_xfView) {
        
        _xfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _xfView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 20, 20)];
        imgView.image = kGetImage(@"icon_info");
        imgView.userInteractionEnabled = YES;
        [_xfView addSubview:imgView];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgView), 10, 200, 20)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = hexColor(F08200);
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
