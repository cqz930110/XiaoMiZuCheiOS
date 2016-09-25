//
//  MsgView.m
//  GNETS
//
//  Created by cqz on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MsgView.h"
//#import <MapKit/MKReverseGeocoder.h>
//#import <MapKit/MKPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "carRecord.h"

@interface MsgView()<AMapSearchDelegate>
{
    CLLocationCoordinate2D _coordinate2D;

    AMapSearchAPI *_search;

}

@property (nonatomic,strong) UILabel *deviceLab;
@property (nonatomic,strong) UILabel *locationLab;
@property (nonatomic,strong) UILabel *onlineLab;
@property (nonatomic,strong) UILabel *AccLab;
@property (nonatomic,strong) UILabel *powerLab;
@property (nonatomic,strong) UILabel *lockLab;
@property (nonatomic,strong) UILabel *directionLab;
@property (nonatomic,strong) UILabel *lastLocLab;

@end

@implementation MsgView
- (id)initWithFrame:(CGRect)frame With:(LocInfodata *)model WithLocalCoordinate:(CLLocationCoordinate2D)coordinate2D
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 5.f;
        self.backgroundColor = LRRGBAColor(240, 240, 240, 1);
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = .5f;
        self.model = model;
        _coordinate2D = coordinate2D;
        [self initView];
        
    }
    return self;
}
- (void)initView
{
    NSString *str01 = @"租车开始:";
    NSString *str02 = @"租车结束:";

    NSString *str1 = @"设备编号:";
    NSString *str2 = @"定位状态:";
    NSString *str3 = @"在线状态:";
    NSString *str4 = @"ACC:";
    NSString *str5 = @"主电源:";
    NSString *str6 = @"锁车状态:";
    NSString *str7 = @"方向:";
    NSString *str8 = @"最后位置:";
    
    float width = self.frame.size.width;

    UILabel *lab01 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, [self sizeLabFontWith:str1], 15)];
    lab01.text = str01;
    lab01.font = Font_14;
    [self addSubview:lab01];
    UILabel *txtLab  = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab01)+3, 5, width-[self sizeLabFontWith:str1]-13, 15)];
    txtLab.font = Font_13;
    txtLab.text = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.startTime];
    [self addSubview:txtLab];

    UILabel *lab02 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab01)+5, [self sizeLabFontWith:str1], 15)];
    lab02.text = str02;
    lab02.font = Font_14;
    [self addSubview:lab02];
    UILabel *txtLab02  = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab02)+3, Orgin_y(lab01)+5, width-[self sizeLabFontWith:str1]-13, 15)];
    txtLab02.font = Font_13;
    txtLab02.text = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.expectEndTime];
    [self addSubview:txtLab02];


    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab02)+5, [self sizeLabFontWith:str1], 15)];
    lab1.text = str1;
    lab1.font = Font_14;
    [self addSubview:lab1];
    _deviceLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab1)+3, Orgin_y(lab02)+5, width-[self sizeLabFontWith:str1]-13, 15)];
    _deviceLab.font = Font_13;
    _deviceLab.text = [NSString stringWithFormat:@"%@",_model.carId];
    [self addSubview:_deviceLab];
    
    //2
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab1) +5, [self sizeLabFontWith:str2], 15)];
    lab2.font = Font_14;
    lab2.text = str2;
    [self addSubview:lab2];
    _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab2)+3, Orgin_y(lab1) +5, width-[self sizeLabFontWith:str2]-13, 15)];
    _locationLab.font = Font_13;
    _locationLab.text = @"卫星定位";
    [self addSubview:_locationLab];

    //3
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab2) +5, [self sizeLabFontWith:str3], 15)];
    lab3.font = Font_14;
    lab3.text = str3;
    [self addSubview:lab3];
    _onlineLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab3)+3, Orgin_y(lab2) +5, width-[self sizeLabFontWith:str3]-13, 15)];
    _onlineLab.font = Font_13;
    _onlineLab.text = [_model.isOnline isEqualToString:@"1"]?@"在线":@"不在线";
    [self addSubview:_onlineLab];

    //4
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab3) +5, [self sizeLabFontWith:str4], 15)];
    lab4.font = Font_14;
    lab4.text = str4;
    [self addSubview:lab4];
    _AccLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab4)+3, Orgin_y(lab3) +5, width-[self sizeLabFontWith:str4]-13, 15)];
    _AccLab.font = Font_13;
    _AccLab.text = [_model.acc isEqualToString:@"0"]?@"关闭":@"开启";
    [self addSubview:_AccLab];
    
    //5
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab4) +5, [self sizeLabFontWith:str5], 15)];
    lab5.font = Font_14;
    lab5.text = str5;
    [self addSubview:lab5];
    _powerLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab5)+3, Orgin_y(lab4) +5, width-[self sizeLabFontWith:str5]-13, 15)];
    _powerLab.font = Font_13;
    _powerLab.text = [_model.power isEqualToString:@"1"]?@"开启":@"关闭";
    [self addSubview:_powerLab];

    //6
    UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab5) +5, [self sizeLabFontWith:str6], 15)];
    lab6.font = Font_14;
    lab6.text = str6;
    [self addSubview:lab6];
    _lockLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab6)+3, Orgin_y(lab5) +5, width-[self sizeLabFontWith:str6]-13, 15)];
    _lockLab.font = Font_13;
    _lockLab.text = [_model.lock isEqualToString:@"0"]?@"未锁定":@"锁定";
    [self addSubview:_lockLab];
    
    //7
    UILabel *lab7 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab6) +5, [self sizeLabFontWith:str7], 15)];
    lab7.font = Font_14;
    lab7.text = str7;
    [self addSubview:lab7];
    _directionLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab7)+3, Orgin_y(lab6) +5, width-[self sizeLabFontWith:str7]-13, 15)];
    _directionLab.font = Font_13;
    
    CGFloat heading = [self.model.heading floatValue];
    _directionLab.text = [QZManager getHeadingDes:heading];
    [self addSubview:_directionLab];
    
    //8
    UILabel *lab8 = [[UILabel alloc] initWithFrame:CGRectMake(5, Orgin_y(lab7) +5, [self sizeLabFontWith:str8], 15)];
    lab8.font = Font_14;
    lab8.text = str8;
    [self addSubview:lab8];
    
    _lastLocLab = [[UILabel alloc] init];
    _lastLocLab.font = [UIFont systemFontOfSize:14.f];
    

    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",[PublicFunction shareInstance].m_user.province,[PublicFunction shareInstance].m_user.city,[PublicFunction shareInstance].m_user.area,[PublicFunction shareInstance].m_user.address];
    _lastLocLab.text = addressStr;
    _lastLocLab.numberOfLines = 0;
    [self addSubview:_lastLocLab];
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:_coordinate2D.latitude longitude:_coordinate2D.longitude];

    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //regeo.radius = 10000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    //CLGeocoder *geocoder=[[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location
