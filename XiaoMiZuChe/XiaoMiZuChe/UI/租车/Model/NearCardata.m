//
//  data.m
//  电动车秘书
//
//  Created by _author on 16-02-28.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "NearCardata.h"
#import "DTApiBaseBean.h"


@implementation NearCardata

@synthesize carId = _carId;
@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize carportName = _carportName;
@synthesize distance = _distance;



-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_NUMBER(carId, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lat, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lon, @"0");
		DTAPI_DICT_ASSIGN_STRING(carportName, @"");
        DTAPI_DICT_ASSIGN_STRING(distance, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(carId);
	DTAPI_DICT_EXPORT_BASICTYPE(lat);
	DTAPI_DICT_EXPORT_BASICTYPE(lon);
	DTAPI_DICT_EXPORT_BASICTYPE(carportName);
    DTAPI_DICT_EXPORT_BASICTYPE(distance);

    return md;
}
@end
