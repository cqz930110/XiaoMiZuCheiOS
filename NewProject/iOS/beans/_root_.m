//
//  _root_.m
//  NewProject
//
//  Created by _author on 16-08-19.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "_root_.h"
#import "DTApiBaseBean.h"


@implementation _root_

@synthesize info = _info;
@synthesize state = _state;

-(void)dealloc
{
	[_info release];
	[_state release];
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(info, @"");
		DTAPI_DICT_ASSIGN_NUMBER(state, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(info);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
    return md;
}
@end
