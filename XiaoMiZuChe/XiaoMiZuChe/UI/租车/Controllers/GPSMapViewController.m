//
//  GPSMapViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "GPSMapViewController.h"
//导航
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "AMapLocationKit.h"
#import <MapKit/MapKit.h>

@interface GPSMapViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationService;//定位服务
@property (nonatomic, strong) CLLocation *userLocation;  //我的位置

@end

@implementation GPSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"附近车辆"];

    [self.view addSubview:self.mapView];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    [self userLocationService];

}
#pragma mark -获取地理位置信息
- (void)userLocationService
{
    _locationService = [[AMapLocationManager alloc] init];
    _locationService.delegate = self;
    [_locationService startUpdatingLocation];//开启定位
}
#pragma mark - MapView Delegate 更新地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location)
    {
        _userLocation = location;
        [_locationService stopUpdatingLocation];//停止定位
        CLLocationCoordinate2D coor2D = {_userLocation.coordinate.latitude ,_userLocation.coordinate.longitude};
        [self.mapView setCenterCoordinate:coor2D];
        [self.mapView setZoomLevel:16.1 animated:YES];
        
        [self getArroundCarRequest];
    }
    
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}
#pragma mark -
- (void)getArroundCarRequest
{
    NSInteger lonint = _userLocation.coordinate.longitude * 1000000;
    NSInteger latint = _userLocation.coordinate.latitude * 1000000;
    NSString *lon = [NSString stringWithFormat:@"%ld",lonint];
    NSString *lat = [NSString stringWithFormat:@"%ld",latint];

    [APIRequest getArroundCarWithLon:lon withLat:lat RequestSuccess:^{
        
    } fail:^{
    }];
}
#pragma mark - getters and setters
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView =  [[MAMapView alloc] initWithFrame:CGRectMake(0,64 , kMainScreenWidth, kMainScreenHeight - 64)] ;
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        [_mapView setZoomLevel:16.1 animated:YES];
    }
    
    return _mapView;
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
