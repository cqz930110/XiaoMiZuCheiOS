//
//  data.m
//  zc
//
//  Created by _author on 16-08-11.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "BasicData.h"
#import "DTApiBaseBean.h"
#import "carRecord.h"


@implementation BasicData

@synthesize address = _address;
@synthesize area = _area;
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
@synthesize carRecord = _carRecord;
@synthesize startTime = _startTime;
@synthesize expireTime = _expireTime;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(area, @"");
		DTAPI_DICT_ASSIGN_STRING(city, @"");
		DTAPI_DICT_ASSIGN_STRING(headPic, @"");
		DTAPI_DICT_ASSIGN_STRING(idNum, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(province, @"");
		DTAPI_DICT_ASSIGN_STRING(regTime, @"");
        DTAPI_DICT_ASSIGN_STRING(startTime, @"");
        DTAPI_DICT_ASSIGN_STRING(expireTime, @"");

		DTAPI_DICT_ASSIGN_NUMBER(schoolId, @"0");
		DTAPI_DICT_ASSIGN_STRING(schoolName, @"");
		DTAPI_DICT_ASSIGN_NUMBER(sex, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(userId, @"0");
		DTAPI_DICT_ASSIGN_STRING(userName, @"");
		DTAPI_DICT_ASSIGN_STRING(userToken, @"");
		DTAPI_DICT_ASSIGN_NUMBER(userType, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(vip, @"0");
        self.carRecord = [DTApiBaseBean objectForKey:@"carRecord" inDictionary:dict withClass:[carRecord class]];

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(area);
	DTAPI_DICT_EXPORT_BASICTYPE(city);
	DTAPI_DICT_EXPORT_BASICTYPE(headPic);
	DTAPI_DICT_EXPORT_BASICTYPE(idNum);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(province);
	DTAPI_DICT_EXPORT_BASICTYPE(regTime);
    DTAPI_DICT_EXPORT_BASICTYPE(startTime);
    DTAPI_DICT_EXPORT_BASICTYPE(expireTime);

	DTAPI_DICT_EXPORT_BASICTYPE(schoolId);
	DTAPI_DICT_EXPORT_BASICTYPE(schoolName);
	DTAPI_DICT_EXPORT_BASICTYPE(sex);
	DTAPI_DICT_EXPORT_BASICTYPE(userId);
	DTAPI_DICT_EXPORT_BASICTYPE(userName);
	DTAPI_DICT_EXPORT_BASICTYPE(userToken);
	DTAPI_DICT_EXPORT_BASICTYPE(userType);
	DTAPI_DICT_EXPORT_BASICTYPE(vip);
    DTAPI_DICT_EXPORT_BEAN(carRecord);

    return md;
}
@end
