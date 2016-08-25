//
//  PerfectInformationVC.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/3.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "PerfectInformationVC.h"
#import "MyPickView.h"
#import "LCActionSheet.h"
#import "ZHPickView.h"
#import "BasicData.h"
@interface PerfectInformationVC ()<UITextFieldDelegate>
{
    NSString *_province;
    NSString *_city;
    NSString *_area;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *cardNumText;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *schoolLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *nameLineView;
@property (weak, nonatomic) IBOutlet UIView *cardNumLineView;
@property (weak, nonatomic) IBOutlet UIView *areaLineView;
@property (weak, nonatomic) IBOutlet UIView *userTypeLineView;

@property (strong, nonatomic) UIButton *completeBtn;
@property (strong, nonatomic) UILabel *agreementLab;
@property (strong, nonatomic) UITextField *detailAddressText;
@property (strong, nonatomic) NSMutableDictionary *schoolDict;

@end

@implementation PerfectInformationVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{WEAKSELF;
    [self setupNaviBarWithTitle:@"完善资料"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _province   = @"";
    _city       = @"";
    _area       = @"";
    _schoolDict = [NSMutableDictionary dictionary];
    self.cardNumText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.nameText.textColor = THIRDCOLOR;
    self.cardNumText.textColor = THIRDCOLOR;
    [self.nameText setValue:NINEColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.cardNumText setValue:NINEColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.nameText.tag = 3006;
    self.cardNumText.tag = 3007;
    self.detailAddressText.tag = 3008;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.cardNumText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.detailAddressText];


    _bottomLine.hidden = YES;
    _schoolLab.hidden  = YES;
    _arrowImgView.hidden = YES;
    [self.view addSubview:self.detailAddressText];
    [self.view addSubview:self.completeBtn];
    [self.view addSubview:self.agreementLab];
    self.detailAddressText.hidden = YES;
    self.areaLab.textColor = NINEColor;
    self.userTypeLab.textColor = NINEColor;
    self.schoolLab.textColor = NINEColor;

    [self.areaLab whenCancelTapped:^{
        [weakSelf selectProvinceCityArea];
    }];
    [self.userTypeLab whenCancelTapped:^{
        
        if ([weakSelf.areaLab.text isEqualToString:@"省市区选择"]) {
             [JKPromptView showWithImageName:nil message:@"请您选择所在地区"];
        }else {
            [weakSelf seletUserType];
        }
    }];
    [self.schoolLab whenCancelTapped:^{
        [weakSelf selectSchoolEvent];
    }];
}
- (void)selectSchoolEvent{WEAKSELF;
    NSArray *arrays = [_schoolDict allKeys];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:arrays title:@"选择学校"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *schoolString)
    {
        weakSelf.bottomLine.backgroundColor = hexColor(F08200);
        weakSelf.schoolLab.textColor = THIRDCOLOR;
        weakSelf.schoolLab.text = schoolString;
    };
}
- (void)seletUserType{WEAKSELF;
    NSInteger index = 3;
    if (![self.userTypeLab.text isEqualToString:@"选择用户类型"]) {
        index = [self.userTypeLab.text isEqualToString:@"学校用户"]?0:1;
    }
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择用户类型" buttonTitles:@[@"学校用户",@"普通用户"] redButtonIndex:index clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            weakSelf.userTypeLab.text = @"学校用户";
            weakSelf.userTypeLab.textColor = THIRDCOLOR;
            [weakSelf whetherOrNotVisible:NO];
            weakSelf.bottomLine.hidden = NO;
            weakSelf.schoolLab.text = @"请选择学校";
            weakSelf.schoolLab.textColor = NINEColor;
            weakSelf.detailAddressText.text = @"";
            weakSelf.userTypeLineView.backgroundColor = hexColor(F08200);

            [weakSelf loadSchoolData];
        }else if (buttonIndex == 1){
            weakSelf.userTypeLab.text = @"普通用户";
            weakSelf.userTypeLab.textColor = THIRDCOLOR;
            [weakSelf whetherOrNotVisible:YES];
            weakSelf.bottomLine.hidden = NO;
            weakSelf.schoolLab.text = @"请选择学校";
            weakSelf.detailAddressText.text = @"";
            weakSelf.userTypeLineView.backgroundColor = hexColor(F08200);

        }
    }];
    [sheet show];
}
- (void)whetherOrNotVisible:(BOOL)islook
{
   _schoolLab.hidden  = islook;
   _arrowImgView.hidden = islook;
   _detailAddressText.hidden = !islook;
    _completeBtn.frame = CGRectMake(40, 312.f, kMainScreenWidth - 80.f, 40.f);
    _agreementLab.frame = CGRectMake(40, 367.f, kMainScreenWidth - 80.f, 40.f);

}
- (void)loadSchoolData{WEAKSELF;
    
    [APIRequest getSchoolsWithProvince:_province withCity:_city witharea:_area RequestSuccess:^(NSMutableDictionary *dict) {
        weakSelf.schoolDict = dict;
    } fail:^{
        
    }];
}
- (void)selectProvinceCityArea{WEAKSELF;
    UIWindow *windows = [QZManager getWindow];
    MyPickView *pickView = [[MyPickView  alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    pickView.pickBlock = ^(NSString *provice,NSString *city,NSString *area){
        
        weakSelf.areaLineView.backgroundColor = hexColor(F08200);
        weakSelf.areaLab.textColor = THIRDCOLOR;
        DLog(@"地区是－－－%@:%@,%@",provice,city,area);
        _province = provice;_city = city;
        NSString *tempStr = [NSString stringWithFormat:@"%@-%@-%@",provice,city,area];
        weakSelf.areaLab.text = tempStr;
        if ([weakSelf.userTypeLab.text isEqualToString:@"学校用户"]) {
            [weakSelf loadSchoolData];
        }
    };
    [windows addSubview:pickView];
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
    if (textField.tag == 3006) {
        if (_nameText.text.length >0) {
            self.nameLineView.backgroundColor = hexColor(F08200);
        }else {
            self.nameLineView.backgroundColor = hexColor(999999);
        }
    }
    if (textField.tag == 3007) {
        if (_cardNumText.text.length >0) {
            self.cardNumLineView.backgroundColor = hexColor(F08200);
        }else {
            self.cardNumLineView.backgroundColor = hexColor(999999);
        }
    }
    if (textField.tag == 3008) {
        if (_detailAddressText.text.length >0) {
            self.bottomLine.backgroundColor = hexColor(F08200);
        }else {
            self.bottomLine.backgroundColor = hexColor(999999);
        }
    }
}

#pragma mark - event response

- (void)completeRegisterBtnEvent:(id)sender {WEAKSELF;
    
    if (_nameText.text.length<=0) {
        [JKPromptView showWithImageName:nil message:@"请您输入姓名"];
        return;
    }else if (_cardNumText.text.length <=0){
        [JKPromptView showWithImageName:nil message:@"请您检查身份证号码是否填写"];
        return;
    }else if([_userTypeLab.text isEqualToString:@"选择用户类型"]){
        [JKPromptView showWithImageName:nil message:@"请您选择用户类型"];
        return;
    }else if([_areaLab.text isEqualToString:@"省市区选择"]){
        [JKPromptView showWithImageName:nil message:@"请您选择所在地区"];
        return;
    }
    NSString *userType = [_userTypeLab.text isEqualToString:@"学校用户"]?@"1":@"2";
    NSString *schoolId = _schoolDict[_schoolLab.text];
    NSString *address = _detailAddressText.text;
    BasicData *m_user = [PublicFunction shareInstance].m_user;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    if ([userType isEqualToString:@"1"]) {
        mutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:m_user.userId,@"userId",_nameText.text,@"userName",@"2",@"sex",_cardNumText.text,@"idNum",userType,@"userType",_province,@"province",_city,@"city",_area,@"area",schoolId,@"schoolId", nil];
    }else {
        [NSDictionary dictionaryWithObjectsAndKeys:m_user.userId,@"userId",_nameText.text,@"userName",@"2",@"sex",_cardNumText.text,@"idNum",userType,@"userType",_province,@"province",_city,@"city",_area,@"area",address,@"address", nil];
    }
    
    [APIRequest perfectUserDataWithPostDict:mutableDict RequestSuccess:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } fail:^{
        
    }];
}

