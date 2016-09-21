//
//  data.m
//  电动车秘书
//
//  Created by _author on 16-02-28.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "LocInfodata.h"
#import "DTApiBaseBean.h"


@implementation LocInfodata

@synthesize acc = _acc;
@synthesize address = _address;
@synthesize carId = _carId;
@synthesize heading = _heading;
@synthesize isOnline = _isOnline;
@synthesize isOpenVf = _isOpenVf;
@synthesize lat = _lat;
@synthesize loc = _loc;
@synthesize lock = _lock;
@synthesize lon = _lon;
@synthesize power = _power;
@synthesize satelliteTime = _satelliteTime;
@synthesize sourceType = _sourceType;
@synthesize speed = _speed;
@synthesize vfLat = _vfLat;
@synthesize vfLon = _vfLon;
@synthesize vfStatus = _vfStatus;

@synthesize remainBattery = _remainBattery;
@synthesize upVoltage = _upVoltage;
@synthesize voltage = _voltage;
@synthesize controlType = _controlType;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(acc, @"");
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_NUMBER(carId, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(heading, @"0");
		DTAPI_DICT_ASSIGN_STRING(isOnline, @"");
		DTAPI_DICT_ASSIGN_NUMBER(isOpenVf, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lat, @"0");
		DTAPI_DICT_ASSIGN_STRING(loc, @"");
		DTAPI_DICT_ASSIGN_STRING(lock, @"");
		DTAPI_DICT_ASSIGN_NUMBER(lon, @"0");
		DTAPI_DICT_ASSIGN_STRING(power, @"");
		DTAPI_DICT_ASSIGN_STRING(satelliteTime, @"");
		DTAPI_DICT_ASSIGN_NUMBER(sourceType, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(speed, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(vfLat, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(vfLon, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(vfStatus, @"0");
        
        DTAPI_DICT_ASSIGN_NUMBER(remainBattery, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(upVoltage, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(voltage, @"0");
        DTAPI_DICT_ASSIGN_NUMBER(controlType, @"0");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(acc);
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(carId);
	DTAPI_DICT_EXPORT_BASICTYPE(heading);
	DTAPI_DICT_EXPORT_BASICTYPE(isOnline);
	DTAPI_DICT_EXPORT_BASICTYPE(isOpenVf);
	DTAPI_DICT_EXPORT_BASICTYPE(lat);
	DTAPI_DICT_EXPORT_BASICTYPE(loc);
	DTAPI_DICT_EXPORT_BASICTYPE(lock);
	DTAPI_DICT_EXPORT_BASICTYPE(lon);
	DTAPI_DICT_EXPORT_BASICTYPE(power);
	DTAPI_DICT_EXPORT_BASICTYPE(satelliteTime);
	DTAPI_DICT_EXPORT_BASICTYPE(sourceType);
	DTAPI_DICT_EXPORT_BASICTYPE(speed);
    
    DTAPI_DICT_EXPORT_BASICTYPE(vfLat);
    DTAPI_DICT_EXPORT_BASICTYPE(vfLon);
    DTAPI_DICT_EXPORT_BASICTYPE(vfStatus);

    DTAPI_DICT_EXPORT_BASICTYPE(remainBattery);
    DTAPI_DICT_EXPORT_BASICTYPE(upVoltage);
    DTAPI_DICT_EXPORT_BASICTYPE(voltage);
    DTAPI_DICT_EXPORT_BASICTYPE(controlType);

    return md;
}
@end
