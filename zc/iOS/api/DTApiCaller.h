//
//  DTApiCaller.h
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

#define kProjectBaseUrl @"http://api.xiaomiddc.com/"

#define kRequest_ @"登录"


@class ASIHTTPRequest;
@class DTApiWrapper;

@interface DTApiCaller : NSObject
{
    DTApiWrapper *_dtApiWrapper;
}

/*
	Api:登录, 
	@param POST loginName 
	@param POST password 
	@param POST clientId 
	@param POST platform 
*/
-(ASIHTTPRequest*)LoginName:(NSString*)p_loginName p_password:(NSString*)p_password p_clientId:(NSString*)p_clientId p_platform:(NSString*)p_platform delegate:(id)delegate;



@end
