//
//  AppDelegate.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
/**
 高德地图
 */
#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

/*
 *  短信
 */
#import "AFNetworkActivityIndicatorManager.h"
// 支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
//推送
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //地图
    [self configureAPIKey];
    [self configurationWindowRootVC];
    //bugly
    [Bugly startWithAppId:BuglyAPPID];
    //极光推送
    [self initJPushMethod:launchOptions];

    return YES;
}
#pragma mark - rootVc
- (void)configurationWindowRootVC
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //设置缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        
        //键盘配置
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    });
    [APIRequest automaticLoginEventResponse];

    [NSThread sleepForTimeInterval:2.f];
    //tabbar
   
    self.tabBarControllerConfig = [[ZCTabBarControllerConfig alloc] init];
    self.tabBarControllerConfig.tabBarController.delegate = self;
    [self.window setRootViewController:self.tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
}
- (void)weiXinRegisterAppInit
{
    [WXApi registerApp:WeChatAppID withDescription:@"XiaoMiZuChe"];
}

#pragma mark - 配置地图
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma mark -极光推送
- (void)initJPushMethod:(NSDictionary *)launchOptions
{

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            DLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    
    [self parsingNoticeWithUserInfo:userInfo];

    DLog(@"消息是－－－－－%@",userInfo);
}
- (void)parsingNoticeWithUserInfo:(NSDictionary *)userInfo
{
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *eventType = [NSString stringWithFormat:@"%@",[extras valueForKey:@"eventType"]]; //自定义参数，key是自己定义的
//    //8关闭超时 7关闭成功 6开启超时 5开启成功
//    
//    NSString *userName = [USER_D objectForKey:@"user_phone"];
//    
//    if (userName.length >0)
//    {
//        if ([eventType isEqualToString:@"10"])
//        {
//            [USER_D removeObjectForKey:@"user_phone"];
//            [USER_D removeObjectForKey:@"user_password"];
//            [USER_D synchronize];
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下线通知" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//            //alertView.alertViewStyle = UIAlertViewStyleDefault;
//            [alertView show];
//        }else{
//            [JKPromptView showWithImageName:nil message:content];
//        }
//        
//        if ([eventType isEqualToString:@"9"])
//        {
//            [[SoundManager sharedSoundManager] musicPlayByName:@"msg_prompt"];
//        }
//        if (eventType.intValue == 8 || eventType.intValue == 7 || eventType.intValue == 6 || eventType.intValue == 5) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"OpenVf" object:nil userInfo:@{@"eventType":eventType}];
//        }
//        
//    }
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 前台收到远程通知");
        
        [self parsingNoticeWithUserInfo:userInfo];
        
    }
    else {
        DLog(@"iOS10 判断为本地通知");
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 收到远程通知");
        [self parsingNoticeWithUserInfo:userInfo];
        
    }
    else {
        DLog(@"iOS10 判断为本地通知");
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    DLog(@"token---:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //点击进来时候
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}
//判断不同系统下用户是否在设置界面关闭了推送
- (BOOL)isAllowedNotification {
    
    //iOS8 check if user allow notification
    if ([[QZManager sharedQZManager] isSystemVersioniOS8])
    {
        // system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types)
        {
            return YES;
        }
    }
    else
    {
        //iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}


//程序成为活动状态后走的方法
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    BOOL isOpenNotify = [self isAllowedNotification];
    //开启推送
    if (isOpenNotify)
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    //关闭推送
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
    //    if (ISIos8)
    //    {
    //        BOOL isRemoteNotify = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
    //        if (isRemoteNotify)
    //        {
    //            [[UIApplication sharedApplication] registerForRemoteNotifications];
    //        }
    //        else
    //        {
    //            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //        }
    //    }
    //    else
    //    {
    //        //用户关闭了推送
    //        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
    //        {
    //            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //        }
    //        else
    //        {
    //            [[UIApplication sharedApplication] registerForRemoteNotifications];
    //        }
    //    }
    
}
#pragma mark -
#pragma mark - 支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        [self alipaySDKopenURL:url];
    }else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];

    }
    return YES;
}

//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        
//        [self alipaySDKopenURL:url];
//    }
//    return YES;
//}
#pragma mark -支付宝回调
- (void)alipaySDKopenURL:(NSURL *)url
{
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        NSString *message = @"";
        switch([[resultDic objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:message = @"订单支付成功";break;
            case 8000:message = @"正在处理中";break;
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"用户中途取消";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
        
        DLog(@"result = %@",resultDic);
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
