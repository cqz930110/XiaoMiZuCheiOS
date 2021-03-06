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
#import "GcNoticeUtil.h"
#import "BasicData.h"
#import "NearCardata.h"//附近车辆
#import "carRecord.h"
#import "LocInfodata.h"
#import "JPUSHService.h"

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
    [MBProgressHUD showMBLoadingWithText:nil];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:phone,@"phone",password,@"password",clientId,@"clientId",platform,@"platform", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,REGISTERUSERURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        BasicData *m_user = [[BasicData alloc] initWithDictionary:dataDic];
        [PublicFunction shareInstance].m_bLogin = YES;
        [PublicFunction shareInstance].m_user = m_user;
        [USER_D setObject:phone forKey:USERNAME];
        [USER_D setObject:password forKey:USERKEY];
        [USER_D synchronize];
        [GcNoticeUtil sendNotification:DECIDEISLOGIN];
        [GcNoticeUtil sendNotification:LOGINSUCCESS];

        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark - 完善用户资料接口
+ (void)perfectUserDataWithPostDict:(NSDictionary *)dictionary
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,PERFECTUSERURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dictionary isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
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
    [MBProgressHUD showMBLoadingWithText:nil];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:loginName,@"loginName",password,@"password",clientId,@"clientId",platform,@"platform", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,LOGINURLSTRING];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        BasicData *m_user = [[BasicData alloc] initWithDictionary:dataDic];
        [PublicFunction shareInstance].m_bLogin = YES;
        [PublicFunction shareInstance].m_user = m_user;
        [GcNoticeUtil sendNotification:DECIDEISLOGIN];
        [GcNoticeUtil sendNotification:LOGINSUCCESS];

        [USER_D setObject:loginName forKey:USERNAME];
        [USER_D setObject:password forKey:USERKEY];
        [USER_D synchronize];
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark - 还车
+ (void)backCarEventWithForce:(NSString *)force
                       RequestSuccess:(void (^)())success
                                 fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *idString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.id];
    NSString *userIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];

    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:userIdString,@"userId",idString,@"id",force,@"force", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,BACKCARURL];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        if (errorcode !=1) {
            fail();
            return ;
        }
        [JKPromptView showWithImageName:nil message:msg];
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

}
#pragma mark - 重置密码接口
+ (void)resetPasswordWithuserId:(NSString *)userId
                   withpassword:(NSString *)password
                 RequestSuccess:(void (^)())success
                           fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:userId,@"userId",password,@"password", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RESETPASSWORD];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
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
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark - 验证用户是否存在
+ (void)rcheckUserByPhoneWithPhone:(NSString *)phone
                    RequestSuccess:(void (^)())success
                              fail:(void (^)())fail
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?phone=%@",kProjectBaseUrl,CHECKUSERBYPHONE,phone];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:NO success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            // {"code":1,"errmsg":"请求成功","data":888903}

//            NSString *msg = jsonDic[@"errmsg"];
//            [JKPromptView showWithImageName:nil message:msg];
            fail();
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
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?userId=%@",kProjectBaseUrl,GETUSERINFOURL,userId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
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
        [MBProgressHUD hideHUD];
    }];
}

 #pragma mark -   修改用户资料接口
+ (void)updateUserDataWithPostDict:(NSDictionary *)dictionary
                     withURLString:(NSString *)urlString
                    RequestSuccess:(void (^)())success
                              fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dictionary isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark - 修改用户头像接口
+ (void)updateHeadPicWithParaDict:(NSDictionary *)dictionary
                   RequestSuccess:(void (^)(NSString *headUrlString))success
                             fail:(void (^)())fail
{    [MBProgressHUD showMBLoadingWithText:nil];
    NSDictionary *dict1  = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId" ,nil];

    [ZhouDao_NetWorkManger postUploadWithUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,UPDATEHEADPICURL]  parameters:dict1 WithImgDic:dictionary success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        NSDictionary *dataDict = jsonDic[@"data"];
        BasicData *basicModel = [[BasicData alloc] initWithDictionary:dataDict];
        success(basicModel.headPic);
    } fail:^{
        fail();
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - 获取租车卡年费接口
+ (void)getVipYearPriceRequestSuccess:(void (^)(NSString *moneyString))success
                                 fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,GETVIPYEARPRICEURL];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSString *moneyString = jsonDic[@"data"];
        success(moneyString);
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark -  办理租车卡接口
+ (void)handleVipCardRequestSuccess:(void (^)())success
                               fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,HANDLEVIPCARDURL];
    NSString *userId = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dict isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}
