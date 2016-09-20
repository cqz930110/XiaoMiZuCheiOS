//
//  DTApiCaller.m
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

#import "DTApiCaller.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DTApiWrapper.h"

#define DTAPI_REQUEST_TIMEOUT 10

@implementation DTApiCaller

-(id)init
{
    if (self = [super init])
    {
        _dtApiWrapper = [DTApiWrapper sharedInstance];
    }
    
    return self;
}

/*
	Api:登录, 
	@param POST loginName 
	@param POST password 
	@param POST clientId 
	@param POST platform 
*/
-(ASIHTTPRequest*)LoginName:(NSString*)p_loginName p_password:(NSString*)p_password p_clientId:(NSString*)p_clientId p_platform:(NSString*)p_platform delegate:(id)delegate
{
	NSDictionary *wrapper = [_dtApiWrapper LoginName:p_loginName p_password:p_password p_clientId:p_clientId p_platform:p_platform ];

		return [DTApiCaller requestWithName:kRequest_ baseUrl:@"http://api.xiaomiddc.com/app/checkLogin.do" getParams:[wrapper objectForKey:@"getParams"] postDatas:[wrapper objectForKey:@"postDatas"] delegate:delegate];
}



#pragma mark -
#pragma mark *************** Basic caller method based on ASIHTTPRequest ******************

/*
 Last Api building method, return a ASIHTTPRequest object, the object will not start immediately,
 the receiver controller should do the start manually
 */

+(ASIHTTPRequest*)requestWithName:(NSString*)apiName
                          baseUrl:(NSString*)baseUrl
                        getParams:(NSDictionary*)getParams
                        postDatas:(NSDictionary*)postDatas
                         delegate:(id)delegate
{
    NSString *encodedUrlString = [DTApiCaller encodedUrlForUrlPrefix:baseUrl params:getParams encoding:NSUTF8StringEncoding];
    NSURL *encodedUrl = [NSURL URLWithString:encodedUrlString];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:apiName, @"apiName", nil];
    
    if (postDatas.count > 0)
    {
        ASIFormDataRequest *postRequest = [[ASIFormDataRequest alloc] initWithURL:encodedUrl];
        
        [postRequest setDelegate:delegate];
        postRequest.timeOutSeconds = DTAPI_REQUEST_TIMEOUT;
        postRequest.shouldAttemptPersistentConnection = NO;
        postRequest.userInfo = userInfo;
        
        for (NSString *key in [postDatas allKeys])
        {
            id value = [postDatas objectForKey:key];
            if ([value isKindOfClass:[NSData class]])
            {
                [postRequest addData:value forKey:key];
            }
            else
            {
                [postRequest addPostValue:value forKey:key];
            }
        }
        
        return [postRequest autorelease];
    }
    else
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:encodedUrl];
        [request setDelegate:delegate];
        request.timeOutSeconds = DTAPI_REQUEST_TIMEOUT;
        request.shouldAttemptPersistentConnection = NO;
        request.userInfo = userInfo;
        
        return [request autorelease];
    }
}

/*
 tool method for generating encoded GET url
 */
+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params encoding:(NSStringEncoding)encoding
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    [ms appendString:prefix];
    
    NSArray *keys = [params allKeys];
    for (int i=0; i<keys.count; i++)
    {
        NSString *k = [keys objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@", [params objectForKey:k]];
        if (i != 0) {
            [ms appendString:@"&"];
        }
        
        [ms appendFormat:@"%@=%@", k, value];
    }
    
    return [ms stringByAddingPercentEscapesUsingEncoding:encoding];
}

#pragma mark -
#pragma mark *************** Method for running demo ******************
-(ASIHTTPRequest*)demoRunApi:(NSString*)apiName group:(NSString*)groupName delegate:(id)delegate
{
	//Setting common params, you may do this some where else


	if ([apiName isEqualToString:@"登录"] && [groupName isEqualToString:@"Group"]) {
		return [self p_LoginName:@"13162079587" p_password:@"f7cd0921d8fd4d326b7f73ec8df8c59d" p_clientId:@"0FA20EA4600F14DB49985AE0B8CCE8FBF" p_platform:@"iOS9.3" delegate:delegate];
	}
	return nil;
}


@end