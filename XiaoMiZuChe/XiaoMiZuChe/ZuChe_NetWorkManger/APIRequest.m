//
//  APIRequest.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "APIRequest.h"
#import "ZhouDao_NetWorkManger.h"

@implementation APIRequest


#pragma mark -验证验证吗
+ (void)VerifyTheMobileWithphone:(NSString *)phone
                        withcode:(NSString *)code
                  RequestSuccess:(void (^)())success
                            fail:(void (^)())fail
{// 468 验证码错误  474没有打开服务端验证开关  200 验证成功
    
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:phone,@"phone",SMSAPPKEY,@"appkey",@"86",@"zone",code,@"code", nil];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:VerifyTheMobile parameters:dict success:^(NSDictionary *jsonDic) {
        
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
@end
