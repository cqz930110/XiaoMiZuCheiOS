//
//  _root_.m
//  zc
//
//  Created by _author on 16-08-09.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "_root_.h"
#import "DTApiBaseBean.h"
#import "data.h"


@implementation _root_

@synthesize code = _code;
@synthesize data = _data;
@synthesize errmsg = _errmsg;

-(void)dealloc
{
	[_code release];
	[_data release];
	[_errmsg release];
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_NUMBER(code, @"0");
		self.data = [DTApiBaseBean objectForKey:@"data" inDictionary:dict withClass:[data class]];
		DTAPI_DICT_ASSIGN_STRING(errmsg, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(code);
	DTAPI_DICT_EXPORT_BEAN(data);
	DTAPI_DICT_EXPORT_BASICTYPE(errmsg);
    return md;
}
@end