#pragma mark -
#pragma mark - setters and getters
- (UITextField *)detailAddressText
{
    if (!_detailAddressText) {
        _detailAddressText = [[UITextField alloc] initWithFrame:CGRectMake(40, 256, kMainScreenWidth - 80, 30)];
        _detailAddressText.delegate = self;
        _detailAddressText.font = Font_14;
        _detailAddressText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailAddressText.keyboardType = UIKeyboardTypeASCIICapable;
        _detailAddressText.returnKeyType = UIReturnKeyDone;
        _detailAddressText.placeholder = @"请输入详细地址";
        _detailAddressText.textColor = THIRDCOLOR;
        [_detailAddressText setValue:NINEColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _detailAddressText;
}
- (UIButton *)completeBtn
{
    if (!_completeBtn) {
        
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_completeBtn setTitle:@"完成注册" forState:0];
        _completeBtn.frame = CGRectMake(40, 272.f, kMainScreenWidth - 80, 40);
        _completeBtn.backgroundColor = hexColor(FFA043);
        _completeBtn.layer.masksToBounds = YES;
        _completeBtn.layer.cornerRadius = 5.f;
        [_completeBtn addTarget:self action:@selector(completeRegisterBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}
- (UILabel *)agreementLab
{
    if (!_agreementLab) {
        _agreementLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 327.f, kMainScreenWidth - 80, 20)];
        _agreementLab.backgroundColor = [UIColor clearColor];
        _agreementLab.font = Font_14;
        _agreementLab.textAlignment = NSTextAlignmentCenter;
        _agreementLab.text = @"点击完成注册视为你同意《用户协议》";
        _agreementLab.textColor = hexColor(999999);
        
    }
    return _agreementLab;
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
