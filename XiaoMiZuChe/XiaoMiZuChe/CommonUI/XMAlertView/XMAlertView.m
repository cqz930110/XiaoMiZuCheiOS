//
//  XMAlertView.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "XMAlertView.h"
#import "JKCountDownButton.h"

#define kContentLabelWidth     13.f/16.f*([UIScreen mainScreen].bounds.size.width)
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

@interface XMAlertView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *zc_superView;
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *codeSureBtn;
@property (nonatomic, strong) UIButton *codeCancelBtn;
@property (nonatomic, strong) JKCountDownButton *sendCodeBtn;

@end

@implementation XMAlertView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithVerificationCodeWithStyle:(XMAlertViewStyle)style
{
    self = [super initWithFrame:kMainScreenFrameRect];
    
    if (self)
    {
        _style = style;
        [self initData];
    }
    return self;
}
#pragma mark - private methods
- (void)initData
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self addSubview:self.zc_superView];
    self.zc_superView.frame = CGRectMake(0, 0, kContentLabelWidth, 171);
    self.zc_superView.center = CGPointMake(zd_width/2.0,0);
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.zc_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
    } completion:^(BOOL finished) {
    }];
    [self.zc_superView addSubview:self.codeCancelBtn];
    [self.zc_superView addSubview:self.codeText];
    [self.zc_superView addSubview:self.sendCodeBtn];
    [self.zc_superView addSubview:self.codeSureBtn];
    
    _codeCancelBtn.frame = CGRectMake(kContentLabelWidth - 50.f,10.f ,30.f, 30.f);
    _codeText.frame = CGRectMake(20.f,Orgin_y(_codeCancelBtn) +10.f ,kContentLabelWidth -140.f, 38.f);
    _sendCodeBtn.frame = CGRectMake(kContentLabelWidth - 105.f, Orgin_y(_codeCancelBtn) +10.f, 85.f, 38.f);
    _codeSureBtn.frame = CGRectMake(20.f, Orgin_y(_sendCodeBtn) + 20.f,kContentLabelWidth - 40.f, 38.f);
}
#pragma mark -
#pragma mark - event response
- (void)sendCodeToYou:(id)sender
{
    [self dismissKeyBoard];
    if (_codeText.text.length > 0  && [QZManager isPureInt:_codeText.text] == YES)
    {
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
    }
}
- (void)cancelORSureEvent:(UIButton *)sender
{
    if (sender.tag == 3005) {
        DLog(@"确认还车");
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:0];
        }

    }
    [self zd_Windowclose];
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.35 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.zc_superView.center = CGPointMake(zd_width/2.0,-300);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];
    }];
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
}
#pragma mark - setters and getters
- (UIView *)zc_superView
{
    if (!_zc_superView) {
        _zc_superView = [[UIView alloc] init];
        _zc_superView.backgroundColor = [UIColor whiteColor];
        _zc_superView.layer.cornerRadius = 3.f;
        _zc_superView.clipsToBounds = YES;
    }
    return _zc_superView;
}

- (UITextField *)codeText
{
    if (!_codeText) {
        _codeText =[[UITextField alloc] init];
        _codeText.delegate = self;
        _codeText.borderStyle = UITextBorderStyleNone;
        _codeText.layer.borderWidth = 1.f;
        _codeText.layer.borderColor = hexColor(F08200).CGColor;
        _codeText.returnKeyType = UIReturnKeyDone; //设置按键类型
        _codeText.keyboardType = UIKeyboardTypeNumberPad;
        _codeText.tag = 3006;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_codeText];
    }
    return _codeText;
}
- (JKCountDownButton *)sendCodeBtn
{
    if (!_sendCodeBtn) {
        _sendCodeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        _sendCodeBtn.backgroundColor = hexColor(F08200);
        [_sendCodeBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sendCodeBtn setTitle:@"获取验证码" forState:0];
        _sendCodeBtn.layer.masksToBounds = YES;
        _sendCodeBtn.layer.cornerRadius = 3.f;
        [_sendCodeBtn addTarget:self action:@selector(sendCodeToYou:) forControlEvents:UIControlEventTouchUpInside];
        _sendCodeBtn.titleLabel.font = Font_14;
    }
    return _sendCodeBtn;
}
- (UIButton *)codeCancelBtn
{
    if (!_codeCancelBtn) {
        _codeCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeCancelBtn.backgroundColor = [UIColor whiteColor];
        _codeCancelBtn.titleLabel.font = Font_15;
        _codeCancelBtn.tag = 3004;
        [_codeCancelBtn setTitleColor:KNavigationBarColor forState:0];
        [_codeCancelBtn setBackgroundImage:kGetImage(@"police_btn_close") forState:0];
        [_codeCancelBtn addTarget:self action:@selector(cancelORSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeCancelBtn;
}
- (UIButton *)codeSureBtn
{
    if (!_codeSureBtn) {
        _codeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeSureBtn.backgroundColor = hexColor(F08200);
        _codeSureBtn.tag = 3005;
        [_codeSureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_codeSureBtn setTitle:@"确认还车" forState:0];
        _codeSureBtn.layer.masksToBounds = YES;
        _codeSureBtn.layer.cornerRadius = 3.f;
        _codeSureBtn.titleLabel.font = Font_15;
        [_codeSureBtn addTarget:self action:@selector(cancelORSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeSureBtn;
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
