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
#import "MZTimerLabel.h"
#import "XMAlertView.h"

#define REES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CarRentalViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate,IFlySpeechSynthesizerDelegate,RentalViewDelegate,MapTypeViewPro,SelectTimeAlertPro,XMAlertViewPro>
{
    UITapGestureRecognizer* _singleTap;//地图点击手势
    
    CLLocationCoordinate2D _center;
    CLLocationCoordinate2D _touchCll;
    CLLocationCoordinate2D _removeCll;//要移除的大头针

}
@property (nonatomic, copy)   NSString *anoTitle;
@property (nonatomic, copy)   NSString *ponintImg;
@property (nonatomic, strong) NSMutableArray *poiAnnotations;
@property (nonatomic, assign) BOOL isTrack;//是否显示的是轨迹
@property (nonatomic, strong) NSTimer             *myTimer;
@property (nonatomic, strong) LocInfodata *locModel;//车辆位置信息

@property (nonatomic, strong) MapTypeView *mapTypeView;
@property (nonatomic, strong) MsgView *msgView;
@property (nonatomic, strong) SelectTimeAlert *alertViewTime;
@property (nonatomic, strong) RentalView *rentalView;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MZTimerLabel *timerLabel;//倒计时
@property (nonatomic, strong) UILabel *label;//倒计时

@end

