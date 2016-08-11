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
#import "UserData.h"
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
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UILabel *agreementLab;
@property (strong, nonatomic) UITextField *detailAddressText;
@property (strong, nonatomic) NSMutableDictionary *schoolDict;

@end

@implementation PerfectInformationVC

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
    LRViewBorderRadius(_completeBtn, 5.f, 0, [UIColor clearColor]);
    _bottomLine.hidden = YES;
    _schoolLab.hidden  = YES;
    _arrowImgView.hidden = YES;
    [self.view addSubview:self.detailAddressText];
    self.detailAddressText.hidden = YES;
    self.areaLab.textColor = NINEColor;
    self.userTypeLab.textColor = NINEColor;
    self.schoolLab.textColor = NINEColor;

//    _completeBtn.frame = CGRectMake(40, 272.f, kMainScreenWidth - 80.f, 40.f);
//    _agreementLab.frame = CGRectMake(40, 327.f, kMainScreenWidth - 80.f, 40.f);

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
        weakSelf.schoolLab.textColor = thirdColor;
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
            weakSelf.userTypeLab.textColor = thirdColor;
            weakSelf.schoolLab.hidden  = NO;
            weakSelf.arrowImgView.hidden = NO;
            weakSelf.detailAddressText.hidden = YES;
            weakSelf.bottomLine.hidden = NO;
            weakSelf.schoolLab.text = @"请选择学校";
            weakSelf.schoolLab.textColor = NINEColor;
            weakSelf.detailAddressText.text = @"";

            [weakSelf loadSchoolData];
        }else if (buttonIndex == 1){
            weakSelf.userTypeLab.text = @"普通用户";
            weakSelf.userTypeLab.textColor = thirdColor;
            weakSelf.schoolLab.hidden  = YES;
            weakSelf.arrowImgView.hidden = YES;
            weakSelf.detailAddressText.hidden = NO;
            weakSelf.bottomLine.hidden = NO;
            weakSelf.schoolLab.text = @"请选择学校";
            weakSelf.detailAddressText.text = @"";
        }
    }];
    [sheet show];
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
        
        weakSelf.areaLab.textColor = thirdColor;
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
}

#pragma mark - event response

- (IBAction)completeRegisterBtnEvent:(id)sender {
    
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
    UserData *m_user = [PublicFunction shareInstance].m_user;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:m_user.userId,@"userId",_nameText.text,@"userName",@"2",@"sex",_cardNumText.text,@"idNum",userType,@"userType",_province,@"province",_city,@"city",_area,@"area",address,@"address",schoolId,@"schoolId", nil];
    [APIRequest perfectUserDataWithPostDict:dict RequestSuccess:^{
        
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
    }
    return _detailAddressText;
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
