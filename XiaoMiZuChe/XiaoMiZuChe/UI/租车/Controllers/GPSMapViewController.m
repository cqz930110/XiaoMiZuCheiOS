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
#import "NearCardata.h"

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
    [self getArroundCarRequest];

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
{WEAKSELF;
    float lonint = _userLocation.coordinate.longitude * 1000000;
    float latint = _userLocation.coordinate.latitude * 1000000;
    NSString *lon = [NSString stringWithFormat:@"%.0f",lonint];
    NSString *lat = [NSString stringWithFormat:@"%.0f",latint];

    [APIRequest getArroundCarWithLon:lon withLat:lat RequestSuccess:^(NSArray *arrays) {
        
        if (arrays.count > 0) {
            [arrays enumerateObjectsUsingBlock:^(NearCardata *model, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CLLocationCoordinate2D coordinate = {[model.lat integerValue]/1000000.0, [model.lon integerValue]/1000000.0};
                MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                [annotation setCoordinate:coordinate];
                [annotation setTitle:model.carportName];
                [annotation setSubtitle:model.distance];
                [weakSelf.mapView addAnnotation:annotation];
                if (idx == arrays.count - 1) {
                    [weakSelf.mapView setCenterCoordinate:coordinate animated:YES];
                    DLog(@"数量是－－－－－－%ld",weakSelf.mapView.annotations.count);
                }
            }];
        }
    } fail:^{
        
    }];
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
//        // 设置为NO，用以调用自定义的calloutView
//        annotationView.canShowCallout = NO;
        annotationView.canShowCallout= YES;
        annotationView.image = [UIImage imageNamed:@"icon_ebike_online"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
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
