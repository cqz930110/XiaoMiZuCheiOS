//
//  BatteryViewController.m
//  GNETS
//
//  Created by cqz on 16/6/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BatteryViewController.h"

@interface BatteryViewController ()

@end

@implementation BatteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"电量监测"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"卫星定位" img:@"icon_left_arrow"];

    _voltageTitle.text = [NSString stringWithFormat:@"您的电动车规格为:%@V",_model.voltage];
    NSString *remainStr = [NSString stringWithFormat:@"icon_battery_percent_%@",_model.remainBattery];
    _batteryImg.image = [UIImage imageNamed:remainStr];
    
    if ([_model.remainBattery intValue] <= 10) {
        _remainVlab.textColor = [UIColor redColor];
    }
    _remainVlab.text = [NSString  stringWithFormat:@"当前剩余电量：%@％",_model.remainBattery];
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
