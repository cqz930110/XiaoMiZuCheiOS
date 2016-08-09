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


@interface UserData : NSObject
{
	NSString *_headPic;
	NSString *_phone;
	NSString *_regTime;
	NSNumber *_userId;
	NSString *_userToken;
	NSNumber *_vip;
}


@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *regTime;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSNumber *vip;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 