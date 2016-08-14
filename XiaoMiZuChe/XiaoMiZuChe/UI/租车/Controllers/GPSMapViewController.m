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