@implementation CarRentalViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_myTimer == nil  && [PublicFunction shareInstance].m_user.carRecord.expectEndTime.length >0){
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(reloadMapLocation:) userInfo:nil repeats:YES];
    }

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    TTVIEW_RELEASE_SAFELY(_alertViewTime)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self autoLoginSuccessMethods];
}
- (void)reloadMapLocation:(NSTimer *)theTimer
{
    [self loadMapNeed];
}
#pragma mark - 通知
- (void)autoLoginSuccessMethods
{WEAKSELF;
    [GcNoticeUtil handleNotification:DECIDEISLOGIN
                            Selector:@selector(autoLoginSuccessMethods)
                            Observer:self];

    if ([PublicFunction shareInstance].m_user.carRecord.expectEndTime.length >0) {
        
        [self setupNaviBarWithTitle:@"车辆控制"];

        TTVIEW_RELEASE_SAFELY(_rentalView)
        [self.view addSubview:self.mapView];
        [self.view addSubview:self.timerLabel];
//        NSDate *fireDate = [QZManager caseDateFromString:[PublicFunction shareInstance].m_user.carRecord.expectEndTime];
        NSDate *fireDate = [QZManager caseDateFromString:[PublicFunction shareInstance].m_user.carRecord.expectEndTime];

        double resInterval = [fireDate timeIntervalSinceNow];

        if ([QZManager compareOneDay:[NSDate date] withAnotherDay:fireDate] == 1)
        {
            double count = [[NSDate date] timeIntervalSince1970] - [fireDate timeIntervalSince1970];
            _timerLabel = [[MZTimerLabel alloc] initWithLabel:self.label andTimerType:MZTimerLabelTypeStopWatch];
            [_timerLabel setStopWatchTime:count];
            [_timerLabel start];
       
        }else {
            _timerLabel = [[MZTimerLabel alloc] initWithLabel:self.label andTimerType:MZTimerLabelTypeTimer];
            [_timerLabel setCountDownTime:resInterval];
            _timerLabel.resetTimerAfterFinish = NO; //结束后不重置
            _timerLabel.timeFormat = @"HH小时mm分";
            if(![_timerLabel counting]){
                [_timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                    
                    TTVIEW_RELEASE_SAFELY(weakSelf.timerLabel);
                    TTVIEW_RELEASE_SAFELY(weakSelf.label);
                    double count = [[NSDate date] timeIntervalSince1970] - [fireDate timeIntervalSince1970];
                    _timerLabel = [[MZTimerLabel alloc] initWithLabel:weakSelf.label andTimerType:MZTimerLabelTypeStopWatch];
                    [_timerLabel setStopWatchTime:count];
                    [_timerLabel start];

                }];
            }
        }

        for (NSUInteger i =1; i<10; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:1000+i];
            [self.view bringSubviewToFront:btn];
            btn.hidden = NO;
        }
        //检测是围栏车成功
        [GcNoticeUtil handleNotification:OPENVFNOTI
                                Selector:@selector(handleLockCarStatus:)
                                Observer:self];
        

        [self initIFlySpeech];
        
        [self loadMapNeed];
        
    }else{

        [self noCarRentalInformation];
    }
}
- (void)noCarRentalInformation{
    
    [self setupNaviBarWithTitle:@"申请用车"];

    TTVIEW_RELEASE_SAFELY(_rentalView)
    for (NSUInteger i =1; i<10; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:1000+i];
        [self.view bringSubviewToFront:btn];
        btn.hidden = YES;
    }
    [self.view addSubview:self.rentalView];
    TTVIEW_RELEASE_SAFELY(_mapView)
    TT_INVALIDATE_TIMER(_myTimer);
    TTVIEW_RELEASE_SAFELY(_timerLabel);
    TTVIEW_RELEASE_SAFELY(_label);
    TTVIEW_RELEASE_SAFELY(_mapTypeView);
    TTVIEW_RELEASE_SAFELY(_msgView);
    TTVIEW_RELEASE_SAFELY(_alertViewTime);

}
#pragma mark - 加载地图必须
- (void)loadMapNeed
{WEAKSELF;
    
    [APIRequest getCarLocationInfomationRequestSuccess:^(id model) {
        
        weakSelf.locModel = (LocInfodata *)model;
        [weakSelf showTheMapStyle];
    }];
}
- (void)showTheMapStyle
{
    [self.poiAnnotations removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self selectPictureWithLock:_locModel.lock];
    
    UIImage *image = ([_locModel.isOpenVf integerValue]==0)?kGetImage(@"fence_close"):kGetImage(@"fence_open");
    [_OverlayBtn setBackgroundImage:image forState:0];
    
    NSUInteger lat = [_locModel.lat integerValue];
    NSUInteger lon = [_locModel.lon integerValue];
    CLLocationCoordinate2D center = {lat/1000000.0, lon/1000000.0};
    _center = center;
    _isTrack = NO;//显示的不是轨迹
    //导航的终点
    _endPoint = [AMapNaviPoint locationWithLatitude:center.latitude
                                          longitude:center.longitude];
    _anoTitle = [NSString stringWithFormat:@"%@\n%@km/h",_locModel.satelliteTime,_locModel.speed];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(center.latitude, center.longitude)];
    [_poiAnnotations addObject:annotation];
    if ([_locModel.isOpenVf integerValue] == 1  && [_locModel.speed integerValue] != 0 && [_locModel.isOnline isEqualToString:@"1"])
    {
        NSUInteger lat1 = [_locModel.vfLat integerValue];
        NSUInteger lon1 = [_locModel.vfLon integerValue];
        CLLocationCoordinate2D center1 = {lat1/1000000.0, lon1/1000000.0};
        MAPointAnnotation *annotation1 = [[MAPointAnnotation alloc] init];
        [annotation1 setCoordinate:CLLocationCoordinate2DMake(center1.latitude, center1.longitude)];
        NSArray *arrAno = [NSArray arrayWithObjects:annotation,annotation1, nil];
        [self zoomToMapPoints:_mapView annotations:arrAno];
    }
    [self showPOIAnnotations];
}
- (void)showPOIAnnotations
{
    [_mapView addAnnotations:_poiAnnotations];
    if (_poiAnnotations.count == 1)
    {
        _mapView.centerCoordinate = [(MAPointAnnotation *)_poiAnnotations[0] coordinate];
        if ([_locModel.isOpenVf integerValue] == 1){
            [self drawOverlays];
        }
    }
    else
    {
        [_mapView showAnnotations:_poiAnnotations animated:NO];
    }
}
- (void)drawOverlays
{
    DLog(@"输出有多少个蔚蓝－－－－－%ld",(unsigned long)self.mapView.overlays.count);
    [_mapView removeOverlays:_mapView.overlays];
    if([[self.mapView overlays] count] <1) {
        NSUInteger lat = [_locModel.vfLat integerValue];
        NSUInteger lon = [_locModel.vfLon integerValue];
        NSMutableArray *overlays = [NSMutableArray array];
        /* Circle. */
        MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(lat/1000000.0, lon/1000000.0) radius:100];
        [overlays insertObject:circle atIndex:0];
        [self.mapView addOverlay:circle];
    }
}
#pragma mark - Line Cycle
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *polylineView = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        polylineView.lineWidth   = 2.f;
        polylineView.strokeColor = [UIColor redColor];
        polylineView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        return polylineView;
    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 2.f;
        polylineView.strokeColor = [UIColor colorWithRed:42/255.0 green:172/255.0 blue:247/255.0 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - event response
- (IBAction)clickButtonEvent:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.mapView  removeGestureRecognizer:_singleTap];
    
    NSUInteger index = button.tag;
    
    switch (index) {
        case 1001:
        {
            _mapView.showTraffic = !_mapView.showTraffic;
            UIImage *trafficImg = (_mapView.showTraffic == YES)?kGetImage(@"traffic_open"):kGetImage(@"traffic_close");
            [button setBackgroundImage:trafficImg forState:0];

        }
            break;
        case 1002:
        {
            [self changeMapTyleFinder:button];
        }
            break;
        case 1003:
        {//解锁
            // 远程锁车
            if ([_locModel.lock isEqualToString:@"0"]) {
                // 等于0时候调用锁车的接口
                [APIRequest lockCarRequestSuccess:^{
                } fail:^{
                }];
            }else {
                //等于1时候调用的是解锁的接口
                [APIRequest unlockCarRequestSuccess:^{
                } fail:^{
                }];
            }

        }
            break;
        case 1004:
        {
            _alertViewTime = [[SelectTimeAlert alloc] initWithFrame:self.view.bounds];
            _alertViewTime.delegate = self;
            [_alertViewTime show];
        }
            break;
        case 1005:
        {
            [self.mapView removeAnnotations:self.mapView.annotations];
            if (_isTrack == YES) {
                [self.mapView removeOverlays:self.mapView.overlays];
            }
            _isTrack = NO;
            [self showPOIAnnotations];
            
            NSString *vfStr = nil;
            if (_locModel) {
                if ([_locModel.isOpenVf integerValue] == 0) {
                    vfStr = @"您确定要开启电子围栏吗?";
                    
                }else{
                    vfStr = @"您确定要关闭电子围栏吗?";
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:vfStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.tag = 1573;
                [alertView show];
            }
        }
            break;
        case 1006:{
            [self getCarInfo:button];
        }
            break;
        case 1007:{
            
            [self startCarNav];
        }
            break;
        case 1008:{
            
            if ([_locModel.upVoltage integerValue] == 2) {
                BatteryViewController *vc = [BatteryViewController new];
                vc.model = _locModel;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [JKPromptView showWithImageName:nil message:@"您的设备不支持此功能"];
            }
        }
            break;
        case 1009:
        {
            
            UIWindow *window = [QZManager getWindow];
            XMAlertView *alertView = [[XMAlertView alloc] initWithVerificationCodeWithStyle:XMAlertViewStyleVerCode];
            alertView.delegate = self;
            [window addSubview:alertView];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -  XMAlertViewPro
- (void)xMalertView:(XMAlertView *)alertView withClickedButtonAtIndex:(NSInteger)buttonIndex
{WEAKSELF;
    if (buttonIndex == 1) {
        
        [APIRequest backCarEventWithForce:@"1" RequestSuccess:^{
            
            [weakSelf noCarRentalInformation];
            
        } fail:^{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统检测到电动车未归还到指定车棚！是否执行强制换车？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 10009;
            [alertView show];
            
        }];

    }
    
}

#pragma mark -SelectTimeAlertPro 画轨迹
- (void)ShowTheRoadWithKSDate:(NSMutableArray *)locArrays WithStar:(CLLocationCoordinate2D)qidian withEnd:(CLLocationCoordinate2D)endcll
{
    [_myTimer invalidate];//销毁定时器
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    _isTrack = YES;//显示的是轨迹
    
    if (locArrays.count == 1) {
        _ponintImg = @"marker_start";
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(qidian.latitude, qidian.longitude);
        trackdata *model = (trackdata *)locArrays[0];
        NSString *contentStr = [NSString stringWithFormat:@"%@  速度%@km/h",model.satelliteTimeStr,model.speed];
        [self addAnnotationWithCooordinate:point withTitle:@"起点" calloutText:contentStr];
    }else{
        
        CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(locArrays.count * sizeof(CLLocationCoordinate2D));
        for (NSUInteger i=0; i < locArrays.count; i++) {
            trackdata *loa = (trackdata*)[locArrays objectAtIndex:i];
            coordinates[i].longitude = [loa.lon integerValue]/1000000.0 ;
            coordinates[i].latitude  = [loa.lat integerValue]/1000000.0 ;
            
            CLLocationCoordinate2D point = {coordinates[i].latitude , coordinates[i].longitude};
            NSString *titleStr = @"";
            if (i == 0) {
                titleStr = @"起点";
            } else if (i == locArrays.count - 1){
                titleStr = @"终点";
            }else{
                titleStr = @"途经点";
            }
            [self addAnnotationWithCooordinate:point withTitle:titleStr calloutText: [NSString stringWithFormat:@"%@  速度%@km/h",loa.satelliteTimeStr,loa.speed]];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:locArrays.count];
        //    free(coordinates), coordinates = NULL;
        [_mapView addOverlay:polyline];
        _mapView.visibleMapRect = polyline.boundingMapRect;
        CLLocationCoordinate2D end = {coordinates[1].latitude , coordinates[1].longitude};
        [_mapView setCenterCoordinate:end];
        [_mapView setZoomLevel:16.1 animated:YES];
    }
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{WEAKSELF;
    if (alertView.tag == 1573 && buttonIndex == 1) {
        
        //电子围栏
        if ([_locModel.isOpenVf  integerValue] ==1) {
            NSString *carIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.carId];
            NSString *userIDString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];

            //关闭电子围栏
            NSString *vfUrlString = [NSString stringWithFormat:@"%@%@?carId=%@&userId=%@",kProjectBaseUrl,CLOSEVFURLSTRING,carIdString,userIDString];
            [APIRequest getLogoutWithURLString:vfUrlString RequestSuccess:^{
                
                //刷新地图 去除围栏
                weakSelf.locModel.isOpenVf = @0;
                [weakSelf.mapView removeOverlays:weakSelf.mapView.overlays];
                [JKPromptView showWithImageName:nil message:@"电子围栏关闭成功"];
                [weakSelf.OverlayBtn setBackgroundImage:[UIImage imageNamed:@"fence_open"] forState:0];
            } fail:^{
            }];
        }else{
            //开启电子围栏
            [self openCarVf];
        }
    }else if (alertView.tag == 10009 && buttonIndex == 1){
        
        [APIRequest backCarEventWithForce:@"2" RequestSuccess:^{
            
            [PublicFunction shareInstance].m_user.carRecord = nil;
            [weakSelf noCarRentalInformation];
        } fail:^{
        }];

    }
}
#pragma mark -开启电子围栏
- (void)openCarVf{
    NSString *carIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.carId];
    NSString *userIDString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];

    float lon = [_locModel.lon doubleValue]/1000000.f;
    float lat = [_locModel.lat doubleValue]/1000000.f;
    
    float r = 100;
    float k = 111700*2;
    float R = 3.141592654/180;
    //计算电子围栏的范围
    float top = lat + (r/k);//最大纬度
    float bottom = lat - r/k;//最小纬度
    float left = lon - r/(k*cos(lat*R));//最小经度
    float right = lon + r/(k*cos(lat*R));//最大经度
    WEAKSELF;
    NSString *openUrlString = [NSString stringWithFormat:@"%@%@?carId=%@&userId=%@&lon=%f&lat=%f&maxLon=%f&maxLat=%f&minLon=%f&minLat=%f",kProjectBaseUrl,OPENVFURLSTRING,carIdString,userIDString,lon,lat,top,right,bottom,left];
    [APIRequest getLogoutWithURLString:openUrlString RequestSuccess:^{
        
        [weakSelf loadMapNeed];
    } fail:^{
    }];
}
#pragma mark - 车辆信息
- (void)getCarInfo:(UIButton *)btn
{
    btn.transform = CGAffineTransformRotate(btn.transform, REES_TO_RADIANS(180));
    float width = btn.frame.size.width;
    float height = btn.frame.size.height;
    
    UIView  *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskView];
    WEAKSELF;
    [maskView whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.msgView removeFromSuperview];
            [maskView removeFromSuperview];
            _infoBtn.transform =CGAffineTransformIdentity;
            [_infoBtn setBackgroundImage:[UIImage imageNamed:@"car_status"] forState:0];
        }];
    }];
    
    _msgView = [[MsgView alloc] initWithFrame:CGRectMake(btn.frame.origin.x+width-230, Orgin_y(btn)-height -240, 230, 240) With:_locModel WithLocalCoordinate:_center];
    [self.view addSubview:_msgView];
    [_infoBtn setBackgroundImage:[UIImage imageNamed:@"close_map_Type_tip"] forState:0];
}

