//
//  data.m
//  zc
//
//  Created by _author on 16-08-09.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "UserData.h"
#import "DTApiBaseBean.h"


@implementation UserData

@synthesize headPic = _headPic;
@synthesize phone = _phone;
@synthesize regTime = _regTime;
@synthesize userId = _userId;
@synthesize userToken = _userToken;
@synthesize vip = _vip;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(headPic, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(regTime, @"");
		DTAPI_DICT_ASSIGN_NUMBER(userId, @"0");
		DTAPI_DICT_ASSIGN_STRING(userToken, @"");
		DTAPI_DICT_ASSIGN_NUMBER(vip, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(headPic);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(regTime);
	DTAPI_DICT_EXPORT_BASICTYPE(userId);
	DTAPI_DICT_EXPORT_BASICTYPE(userToken);
	DTAPI_DICT_EXPORT_BASICTYPE(vip);
    return md;
}
@end
