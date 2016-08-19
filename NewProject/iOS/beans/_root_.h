//
//  _root_.h
//  NewProject
//
//  Created by _author on 16-08-19.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface _root_ : NSObject
{
	NSString *_info;
	NSNumber *_state;
}


@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSNumber *state;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 