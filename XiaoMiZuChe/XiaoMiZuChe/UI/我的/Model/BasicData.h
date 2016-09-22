//
//  data.h
//  zc
//
//  Created by _author on 16-08-11.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
@class carRecord;

@interface BasicData : NSObject
{
	NSString *_address;
	NSString *_area;
	NSString *_city;
	NSString *_headPic;
	NSString *_idNum;
	NSString *_phone;
	NSString *_province;
	NSString *_regTime;
	NSNumber *_schoolId;
	NSString *_schoolName;
	NSNumber *_sex;
	NSNumber *_userId;
	NSString *_userName;
	NSString *_userToken;
	NSNumber *_userType;
	NSNumber *_vip;
    NSString *_startTime;
    NSString *_expireTime;
    carRecord *_carRecord;

}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *idNum;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *regTime;
@property (nonatomic, copy) NSNumber *schoolId;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSNumber *sex;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSNumber *userType;
@property (nonatomic, copy) NSNumber *vip;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *expireTime;

@property (nonatomic, retain) carRecord *carRecord;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
