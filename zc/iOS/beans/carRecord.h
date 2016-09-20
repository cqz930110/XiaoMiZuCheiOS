//
//  carRecord.h
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface carRecord : NSObject
{
	NSNumber *_carId;
	NSString *_expectEndTime;
	NSNumber *_id;
	NSString *_startTime;
}


@property (nonatomic, copy) NSNumber *carId;
@property (nonatomic, copy) NSString *expectEndTime;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *startTime;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 