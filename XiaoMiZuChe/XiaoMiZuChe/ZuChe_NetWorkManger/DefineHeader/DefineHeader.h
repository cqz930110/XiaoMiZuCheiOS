//
//  DefineHeader.h
//  GNETS
//
//  Created by tcnj on 16/2/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

/**
 *
 * color macros
 *
 **/

#define RGBACOLOR(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];
#define ramdomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1.0f]


/**
 *
 * frame macros
 *
 **/
//设备屏幕frame
#define kMainScreenFrameRect                                 [[UIScreen mainScreen] bounds]
//状态栏高度
#define kMainScreenStatusBarFrameRect                        [[UIApplication sharedApplication] statusBarFrame]
#define kMainScreenHeight                                    kMainScreenFrameRect.size.height
#define kMainScreenWidth                                     kMainScreenFrameRect.size.width
//减去状态栏和导航栏的高度
#define kScreenHeightNoStatusAndNoNaviBarHeight              (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-44.0f)
//减去状态栏和底部菜单栏高度
#define kScreenHeightNoStatusAndNoTabBarHeight               (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-49.0f)
//减去状态栏和底部菜单栏以及导航栏高度
#define kScreenHeightNoStatusAndNoTabBarNoNavBarHeight       (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-49.0f - 44.0f)
//底部工具栏高度
#define kTabBarHeight                                        49
//导航栏高度
#define kNavBarHeight                                        44

#define GET(str)                                             (str ? str : @"")

/**
 *
 * font
 macros
 *
 **/
#define Font_12        [UIFont  systemFontOfSize:12]
#define Font_13        [UIFont  systemFontOfSize:13]
#define Font_14        [UIFont  systemFontOfSize:14]
#define Font_15        [UIFont  systemFontOfSize:15]
#define Font_16        [UIFont  systemFontOfSize:16]
#define Font_17        [UIFont  systemFontOfSize:17]
#define Font_18        [UIFont  systemFontOfSize:18]
#define Font_20        [UIFont systemFontOfSize:20]
#define Font_21        [UIFont systemFontOfSize:21]
#define Font_24        [UIFont systemFontOfSize:24]

//旋转
#define REES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define ImgName(name) [UIImage imageNamed:@#name]

#define Orgin_y(container)   (container.frame.origin.y+container.frame.size.height)
#define Orgin_x(container)   (container.frame.origin.x+container.frame.size.width)




#define line_w 0.5
#define isTest 0

#define DATE_FORMAT_YMDHMS             @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_YMDHM               @"yyyy-MM-dd HH:mm"

/** 
 *  把是NSNull 类型的值替换成nil
 *  使用方法：contact.contactPhone = VerifyValue(contactDic[@"send_ContactPhone"]);
 */
#define VerifyValue(value)\
({id tmp;\
if ([value isKindOfClass:[NSNull class]])\
tmp = nil;\
else\
tmp = value;\
tmp;\
})\

/**
 * NSLog宏，限定仅在Debug时才打印,release不打印，防止拖慢程序运行
 */
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

//当前设备是否为 iPhone5
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//宏定义方法
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\


#define WEAKSELF typeof(self) __weak weakSelf = self;

#define USER_D [NSUserDefaults standardUserDefaults]


/**
 *
 * system  macros
 *
 **/

#define CurrentSystemVersion                    ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_VERSION_ABOVE_8                     (([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) ? (YES) : (NO))
#define IOS_VERSION_ABOVE_7                     (([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) ? (YES) : (NO))
#define IOS_VERSION_ABOVE_7_1                     (([[UIDevice currentDevice].systemVersion floatValue] >= 7.1) ? (YES) : (NO))
#define IOS_VERSION_6                           (([[UIDevice currentDevice].systemVersion floatValue] < 7.0 && [[UIDevice currentDevice].systemVersion floatValue] >= 6.0) ? (YES) : (NO))

#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue] //iOS版本


typedef void(^ZCBlock)(void);
typedef void(^ZCBlockBlock)(ZCBlock block);
typedef void(^ZCObjectBlock)(id obj);
typedef void(^ZCArrayBlock)(NSArray *array);
typedef void(^ZCMutableArrayBlock)(NSMutableArray *array);
typedef void(^ZCDictionaryBlock)(NSDictionary *dic);
typedef void(^ZCErrorBlock)(NSError *error);
typedef void(^ZCIndexBlock)(NSInteger index);
typedef void(^ZCFloatBlock)(CGFloat afloat);
typedef void(^ZCStringBlock)(NSString *string);


typedef void(^ZCCancelBlock)(id viewController);
typedef void(^ZCFinishedBlock)(id viewController, id object);

typedef void(^ZCSendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);


#endif /* DefineHeader_h */
