//
//  PublicFunction.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"

@interface PublicFunction : NSObject

@property (nonatomic, strong) UserData *m_user;
@property (nonatomic) BOOL m_bLogin;


+(PublicFunction *)shareInstance;
//是否登录
- (BOOL)isLogin;
/**
 *  应用是否第一次启动
 *
 *  @return YES:是第一次启动  NO:否
 */
- (BOOL)isFirstLaunch;

@end
