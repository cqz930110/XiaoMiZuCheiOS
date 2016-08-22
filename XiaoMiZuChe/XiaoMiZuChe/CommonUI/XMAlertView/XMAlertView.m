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
        _codeText =[[UITextField alloc] initWithFrame:CGRectMake(15, 15, kContentLabelWidth - 30, 30)];
        _codeText.delegate = self;
        _codeText.borderStyle = UITextBorderStyleNone;
        _codeText.returnKeyType = UIReturnKeyDone; //设置按键类型
        _codeText.keyboardType = UIKeyboardTypeNumberPad;
        [_codeText becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_codeText];
    }
    return _codeText;
}
- (UIButton *)codeCancelBtn
{
    if (!_codeCancelBtn) {
        _codeCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeCancelBtn.backgroundColor = [UIColor whiteColor];
        _codeCancelBtn.titleLabel.font = Font_15;
        _codeCancelBtn.tag = 3004;
        _codeCancelBtn.frame = CGRectMake(0, 60.6f,kContentLabelWidth/2.f-0.3f , 49.4f);
        [_codeCancelBtn setTitleColor:KNavigationBarColor forState:0];
        [_codeCancelBtn setTitle:@"取消" forState:0];
        _codeCancelBtn.showsTouchWhenHighlighted = YES;
        [_codeCancelBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeCancelBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
