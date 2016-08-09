//
//  data.m
//  zc
//
//  Created by _author on 16-08-09.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "SchoolData.h"
#import "DTApiBaseBean.h"


@implementation SchoolData

@synthesize address = _address;
@synthesize area = _area;
@synthesize city = _city;
@synthesize contact = _contact;
@synthesize createTime = _createTime;
@synthesize id = _id;
@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize name = _name;
@synthesize phone = _phone;
@synthesize province = _province;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(area, @"");
		DTAPI_DICT_ASSIGN_STRING(city, @"");
		DTAPI_DICT_ASSIGN_STRING(contact, @"");
		DTAPI_DICT_ASSIGN_STRING(createTime, @"");
		DTAPI_DICT_ASSIGN_NUMBER(id, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lat, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(lon, @"0");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(province, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(area);
	DTAPI_DICT_EXPORT_BASICTYPE(city);
	DTAPI_DICT_EXPORT_BASICTYPE(contact);
	DTAPI_DICT_EXPORT_BASICTYPE(createTime);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(lat);
	DTAPI_DICT_EXPORT_BASICTYPE(lon);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(province);
    return md;
}
@end
