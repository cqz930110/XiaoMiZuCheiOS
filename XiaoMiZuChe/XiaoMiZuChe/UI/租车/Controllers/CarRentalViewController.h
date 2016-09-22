//
//  CarRentalViewController.h
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//导航
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "AMapLocationKit.h"
#import <MapKit/MapKit.h>

//讯飞
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@interface CarRentalViewController : BaseViewController

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic, strong) AMapNaviPoint *startPoint; //导航时候 起点
@property (nonatomic, strong) AMapNaviPoint *endPoint; //导航时候 目标终点
@property (nonatomic, strong) CLLocation *userLocation;  //导航时候 起点 （定位获取，定位失败后手动选择）
@property (nonatomic, strong) AMapLocationManager *locationService;//定位服务


@property (weak, nonatomic) IBOutlet UIButton *roadBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *trajectoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *OverlayBtn;

@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

- (IBAction)clickButtonEvent:(id)sender;
@end
