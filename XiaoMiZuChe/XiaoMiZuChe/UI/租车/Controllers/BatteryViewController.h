//
//  BatteryViewController.h
//  GNETS
//
//  Created by cqz on 16/6/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LocInfoModel.h"

@interface BatteryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *voltageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImg;
@property (weak, nonatomic) IBOutlet UILabel *remainVlab;

@property (nonatomic, strong) LocInfoModel *model;

- (IBAction)ModifyTheVoltageEvent:(id)sender;

@end
