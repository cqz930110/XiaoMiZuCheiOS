//
//  XMZCRequestAPI.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 QZ. All rights reserved.
//

#ifndef XMZCRequestAPI_h
#define XMZCRequestAPI_h


#endif /* XMZCRequestAPI_h */

//线上
//#define kProjectBaseUrl         @""
//测试地
#define kProjectBaseUrl               @"http://www.gnets.cn:8088/xmzc_api/"

/*
 1 验证手机号
 */
#define  VerifyTheMobile              @"https://webapi.sms.mob.com/sms/verify"
/*
 2  根据省市区 获取学校
 */
#define  GETSCHOOLURL                 @"app/user/getSchools.do"
/*
 3  用户注册接口
 */
#define  REGISTERUSERURL              @"app/user/regUser.do"
/*
 4  完善用户资料接口
 */
#define  PERFECTUSERURL               @"app/user/perfectUserData.do"
/*
 5  用户登录接口
 */
#define  LOGINURLSTRING               @"app/checkLogin.do"
/*
 6  重置密码接口
 */
#define  RESETPASSWORD                @"app/user/resetPassword.do"
/*
 7  根据手机号验证用户是否存在接口
 */
#define  CHECKUSERBYPHONE             @"app/user/checkUserByPhone.do"
/*
 8  获取用户资料接口
 */
#define  GETUSERINFOURL               @"app/user/getUserInfo.do"
/*
 9  修改用户资料接口
 */
#define  UPDATEUSERDATAURL            @"app/user/updateUserData.do"