#pragma mark - 改变地图显示
- (void)changeMapTyleFinder:(UIButton *)btn
{
    float width = btn.frame.size.width;
    
    UIView  *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskView];
    WEAKSELF;
    [maskView whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            
            [weakSelf.mapTypeView removeFromSuperview];
            [maskView removeFromSuperview];
            [_mapTypeBtn setBackgroundImage:[UIImage imageNamed:@"map_switch"] forState:0];
        }];
        
    }];
    
    _mapTypeView = [[MapTypeView alloc] initWithFrame:CGRectMake(btn.frame.origin.x+width-223, Orgin_y(btn), 223, 100)];
    _mapTypeView.delegate = self;
    [self.view addSubview:_mapTypeView];
    [_mapTypeBtn setBackgroundImage:[UIImage imageNamed:@"close_map_Type_tip"] forState:0];
    
}
#pragma mark - MapTypeViewPro
- (void)changeMAMapType:(NSString *)type
{
    if ([type isEqualToString:@"卫星图"]) {
        _mapView.mapType = MAMapTypeSatellite;
    }else{
        _mapView.mapType = MAMapTypeStandard;
    }
}

#pragma mark - MapView Delegate 更新地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location)
    {
        _userLocation = location;
        _startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        [_locationService stopUpdatingLocation];//停止定位
    }
    
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (_isTrack == NO) {
        
        if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *pointReuseIndetifier = @"customReuseIndetifier";
            CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:pointReuseIndetifier];
            }
            if ([_locModel.isOnline isEqualToString:@"1"]) {
                annotationView.image = [UIImage imageNamed:@"ebike_online"];
            }else{
                annotationView.image = [UIImage imageNamed:@"ebike_offline"];
            }
            [annotationView setCalloutText:_anoTitle];
            DLog(@"000-------%@",annotation.subtitle);
            
            NSArray *annArrays = _mapView.annotations;
            if (annArrays.count>1) {
                [annotationView setCalloutText:@""];
                WEAKSELF;
                annotationView.annBlock = ^(){
                    
                    weakSelf.startPoint = [AMapNaviPoint locationWithLatitude:_touchCll.latitude longitude:_touchCll.longitude];
                    [weakSelf.mapView removeGestureRecognizer:_singleTap];
                    NSArray *arr = weakSelf.mapView.annotations;
                    [weakSelf.mapView  removeAnnotation:arr[arr.count - 1]];
                    [weakSelf navWindowEvent];
                };
                annotationView.image = [UIImage imageNamed:@"point"];
            }
            annotationView.selected = YES;
            return annotationView;
        }
        
    }else{
        
        if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *customReuseIndetifier = @"cReuseIndetifier";
            MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
                annotationView.canShowCallout = YES;
            }
            annotationView.image = [UIImage imageNamed:@"point"];
            
            if ([annotation.title isEqualToString:@"起点"]) {
                annotationView.image = [UIImage imageNamed:@"marker_start"];
                annotationView.centerOffset = CGPointMake(0, -16);
            }else if ([annotation.title isEqualToString:@"终点"]){
                annotationView.image = [UIImage imageNamed:@"marker_end"];
                annotationView.centerOffset = CGPointMake(0, -16);
            }
            return annotationView;
        }
    }
    return nil;
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title calloutText:(NSString*)calloutText
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:title];
    [annotation setSubtitle:calloutText];
    [_mapView addAnnotation:annotation];
}
#pragma mark -导航
- (void)startCarNav{
    if (_userLocation)
    {
        [self navWindowEvent];
        
    }else{
        [_iFlySpeechSynthesizer startSpeaking:@"手机定位尚未完成，请您在地图上手动选择位置"];
        //选择起点
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        _singleTap.cancelsTouchesInView = NO;
        [self.mapView addGestureRecognizer:_singleTap];
    }
}

