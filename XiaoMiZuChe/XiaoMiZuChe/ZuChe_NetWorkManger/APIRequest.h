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
@end
