//
//  AppDelegate.h
//  XiaoMiZuChe
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTabBarControllerConfig.h"
static NSString *appKey = @"7c7975ba2d3c765bc13a0344";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ZCTabBarControllerConfig *tabBarControllerConfig;
@end