- (void)navWindowEvent
{WEAKSELF;
    
    if (!_endPoint) {
        [JKPromptView showWithImageName:nil message:@"获取目标地理位置失败!"];
        return;
    }
    
    if (!_startPoint) {
        [JKPromptView showWithImageName:nil message:@"没有开启定位 ，请您开启定位"];
        return;
    }
    
    if (_userLocation) {
        NavMapWindow * window = [[NavMapWindow alloc] initWithFrame:kMainScreenFrameRect];
        window.navBlock = ^(NSString *str){
            if ([str isEqualToString:@"驾车导航"])
            {
                DeriveMapVC *mapVC = [DeriveMapVC new];
                mapVC.endPoint   = _endPoint;
                mapVC.startPoint = _startPoint;
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:mapVC] animated:YES completion:^{
                    
                }];
                
            }else{
                MapNavViewController *vc = [MapNavViewController new];
                vc.endPoint   = _endPoint;
                vc.startPoint = _startPoint;
                [weakSelf presentViewController:vc animated:YES completion:^{
                }];
            }
            
        };
        [self.view addSubview:window];
    }else{
        [JKPromptView showWithImageName:nil message:@"没有开启定位 ，请您开启定位"];
    }
}
#pragma mark -定位失败后 点击地图选择起点
- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    // 移除上一个标注的大头针
    if (_removeCll.latitude) {
        NSArray *annArrays = _mapView.annotations;
        for ( MAPointAnnotation *csanotation in annArrays) {
            if (csanotation.coordinate.latitude == _removeCll.latitude && csanotation.coordinate.longitude == _removeCll.longitude) {
                [_mapView removeAnnotation:csanotation];
            }
        }
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    _touchCll = touchMapCoordinate;
    _removeCll = _touchCll;
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annotation];
}
- (void)dismissEvents{
    // 移除上一个标注的大头针
    
    if (_removeCll.latitude) {
        NSArray *annArrays = _mapView.annotations;
        for ( MAPointAnnotation *csanotation in annArrays) {
            if (csanotation.coordinate.latitude == _removeCll.latitude && csanotation.coordinate.longitude == _removeCll.longitude) {
                [_mapView removeAnnotation:csanotation];
            }
        }
    }
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void)initIFlySpeech
{
    if (_iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        _iFlySpeechSynthesizer.delegate = self;
    }
}
#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    DLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

