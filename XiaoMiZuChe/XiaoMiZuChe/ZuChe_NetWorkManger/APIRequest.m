//
//  APIRequest.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "APIRequest.h"
#import "ZhouDao_NetWorkManger.h"
#import "SchoolData.h"//学校
#import "UserData.h"
#import "GcNoticeUtil.h"
#import "BasicData.h"

@implementation APIRequest


#pragma mark -验证验证码
+ (void)VerifyTheMobileWithphone:(NSString *)phone
                        withcode:(NSString *)code
                  RequestSuccess:(void (^)())success
                            fail:(void (^)())fail
{// 468 验证码错误  474没有打开服务端验证开关  200 验证成功
    
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:phone,@"phone",SMSAPPKEY,@"appkey",@"86",@"zone",code,@"code", nil];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:VerifyTheMobile parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"status"]];
        if ([status isEqualToString:@"200"]) {
            success();
        }else {
            fail();
        }
    } fail:^{
        fail();

    }];
}

#pragma mark - 根据省市区获取学校
+ (void)getSchoolsWithProvince:(NSString *)province
                      withCity:(NSString *)city
                      witharea:(NSString *)area
                RequestSuccess:(void (^)(NSMutableDictionary *dict))success
                          fail:(void (^)())fail
{
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:province,@"province",city,@"city",area,@"area", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,GETSCHOOLURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSArray *arr = jsonDic[@"data"];
        __block NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SchoolData *model = [[SchoolData alloc] initWithDictionary:dic];
            [dictionary setObject:[NSString stringWithFormat:@"%@",model.id] forKey:model.name];
        }];
        success(dictionary);
    } fail:^{
        fail();
    }];
}
#pragma mark -  用户注册接口
+ (void)registerUserWithPhone:(NSString *)phone
                 withpassword:(NSString *)password
                 withclientId:(NSString *)clientId
                 withplatform:(NSString *)platform
               RequestSuccess:(void (^)())success
                         fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:phone,@"phone",password,@"password",clientId,@"clientId",platform,@"platform", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,REGISTERUSERURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        UserData *m_user = [[UserData alloc] initWithDictionary:dataDic];
        [PublicFunction shareInstance].m_bLogin = YES;
        [PublicFunction shareInstance].m_user = m_user;
        [USER_D setObject:phone forKey:USERNAME];
        [USER_D setObject:password forKey:USERKEY];
        [USER_D synchronize];
        [GcNoticeUtil sendNotification:DECIDEISLOGIN];

        success();
    } fail:^{
        [SVProgressHUD dismiss];
        fail();
    }];
}
#pragma mark - 完善用户资料接口
+ (void)perfectUserDataWithPostDict:(NSDictionary *)dictionary
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,PERFECTUSERURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dictionary isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        fail();
    }];
}
#pragma mark - 用户登录接口
+ (void)checkLoginUserWithLoginName:(NSString *)loginName
                       withpassword:(NSString *)password
                       withclientId:(NSString *)clientId
                       withplatform:(NSString *)platform
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:loginName,@"loginName",password,@"password",clientId,@"clientId",platform,@"platform", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,LOGINURLSTRING];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        UserData *m_user = [[UserData alloc] initWithDictionary:dataDic];
        [PublicFunction shareInstance].m_bLogin = YES;
        [PublicFunction shareInstance].m_user = m_user;
        [GcNoticeUtil sendNotification:DECIDEISLOGIN];
        [USER_D setObject:loginName forKey:USERNAME];
        [USER_D setObject:password forKey:USERKEY];
        [USER_D synchronize];
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        fail();
    }];
}
#pragma mark - 重置密码接口
+ (void)resetPasswordWithuserId:(NSString *)userId
                   withpassword:(NSString *)password
                 RequestSuccess:(void (^)())success
                           fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:userId,@"userId",password,@"password", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RESETPASSWORD];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        [USER_D setObject:password forKey:USERKEY];
        [USER_D synchronize];
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        fail();
    }];
}
#pragma mark - 验证用户是否存在
+ (void)rcheckUserByPhoneWithPhone:(NSString *)phone
                    RequestSuccess:(void (^)())success
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?phone=%@",kProjectBaseUrl,CHECKUSERBYPHONE,phone];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:NO success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSString *userId = jsonDic[@"data"];
        [PublicFunction shareInstance].userId = userId;
        success();
    } fail:^{
    }];
}
 #pragma mark -   获取用户资料接口
+ (void)getUserInfoWithUserId:(NSString *)userId
               RequestSuccess:(void (^)(id obj))success
                         fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?userId=%@",kProjectBaseUrl,GETUSERINFOURL,userId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSDictionary *dict = jsonDic[@"data"];
        BasicData *model = [[BasicData alloc] initWithDictionary:dict];
        success(model);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}

 #pragma mark -   修改用户资料接口
+ (void)updateUserDataWithPostDict:(NSDictionary *)dictionary
                     withURLString:(NSString *)urlString
                    RequestSuccess:(void (^)())success
                              fail:(void (^)())fail
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dictionary isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        fail();
    }];
}
#pragma mark - 自动登录
+ (void)automaticLoginEventResponse
{
    NSString *loginName = [USER_D objectForKey:USERNAME];
    NSString *password = [USER_D objectForKey:USERKEY];
    if (loginName.length>0)
    {
        UIDevice *device = [UIDevice currentDevice];
        NSString *deviceUDID = [NSString stringWithFormat:@"%@",device.identifierForVendor];
        NSArray *array = [deviceUDID componentsSeparatedByString:@">"];
        NSString *udidStr = array[1];
        NSString *tempStr = [udidStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *aliasString = [APIRequest trimStringUUID:(NSMutableString *)tempStr];
        
        NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:loginName,@"loginName",password,@"password",aliasString,@"clientId",[NSString stringWithFormat:@"iOS%@",device.systemVersion],@"platform", nil];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,LOGINURLSTRING];
        [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
            
            [SVProgressHUD dismiss];
            NSUInteger errorcode = [jsonDic[@"code"] integerValue];
            if (errorcode !=1) {
                [GcNoticeUtil sendNotification:DECIDEISLOGIN];
                return ;
            }
            NSDictionary *dataDic = jsonDic[@"data"];
            UserData *m_user = [[UserData alloc] initWithDictionary:dataDic];
            [PublicFunction shareInstance].m_bLogin = YES;
            [PublicFunction shareInstance].m_user = m_user;
            
            [GcNoticeUtil sendNotification:DECIDEISLOGIN];
            
        } fail:^{
            [GcNoticeUtil sendNotification:DECIDEISLOGIN];
        }];
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GcNoticeUtil sendNotification:DECIDEISLOGIN];
        });
    }
}
#pragma mark - 替换字串
+ (NSString *)trimStringUUID:(NSMutableString *)aStr
{
    //2 替换%2
    NSString *search2 = @"%2";
    NSString *replace2 = @"";
    NSRange range2 = [aStr rangeOfString:search2];
    while (range2.location != NSNotFound)
    {
        [aStr replaceCharactersInRange:range2 withString:replace2];
        range2 = [aStr rangeOfString:search2];
    }
    //查找全部匹配的，并替换  -
    NSString *search1 = @"-";
    NSString *replace1 = @"";
    NSRange range1 = [aStr rangeOfString:search1];
    while (range1.location != NSNotFound)
    {
        [aStr replaceCharactersInRange:range1 withString:replace1];
        range1 = [aStr rangeOfString:search1];
    }
    return aStr;
}

@end
