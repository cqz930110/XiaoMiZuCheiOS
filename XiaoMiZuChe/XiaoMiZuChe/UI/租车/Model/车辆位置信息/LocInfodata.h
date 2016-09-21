//
//  data.h
//  电动车秘书
//
//  Created by _author on 16-02-28.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface LocInfodata : NSObject
{
	NSString *_acc;
	NSString *_address;
	NSNumber *_carId;
	NSNumber *_heading;
	NSString *_isOnline;
	NSNumber *_isOpenVf;
	NSNumber *_lat;
	NSString *_loc;
	NSString *_lock;
	NSNumber *_lon;
	NSString *_power;
	NSString *_satelliteTime;
	NSNumber *_sourceType;
	NSNumber *_speed;
    NSNumber *_vfLat;
    NSNumber *_vfLon;
    NSNumber *_vfStatus;
    
    NSNumber *_remainBattery;//剩余电量
    NSNumber *_upVoltage;//判断是否读取电量
    NSNumber *_voltage;//额定电压
    
    NSNumber *_controlType;//控制类型
}


@property (nonatomic, copy) NSString *acc;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSNumber *carId;
@property (nonatomic, copy) NSNumber *heading;
@property (nonatomic, copy) NSString *isOnline;
@property (nonatomic, copy) NSNumber *isOpenVf;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSString *loc;
@property (nonatomic, copy) NSString *lock;
@property (nonatomic, copy) NSNumber *lon;
@property (nonatomic, copy) NSString *power;
@property (nonatomic, copy) NSString *satelliteTime;
@property (nonatomic, copy) NSNumber *sourceType;
@property (nonatomic, copy) NSNumber *speed;
@property (nonatomic, copy) NSNumber *vfLat;
@property (nonatomic, copy) NSNumber *vfLon;
@property (nonatomic, copy) NSNumber *vfStatus;

@property (nonatomic, copy) NSNumber *remainBattery;
@property (nonatomic, copy) NSNumber *upVoltage;
@property (nonatomic, copy) NSNumber *voltage;

@property (nonatomic, copy) NSNumber *controlType;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 