#pragma mark - RentalViewDelegate
- (void)rentalCarSUccess
{
    [self autoLoginSuccessMethods];
}
#pragma mark -在同一视野内MKCoordinateRegionMake
- (void)zoomToMapPoints:(MAMapView*)mapView annotations:(NSArray*)annotations
{
    double minLat = 360.0f, maxLat = -360.0f;
    double minLon = 360.0f, maxLon = -360.0f;
    for (MAPointAnnotation *annotation in annotations) {
        if ( annotation.coordinate.latitude < minLat ) minLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.latitude > maxLat ) maxLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.longitude < minLon ) minLon = annotation.coordinate.longitude;
        if ( annotation.coordinate.longitude > maxLon ) maxLon = annotation.coordinate.longitude;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.f, (minLon + maxLon) / 2.f);
    MACoordinateSpan span = MACoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}
#pragma -mark 处理是否锁车成功
- (void)handleLockCarStatus:(NSNotification *)sender{
    
    NSString *eventType = [sender.userInfo objectForKey:@"eventType"];
    
    //1锁车成功 2 锁车失败 3解锁成功 4解锁失败
    if (eventType.intValue == 1) {
        
        _locModel.lock = @"1";
        [self selectPictureWithLock:_locModel.lock];
    }else if(eventType.intValue == 3){
        
        _locModel.lock= @"0";
        [self selectPictureWithLock:_locModel.lock];
    }else if (eventType.intValue == 2){
        
        _locModel.lock = @"0";
        [self selectPictureWithLock:_locModel.lock];
    }else if (eventType.intValue == 4){
        
        _locModel.lock = @"1";
        [self selectPictureWithLock:_locModel.lock];
    }
    
    //8关闭超时 7关闭成功 6开启超时 5开启成功
    if (eventType.intValue == 8) {
        
        _locModel.isOpenVf = @1;
        [_OverlayBtn setBackgroundImage:kGetImage(@"fence_open") forState:0];
    }else if(eventType.intValue == 7){
        
        _locModel.isOpenVf = @0;
        [_OverlayBtn setBackgroundImage:kGetImage(@"fence_close") forState:0];
    }else if (eventType.intValue == 6){
        
        _locModel.isOpenVf = @0;
        [_mapView removeOverlays:self.mapView.overlays];
        [_OverlayBtn setBackgroundImage:kGetImage(@"fence_close") forState:0];
    }else if (eventType.intValue == 4){
        
        _locModel.isOpenVf = @1;
        [_OverlayBtn setBackgroundImage:kGetImage(@"fence_open") forState:0];
    }
    
}