#pragma mark - 获取用户当前租车信息
+ (void)getUserCarRecordRequestSuccess:(void (^)())success
                                  fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *userId = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];
    NSString *urlString = [NSString stringWithFormat:@"%@%@userId%@",kProjectBaseUrl,GETUSERCARRECORDURL,userId];
    
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        success();
    } fail:^{
        fail();
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - 获取附近车辆接口
+ (void)getArroundCarWithLon:(NSString *)lon withLat:(NSString *)lat RequestSuccess:(void (^)(NSArray *arrays))success fail:(void (^)())fail
{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"NearCarCount" ofType:@"txt"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    NSUInteger errorcode = [dict[@"code"] integerValue];
//    NSString *msg = dict[@"errmsg"];
//    if (errorcode !=1) {
//        [JKPromptView showWithImageName:nil message:msg];
//        fail();
//        return;
//    }
//    NSArray *arr = dict[@"data"];
//    if (arr.count == 0) {
//        [JKPromptView showWithImageName:nil message:msg];
//        fail();
//        return;
//    }
//    
//    NSMutableArray *arrays = [NSMutableArray array];
//    [arr enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        NearCardata *model = [[NearCardata alloc] initWithDictionary:objDict];
//        [arrays addObject:model];
//    }];
//    success(arrays);

    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,ARROUNDCARURLSTRING];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lon,@"lon",lat,@"lat", nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return;
        }
        NSArray *arr = dict[@"data"];
        if (arr.count == 0) {
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return;
        }
        
        NSMutableArray *arrays = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NearCardata *model = [[NearCardata alloc] initWithDictionary:objDict];
            [arrays addObject:model];
        }];
        success(arrays);
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}

#pragma mark - 租车

