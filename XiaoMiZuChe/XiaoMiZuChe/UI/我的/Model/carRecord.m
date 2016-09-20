//
//  carRecord.m
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "carRecord.h"
#import "DTApiBaseBean.h"


@implementation carRecord

@synthesize carId = _carId;
@synthesize expectEndTime = _expectEndTime;
@synthesize id = _id;
@synthesize startTime = _startTime;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_NUMBER(carId, @"0");
		DTAPI_DICT_ASSIGN_STRING(expectEndTime, @"");
		DTAPI_DICT_ASSIGN_NUMBER(id, @"0");
		DTAPI_DICT_ASSIGN_STRING(startTime, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(carId);
	DTAPI_DICT_EXPORT_BASICTYPE(expectEndTime);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(startTime);
    return md;
}
@end