#pragma mark -判断是否显示锁车 还是解锁图片
- (void)selectPictureWithLock:(NSString *)lockString
{
    // 远程锁车
    if ([lockString isEqualToString:@"0"]) {
        // 等于0时候调用锁车的接口
        [self.voiceBtn setImage:kGetImage(@"bg_lock_btn") forState:0];

    }else {
        //等于1时候调用的是解锁的接口
        [self.voiceBtn setImage:kGetImage(@"bg_unlock_btn") forState:0];
    }
}
#pragma mark - getters and setters

- (RentalView *)rentalView
{
    if (!_rentalView) {
        
        _rentalView = [[RentalView alloc] initUIWithDelegate:self withViewController:self];
    }
    return _rentalView;
}
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView =  [[MAMapView alloc] initWithFrame:CGRectMake(0,64 , kMainScreenWidth, kMainScreenHeight - 64)] ;
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        [_mapView setZoomLevel:16.1 animated:YES];
        //开启定位
        _locationService = [[AMapLocationManager alloc] init];
        _locationService.delegate = self;
        [_locationService startUpdatingLocation];
    }
    
    return _mapView;
}
- (UILabel *)label
{
    if (!_label) {
       
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 175, 30, 160, 20)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.font = Font_14;
        _label.textColor = hexColor(F8B62A);
        [self.view addSubview:_label];
    }
    return _label;
}
- (NSMutableArray *)poiAnnotations
{
    if (!_poiAnnotations) {
        _poiAnnotations = [NSMutableArray array];
    }
    return _poiAnnotations;
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
