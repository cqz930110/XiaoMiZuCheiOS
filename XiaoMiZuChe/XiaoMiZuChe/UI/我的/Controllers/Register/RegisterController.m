//
//  RegisterController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/7/23.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "RegisterController.h"
#import "JKCountDownButton.h"

@interface RegisterController ()
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RegisterController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
#pragma mark -private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"注册会员"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(_nextBtn, 5.f, 0, [UIColor whiteColor]);
    LRViewBorderRadius(_sendCodeBtn, 3.f, 1, hexColor(999999));

}

#pragma mark -getters and setters

#pragma mark - event response
- (IBAction)sendCodeBtnEvent:(id)sender {
    
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
- (IBAction)nextBtnEvent:(id)sender {
    
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
