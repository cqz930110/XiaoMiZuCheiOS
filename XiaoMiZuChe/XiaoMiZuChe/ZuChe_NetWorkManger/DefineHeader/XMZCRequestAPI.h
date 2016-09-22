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
#define kProjectBaseUrl         @"http://api.xiaomiddc.com/"
//测试地
//#define kProjectBaseUrl               @"http://www.gnets.cn:8088/xmzc_api/"

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
/*
 10  修改用户头像接口
 */
#define  UPDATEHEADPICURL             @"app/user/updateHeadPic.do"
/*
 11  获取租车卡年费接口
 */
#define  GETVIPYEARPRICEURL           @"app/user/getVipYearPrice.do"
/*
 12  办理租车卡接口
 */
#define  HANDLEVIPCARDURL             @"app/user/handleVipCard.do"
/*
 13  获取附近车辆接口
 */
#define  ARROUNDCARURLSTRING          @"app/map/arroundCar.do"
/*
 14  获取用户当前租车信息
 */
#define  GETUSERCARRECORDURL          @"app/car/getUserCarRecord.do?"
/*
 15  获取附近车辆接口
 */
#define  ARROUNDCARURLSTRING          @"app/map/arroundCar.do"
/*
 16  退出账号接口
 */
#define  LOGOUTURLSTRING              @"app/logout.do"
/*
 17  发送注册短信验证码接口
 */
#define  SENDREGISTERCODEURL          @"app/sms/sendRegCode.do"
/*
 18  发送找回密码短信验证码接口
 */
#define  SENDUPDATEPASSWORD           @"app/sms/sendUpdatePassCode.do"
/*
 19  发送租车短信验证码接口
 */
#define  SENDHIRECARURL               @"app/sms/sendHireCarCode.do"
/*
 20  发送还车短信验证码接口
 */
#define  SENDBACKCARURL              @"app/sms/sendBackCarCode.do"
/*
 21  租车接口
 */
#define  HIRECARURLSTRING            @"app/car/hireCar.do"

/*
 22  还车接口
 */
#define  BACKCARURL                  @"app/car/backCar.do"
/*
 23  获取车辆位置信息
 */
#define  CarLocationInfo             @"app/map/getLocInfo.do"

/*
 24  锁车接口
 */
#define LockCarURL                   @"app/lock/lockBike.do"
/*
 25  解锁接口
 */
#define UnLockCarURL                 @"app/lock/unLockBike.do"
/*
 26  查询轨迹
 */
#define SEARCHTRACK                  @"app/map/searchTrack.do"
/*
 27  打开电子围栏接口
 */
#define OPENVFURLSTRING              @"app/vf/openVf.do"
/*
 28  关闭电子围栏接口
 */
#define CLOSEVFURLSTRING             @"app/vf/closeVf.do"
/*
 29  租车卡续费支付接口
 */
#define RENEWCARDPAYAPI              @"app/pay/renewCardPay.do"
/*
 30  租车卡办理支付接口
 */
#define HANDLECARDPAYAPI             @"app/pay/handleCardPay.do"
/*
 31  支付成功后执行接口
 */
#define PAYNOTIFYURL                 @"app/pay/appPayNotify.do"

