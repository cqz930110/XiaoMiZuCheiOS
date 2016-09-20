//
//  DTApiWrapper.m
//  zc
//
//  Created by _author on 16-09-20.
//  Copyright (c) _companyname. All rights reserved.
//

#import "DTApiWrapper.h"

@implementation DTApiWrapper

+(id)sharedInstance
{
    static id _sharedInstance = nil;
    if (!_sharedInstance) {
        _sharedInstance = [[[self class] alloc] init];
    }
    
    return _sharedInstance;
}

-(NSDictionary*)wrapCommonParamsWithGetParams:(NSDictionary*)getParams postDatas:(NSDictionary*)postDatas
{
    NSMutableDictionary *combindedGetParams = [NSMutableDictionary dictionaryWithDictionary:getParams];
    NSMutableDictionary *combindedPostDatas = [NSMutableDictionary dictionaryWithDictionary:postDatas];
    
    NSDictionary *commonParams = [self commonParams];
    [combindedGetParams addEntriesFromDictionary:[commonParams objectForKey:@"getParams"]];
    [combindedPostDatas addEntriesFromDictionary:[commonParams objectForKey:@"postDatas"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:combindedGetParams, @"getParams", combindedPostDatas, @"postDatas", nil];
}




-(void)dealloc
{

	[super dealloc];
}

/*
	Project Name:zc
*/
-(NSDictionary*)commonParams
{
	NSMutableDictionary *getParams = [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary *postDatas = [NSMutableDictionary dictionaryWithCapacity:5];


	

	return [NSDictionary dictionaryWithObjectsAndKeys:getParams, @"getParams", postDatas, @"postDatas", nil];
}
/*
	Api:登录, 
	@param POST loginName 
	@param POST password 
	@param POST clientId 
	@param POST platform 
*/
-(NSDictionary*)LoginName:(NSString*)p_loginName p_password:(NSString*)p_password p_clientId:(NSString*)p_clientId p_platform:(NSString*)p_platform 
{
	NSMutableDictionary *getParams = [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary *postDatas = [NSMutableDictionary dictionaryWithCapacity:5];


	
	if (p_loginName) [postDatas setObject:p_loginName forKey:@"loginName"];
	if (p_password) [postDatas setObject:p_password forKey:@"password"];
	if (p_clientId) [postDatas setObject:p_clientId forKey:@"clientId"];
	if (p_platform) [postDatas setObject:p_platform forKey:@"platform"];

	return [self wrapCommonParamsWithGetParams:getParams postDatas:postDatas];
}



@end
