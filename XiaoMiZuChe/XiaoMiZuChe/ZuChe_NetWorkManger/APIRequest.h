//
//  APIRequest.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject

///*
// * 赔偿标准首页列表
// */
//+ (void)getcompensationList:(NSString *)comId
//                   withCity:(NSString *)city
//                   withYear:(NSString *)year
//             RequestSuccess:(void (^)(NSArray *arrays))success
//                       fail:(void (^)())fail;

/**
 *  验证验证码
 *
 *  @param phone   电话号码
 *  @param code    验证码
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)VerifyTheMobileWithphone:(NSString *)phone
                        withcode:(NSString *)code
                  RequestSuccess:(void (^)())success
                            fail:(void (^)())fail;
/**
 *  根据省市区获取学校
 *
 *  @param province 省
 *  @param city     市
 *  @param area     区
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)getSchoolsWithProvince:(NSString *)province
                        withCity:(NSString *)city
                           witharea:(NSString *)area
                  RequestSuccess:(void (^)(NSMutableDictionary *dict))success
                            fail:(void (^)())fail;
/**
 *  用户注册接口
 *
 *  @param phone    电话号码
 *  @param password MD5加密的密码
 *  @param clientId 客户端标识，用于推送
 *  @param platform 登录平台
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)registerUserWithPhone:(NSString *)phone
                      withpassword:(NSString *)password
                      withclientId:(NSString *)clientId
                 withplatform:(NSString *)platform
                RequestSuccess:(void (^)())success
                          fail:(void (^)())fail;

/**
 *  完善用户资料接口
 *
 *  @param dictionary post字典
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)perfectUserDataWithPostDict:(NSDictionary *)dictionary
               RequestSuccess:(void (^)())success
                         fail:(void (^)())fail;

/**
 *  用户登录接口
 *
 *  @param loginName 手机号或vip用户编号
 *  @param password  密码md5
 *  @param clientId 客户端标识，用于推送
 *  @param platform 登录平台
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)checkLoginUserWithLoginName:(NSString *)loginName
                 withpassword:(NSString *)password
                 withclientId:(NSString *)clientId
                 withplatform:(NSString *)platform
               RequestSuccess:(void (^)())success
                         fail:(void (^)())fail;




/**
 *  自动登录
 */
+ (void)automaticLoginEventResponse;
#pragma mark - 替换字串
+ (NSString *)trimStringUUID:(NSMutableString *)aStr;

@end
