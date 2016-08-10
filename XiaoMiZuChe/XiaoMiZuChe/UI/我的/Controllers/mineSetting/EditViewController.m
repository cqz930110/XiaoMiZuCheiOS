//
//  EditViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "EditViewController.h"
#import "GcNoticeUtil.h"
//static NSString *const CELLIDENTIFER = @"editcellid";

@interface EditViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *editText;
@property (strong, nonatomic) UIView *editView;
@property (copy, nonatomic)   NSString *parameterStr;

@end

@implementation EditViewController
- (void)dealloc{
    [GcNoticeUtil removeAllNotification:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBarWithTitle:@"基本资料"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"保存" img:nil];
    self.rightBtn.titleLabel.font = Font_16;
    
    [self.view addSubview:self.editView];
    [self.editView addSubview:self.editText];
}
#pragma mark-UIButtonEvent
- (void)rightBtnAction
{
    if (_editText.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您填写修改内容！"];
        return;
    }
    
    _parameterStr = @"";
    if ([_titleStr isEqualToString:@"姓名"]) {
        _parameterStr = @"userName";
    }else if ([_titleStr isEqualToString:@"身份证号"]) {
        _parameterStr = @"idNum";
    }else if ([_titleStr isEqualToString:@"详细地址"]) {
        _parameterStr = @"address";
    }
    WEAKSELF;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userToken,@"Authorization",[PublicFunction shareInstance].m_user.userId,@"userId",_editText.text,_parameterStr, nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,UPDATEUSERDATAURL];
    [APIRequest updateUserDataWithPostDict:dict withURLString:urlString RequestSuccess:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^{
        
    }];
}
#pragma mark -UITextFieldDelegate
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

#pragma mark - 放下键盘
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - setters and getters
- (UITextField *)editText{
    if (!_editText) {
        _editText =[[UITextField alloc] initWithFrame:CGRectMake(10.f, 5, kMainScreenWidth - 20.f, 30)];
        _editText.delegate = self;
        _editText.text = _contentStr;
        _editText.font = Font_14;
        _editText.borderStyle = UITextBorderStyleNone;
        _editText.returnKeyType = UIReturnKeyDone;
        [_editText becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_editText];
    }
    return _editText;
}
- (UIView *)editView
{
    if (!_editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, 40)];
        _editView.layer.masksToBounds = YES;
        _editView.layer.borderWidth = .6f;
        _editView.backgroundColor = [UIColor whiteColor];
        _editView.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    }
    return _editView;
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
