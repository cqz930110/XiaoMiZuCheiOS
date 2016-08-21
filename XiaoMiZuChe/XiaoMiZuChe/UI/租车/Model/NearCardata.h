//
//  data.h
//  电动车秘书
//
//  Created by _author on 16-02-28.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface NearCardata : NSObject
{
	NSNumber *_carId;
	NSNumber *_lat;
	NSNumber *_lon;
    NSString *_carportName;
    NSString *_distance;
}


@property (nonatomic, copy) NSNumber *carId;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lon;
@property (nonatomic, copy) NSString *carportName;
@property (nonatomic, copy) NSString *distance;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 