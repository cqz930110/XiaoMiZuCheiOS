//
//  DTApiWrapper.h
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

@interface DTApiWrapper : NSObject
{
}

/*
	Project Name:zc
*/
;

-(NSDictionary*)commonParams;
/*
	Api:登录, 
	@param POST loginName 
	@param POST password 
	@param POST clientId 
	@param POST platform 
*/
-(NSDictionary*)LoginName:(NSString*)p_loginName p_password:(NSString*)p_password p_clientId:(NSString*)p_clientId p_platform:(NSString*)p_platform ;



+(id)sharedInstance;
@end