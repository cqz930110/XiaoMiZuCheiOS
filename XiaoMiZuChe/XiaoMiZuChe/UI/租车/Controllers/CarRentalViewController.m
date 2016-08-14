//
//  CarRentalViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "CarRentalViewController.h"
#import "JKCountDownButton.h"
#import "GPSMapViewController.h"
@interface CarRentalViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UITextField *carText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *immBtn;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearBtn;

@end

@implementation CarRentalViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"申请用车"];
    LRViewBorderRadius(_immBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_nearBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_sendCodeBtn, 3.f, 1, hexColor(999999));

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
        }else {
            self.phoneImgView.image = kGetImage(@"icon_code");
        }
    }else {
        if (textField.text.length >0) {
            self.carImgView.image = kGetImage(@"icon_ebike_active");
        }else {
            self.carImgView.image = kGetImage(@"icon_ebike");
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
    DLog(@"立即申请");
}

- (IBAction)nearTheVehicleBtnEvent:(UIButton *)sender {
    DLog(@"附近车辆");
    [self dismissKeyBoard];
    GPSMapViewController *gpsVC = [GPSMapViewController new];
    [self.navigationController pushViewController:gpsVC animated:YES];
}
#pragma mark - getters and setters
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