+ (void)applyForRentingACarWithCarId:(NSString *)carId
                      RequestSuccess:(void (^)())success
                                fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",carId,@"carId", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,HIRECARURLSTRING];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dict isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        
        NSDictionary *dataDic = jsonDic[@"data"];
        carRecord *model = [[carRecord alloc] initWithDictionary:dataDic];
        [PublicFunction shareInstance].m_user.carRecord = model;
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];

    
}
#pragma mark - 退出账号接口 get请求
+ (void)getLogoutWithURLString:(NSString *)urlStr
                RequestSuccess:(void (^)())success
                          fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlStr isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        NSString *msg = jsonDic[@"errmsg"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            fail();
            return ;
        }
        success();
    } fail:^{
        fail();
        [MBProgressHUD hideHUD];
    }];

}
#pragma mark - 发送短信
+ (void)sendSMStWithURLString:(NSString *)urlStr
               withDictionary:(NSDictionary *)dictionary
               RequestSuccess:(void (^)(NSString *code,NSString *expireTime))success
                         fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlStr  parameters:dictionary isNeedHead:NO success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        
        [JKPromptView showWithImageName:nil message:@"验证码已发送至手机"];
        NSDictionary *dataDic = jsonDic[@"data"];
        NSString *codeString = dataDic[@"code"];
        NSString *timeString = dataDic[@"expireTime"];
        success(codeString,timeString);
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];

}
#pragma -mark 执行远程锁车命令
+ (void)lockCarRequestSuccess:(void (^)())success
                         fail:(void (^)())fail
{
    //    [SVProgressHUD showInfoWithStatus:@"正在关闭语音寻车，请稍等"];
    NSString *url =[NSString stringWithFormat:@"%@%@?carId=%@&userId=%@&para=%@",kProjectBaseUrl,LockCarURL,[PublicFunction shareInstance].m_user.carRecord.carId,[PublicFunction shareInstance].m_user.userId,@"0"];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:jsonDic[@"errmsg"]];
        if ([jsonDic[@"code"] intValue] == 1) {
            success();
            //            [JKPromptView showWithImageName:nil message:@"开启命令发送成功"];
        }else{
            fail();
            //            [JKPromptView showWithImageName:nil message:@"开启命令发送失败"];
        }
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 执行远程解锁命令
+ (void)unlockCarRequestSuccess:(void (^)())success
                           fail:(void (^)())fail
{

    NSString *url = [NSString stringWithFormat:@"%@%@?carId=%@&userId=%@&para=%@",kProjectBaseUrl,UnLockCarURL,[PublicFunction shareInstance].m_user.carRecord.carId,[PublicFunction shareInstance].m_user.userId,@"0"];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url isNeedHead:YES success:^(NSDictionary *jsonDic) {
        /*
         {
         "code": 1,
         "errmsg": "解锁命令发送成功"
         }
         */
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:jsonDic[@"errmsg"]];
        
        if ([jsonDic[@"code"] intValue] == 1) {
            success();
            //            [JKPromptView showWithImageName:nil message:@"关闭命令发送成功"];
            
        }else{
            fail();
            //            [JKPromptView showWithImageName:nil message:@"关闭命令发送失败"];
        }
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - 租车卡办理支付接口
+ (void)payTheVIPFeesWithUrlString:(NSString *)urlString withMode:(NSString *)modeString
                    RequestSuccess:(void (^)(NSString *orderInfo,NSString *orderId))success
                              fail:(void (^)())fail
{
    [MBProgressHUD showMBLoadingWithText:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",modeString,@"payMode", nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dict isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        NSString *orderInfo = dataDic[@"orderInfo"];
        NSString *orderId = dataDic[@"orderId"];

        success(orderInfo,orderId);
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];
}

#pragma mark - 支付成功后执行接口
+ (void)paySuccessAPIWithOrderId:(NSString *)orderId
                  RequestSuccess:(void (^)())success
                            fail:(void (^)())fail
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,PAYNOTIFYURL];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",orderId,@"orderId", nil];
    [ZhouDao_NetWorkManger PostJSONWithUrl:urlString  parameters:dict isNeedHead:YES success:^(NSDictionary *jsonDic) {
        
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        [PublicFunction shareInstance].m_user = [[BasicData alloc] initWithDictionary:dataDic];
        success();
    } fail:^{
        [MBProgressHUD hideHUD];
        fail();
    }];

}
+ (void)getCarLocationInfomationRequestSuccess:(void (^)(id model))success
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?carId=%@&userId=%@",kProjectBaseUrl,CarLocationInfo,[PublicFunction shareInstance].m_user.carRecord.carId,[PublicFunction shareInstance].m_user.userId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:urlString isNeedHead:YES success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"code"] integerValue];
        if (errorcode !=1) {
            NSString *msg = jsonDic[@"errmsg"];
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dataDict = jsonDic[@"data"];
        LocInfodata *model = [[LocInfodata alloc] initWithDictionary:dataDict];
        success(model);
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark -
#pragma mark - 自动登录
+ (void)automaticLoginEventResponse
{
    NSString *loginName = [USER_D objectForKey:USERNAME];
    NSString *password = [USER_D objectForKey:USERKEY];
    if (loginName.length>0)
    {
        UIDevice *device = [UIDevice currentDevice];
        NSString *deviceUDID = [[device identifierForVendor] UUIDString];
        DLog(@"设备标识符:%@",deviceUDID);
        NSString *tempStr = [deviceUDID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *aliasString = [tempStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:loginName,@"loginName",password,@"password",aliasString,@"clientId",[NSString stringWithFormat:@"iOS%@",device.systemVersion],@"platform", nil];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,LOGINURLSTRING];
        [ZhouDao_NetWorkManger PostJSONWithUrl:urlString parameters:dict isNeedHead:NO success:^(NSDictionary *jsonDic) {
            
            [MBProgressHUD hideHUD];
            NSUInteger errorcode = [jsonDic[@"code"] integerValue];
            if (errorcode !=1) {
                [GcNoticeUtil sendNotification:DECIDEISLOGIN];
                return ;
            }
            
            [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
            }];
            NSDictionary *dataDic = jsonDic[@"data"];
            BasicData *m_user = [[BasicData alloc] initWithDictionary:dataDic];
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