//                   completionHandler:^(NSArray *placemarks,
//                                       NSError *error)
//     {
//         CLPlacemark *placemark=[placemarks firstObject];
//         _lastLocLab.text = placemark.name;
//         NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//               placemark.name,
//               placemark.country,
//               placemark.postalCode,
//               placemark.ISOcountryCode,
//               placemark.ocean,
//               placemark.inlandWater,
//               placemark.administrativeArea,
//               placemark.subAdministrativeArea,
//               placemark.locality,
//               placemark.subLocality,
//               placemark.thoroughfare,
//               placemark.subThoroughfare);
//     }];
    
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        
        NSDictionary *attribute = @{NSFontAttributeName:Font_14};
        CGSize size = [result boundingRectWithSize:CGSizeMake(157,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGRect dateFrame = CGRectMake(68, 184, size.width, size.height);
        _lastLocLab.text = result;
        _lastLocLab.frame = dateFrame;
        CGRect frame = self.frame;
        frame.size.height = size.height +184;
        
        frame.origin.y = self.frame.origin.y - (size.height + 184.f - 240);

        self.frame = frame;
        DLog(@"ReGeo: %@", result);
    }
}
- (CGFloat)sizeLabFontWith:(NSString *)aStr
{
    NSDictionary *attribute = @{NSFontAttributeName:Font_14};
    CGSize size = [aStr boundingRectWithSize:CGSizeMake(200,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return size.width;
    
}
//- (void)layoutSubviews
//{
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
