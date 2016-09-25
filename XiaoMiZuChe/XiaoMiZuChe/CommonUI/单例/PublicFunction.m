//
//  PublicFunction.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction


+ (PublicFunction *)shareInstance
{
    static PublicFunction *publicModel = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        publicModel = [[self alloc] init];
    });
    
    return publicModel;
}
#pragma mark - 应用是否为第一次启动
- (BOOL)isFirstLaunch
{
    NSString *versionKey = (NSString *)kCFBundleVersionKey;
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    NSString *currentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:versionKey];
    if ([lastVersion isEqualToString:currentVersion])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

@end
