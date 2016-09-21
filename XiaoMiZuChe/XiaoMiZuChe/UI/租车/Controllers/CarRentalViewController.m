//
//  CarRentalViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "CarRentalViewController.h"
#import "JKCountDownButton.h"
#import "RentalView.h"
#import "carRecord.h"

#import "LocInfodata.h"
#import "CustomAnnotationView.h"
#import "MapTypeView.h"
#import "MsgView.h"
#import "SelectTimeAlert.h"
#import "trackModel.h"
#import "CustomMAPointAnnotation.h"
#import "BatteryViewController.h"
#import "DeriveMapVC.h"
#import "MapNavViewController.h"
#import "NavMapWindow.h"

@interface CarRentalViewController ()

@property (nonatomic, strong) RentalView *rentalView;
@end

@implementation CarRentalViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
//    if (([PublicFunction shareInstance].isLogin == NO)) {
//        
//        [self.view addSubview:self.rentalView];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"申请用车"];
    self.navigationController.navigationBarHidden = YES;
    if ([PublicFunction shareInstance].m_user.carRecord.expectEndTime.length >0) {
        
    }else{
        for (NSUInteger i =1; i<10; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:1000+i];
//            [self.view bringSubviewToFront:btn];
            btn.hidden = YES;
        }

        [self.view addSubview:self.rentalView];
    }
}

#pragma mark - event response


#pragma mark - getters and setters

- (RentalView *)rentalView
{
    if (!_rentalView) {
        
        _rentalView = [RentalView instanceRentalViewWithViewController:self];
    }
    return _rentalView;
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
