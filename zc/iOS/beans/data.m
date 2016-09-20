//
//  data.m
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "data.h"
#import "DTApiBaseBean.h"
#import "carRecord.h"


@implementation data

@synthesize address = _address;
@synthesize area = _area;
@synthesize carRecord = _carRecord;
@synthesize city = _city;
@synthesize headPic = _headPic;
@synthesize idNum = _idNum;
@synthesize phone = _phone;
@synthesize province = _province;
@synthesize regTime = _regTime;
@synthesize schoolId = _schoolId;
@synthesize schoolName = _schoolName;
@synthesize sex = _sex;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize userToken = _userToken;
@synthesize userType = _userType;
@synthesize vip = _vip;

-(void)dealloc
{
	[_address release];
	[_area release];
	[_carRecord release];
	[_city release];
	[_headPic release];
	[_idNum release];
	[_phone release];
	[_province release];
	[_regTime release];
	[_schoolId release];
	[_schoolName release];
	[_sex release];
	[_userId release];
	[_userName release];
	[_userToken release];
	[_userType release];
	[_vip release];
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(area, @"");
		self.carRecord = [DTApiBaseBean objectForKey:@"carRecord" inDictionary:dict withClass:[carRecord class]];
		DTAPI_DICT_ASSIGN_STRING(city, @"");
		DTAPI_DICT_ASSIGN_STRING(headPic, @"");
		DTAPI_DICT_ASSIGN_STRING(idNum, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(province, @"");
		DTAPI_DICT_ASSIGN_STRING(regTime, @"");
		DTAPI_DICT_ASSIGN_NUMBER(schoolId, @"0");
		DTAPI_DICT_ASSIGN_STRING(schoolName, @"");
		DTAPI_DICT_ASSIGN_NUMBER(sex, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(userId, @"0");
		DTAPI_DICT_ASSIGN_STRING(userName, @"");
		DTAPI_DICT_ASSIGN_STRING(userToken, @"");
		DTAPI_DICT_ASSIGN_NUMBER(userType, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(vip, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(area);
	DTAPI_DICT_EXPORT_BEAN(carRecord);
	DTAPI_DICT_EXPORT_BASICTYPE(city);
	DTAPI_DICT_EXPORT_BASICTYPE(headPic);
	DTAPI_DICT_EXPORT_BASICTYPE(idNum);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(province);
	DTAPI_DICT_EXPORT_BASICTYPE(regTime);
	DTAPI_DICT_EXPORT_BASICTYPE(schoolId);
	DTAPI_DICT_EXPORT_BASICTYPE(schoolName);
	DTAPI_DICT_EXPORT_BASICTYPE(sex);
	DTAPI_DICT_EXPORT_BASICTYPE(userId);
	DTAPI_DICT_EXPORT_BASICTYPE(userName);
	DTAPI_DICT_EXPORT_BASICTYPE(userToken);
	DTAPI_DICT_EXPORT_BASICTYPE(userType);
	DTAPI_DICT_EXPORT_BASICTYPE(vip);
    return md;
}
@end
