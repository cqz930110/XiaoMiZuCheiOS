//
//  _root_.h
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
@class data;


@interface _root_ : NSObject
{
	NSNumber *_code;
	data *_data;
	NSString *_errmsg;
}


@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, retain) data *data;
@property (nonatomic, copy) NSString *errmsg;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 