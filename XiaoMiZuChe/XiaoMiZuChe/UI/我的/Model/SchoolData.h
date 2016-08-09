//
//  data.h
//  zc
//
//  Created by _author on 16-08-09.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface SchoolData : NSObject
{
	NSString *_address;
	NSString *_area;
	NSString *_city;
	NSString *_contact;
	NSString *_createTime;
	NSNumber *_id;
	NSNumber *_lat;
	NSNumber *_lon;
	NSString *_name;
	NSString *_phone;
	NSString *_province;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 