//
//  ZhouDao_NetWorkManger.m
//  ZhouDao
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "ZhouDao_NetWorkManger.h"
#import "AFNetworking.h"
#import "FDAlertView.h"
#import "GcNoticeUtil.h"
#import "AppDelegate.h"

@implementation ZhouDao_NetWorkManger

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         //DLog(@"%d", status);
     }];
}
#pragma mark GET请求
+ (void)GetJSONWithUrl:(NSString *)url isNeedHead:(BOOL)neeadHead success:(void (^)(NSDictionary *jsonDic))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 设置请求格式
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //增加请求头代码
    if (neeadHead && [PublicFunction shareInstance].m_user.userToken) {
        [manager.requestSerializer setValue:[PublicFunction shareInstance].m_user.userToken forHTTPHeaderField:@"Authorization"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
    
    NSDictionary *dict = @{@"format": @"json"};
    
    // 网络访问是异步的,回调是主线程的,因此不用管在主线程更新UI的事情
    
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            DLog(@"success[Get]请求地址[%@]",url);
            DLog(@"success[Get]请求返回数据\n %@",result);
            NSData *data = operation.responseData;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //判断登录过期
            [[self class] goToLoginAction:dict];
            
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
    
}

#pragma mark POST请求
+ (void)PostJSONWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters isNeedHead:(BOOL)neeadHead success:(void (^)(NSDictionary *jsonDic))success fail:(void (^)())fail
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //增加请求头代码
    if (neeadHead && [PublicFunction shareInstance].m_user.userToken) {
        [manager.requestSerializer setValue:[PublicFunction shareInstance].m_user.userToken forHTTPHeaderField:@"Authorization"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager POST:urlStr
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"success[POST]请求参数[%@]\n %@",urlStr,parameters);
         DLog(@"success[POST]请求返回数据\n %@",result);
         
         if (success)
         {
             NSData *data = operation.responseData;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             
             //判断登录过期
             [[self class] goToLoginAction:dict];
             
             success(dict);
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DLog(@"error[POST]请求参数[%@]\n %@",urlStr,parameters);
         DLog(@"error[POST]请求返回数据 %@",error);
         
         if (fail)
         {
             fail(error);
         }
     }];
    
}

#pragma mark 上传多张图片数组
+ (void)postUploadWithUrl:(NSString *)urlStr
               parameters:(NSDictionary *)parameters
               WithImgDic:(NSDictionary *)allImgDic
                  success:(void (^)(NSDictionary * jsonDic))success
                     fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[PublicFunction shareInstance].m_user.userToken forHTTPHeaderField:@"Authorization"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });

    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //上传图片数组 多张图片
         for (NSString *key in [allImgDic allKeys])
         {
             //UIImage *image = [allImgDic objectForKey:key];
             NSData *imageData =[allImgDic objectForKey:key];// UIImageJPEGRepresentation(image, 0.5);
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
             // 上传的 ，FileData二进制数据 ，参数名 name ， 文件名fileName，图片类型mimeType
             //[formData appendPartWithFormData:nil name:nil];
             [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg/png/jpg"];
         }
         
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSData *data = operation.responseData;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //判断登录过期
         [[self class] goToLoginAction:dict];
         
         success(dict);
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"完成 %@", result);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         fail(error);
         DLog(@"错误 %@", error.localizedDescription);
     }];
}
#pragma mark上传单张图片
+(void)postOneImgUrlString:(NSString *)url
                    msgDic:(NSDictionary *)msgDic
                     image:(UIImage *)image
                   success:(void (^)(NSDictionary *))success
                      fail:(void (^)())fail
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //增加请求头代码
    //    [manager.requestSerializer setValue:[ConFunc getBuildVersion] forHTTPHeaderField:@"version"];
    //    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"app"];
    
    
    
    DLog(@"参数是－－－－－%@",msgDic);
    
    [manager POST:url
       parameters:msgDic
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    // 上传图片，以文件流的格式
    [formData appendPartWithFileData:imageData
                                name:@"file"
                            fileName:fileName
                            mimeType:@"image/jpeg/png/jpg"];
    
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *result = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
    DLog(@"[POST]请求地址[%@]\n %@",url,result);
    NSData *data = operation.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //判断登录过期
    [[self class] goToLoginAction:dict];
    
    success(dict);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    fail(error);
}];
    
}
+ (void)setFormDataWithUrl:(NSString  *)url
                  WithPara:(NSDictionary *)para
           WithFileDataDic:(NSDictionary *)fileDataDic
        WithFileNamePrefix:(NSString *)fileNamePrefix
                   success:(void (^)(NSDictionary *dic))success
                      fail:(void (^)())fail{
    
    
    //    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    NSMutableData *body = [NSMutableData data];
    
    NSString *BOUNDARY = @"0xKhTmLbOuNdArY";
    
    
    /** 遍历字典将字典中的键值对转换成请求格式:
     --Boundary+72D4CD655314C423
     Content-Disposition: form-data; name="empId"
     
     254
     --Boundary+72D4CD655314C423
     Content-Disposition: form-data; name="shopId"
     
     18718
     */
    //表单数据 param
    [para enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableString *fieldStr = [NSMutableString string];
        [fieldStr appendString:[NSString stringWithFormat:@"--%@\r\n", BOUNDARY]];
        [fieldStr appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]];
        [fieldStr appendString:[NSString stringWithFormat:@"%@", obj]];
        [body appendData:[fieldStr dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    //文件逻辑
    for(NSString *key in fileDataDic) {
        NSData *fileData = [fileDataDic objectForKey:key];
        NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,[NSString stringWithFormat:@"%@%@",fileNamePrefix,key],key,nil];
        [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:5.0f];
    
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    
    // 设置请求类型为post请求
    request.HTTPMethod = @"post";
    // 设置request的请求体
    request.HTTPBody = body;
    // 设置头部数据，标明上传数据总大小，用于服务器接收校验
    [request setValue:[NSString stringWithFormat:@"%ld", body.length] forHTTPHeaderField:@"Content-Length"];
    // 设置头部数据，指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）。
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    //token 放请求头
    [request setValue:[PublicFunction shareInstance].m_user.userToken forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Result--%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (!connectionError) {
                success(dic);
            }
        }else{
            success(nil);
        }
        
        
    }];
}

+ (void)goToLoginAction:(NSDictionary *)jsonDic
{
    if ([jsonDic[@"code"] intValue] ==0 && [jsonDic[@"errmsg"] isEqualToString:@"认证失败"])
    {
        UIWindow* window = [QZManager getWindow];
        
        FDAlertView *alertView = (FDAlertView *)[window viewWithTag:1234];
        if (!alertView) {
            FDAlertView *alert = [[FDAlertView alloc] initWithFrame:kMainScreenFrameRect withTit:@"温馨提示" withMsg:@"您的登录信息过期，请重新登录"];
            alert.tag = 1234;
            alert.navBlock = ^(){
                [USER_D removeObjectForKey:USERNAME];
                [USER_D removeObjectForKey:USERKEY];
                [USER_D synchronize];
                [PublicFunction shareInstance].m_bLogin = NO;
                [GcNoticeUtil sendNotification:DECIDEISLOGIN];
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                delegate.tabBarControllerConfig.tabBarController.selectedIndex = 0;

            };
        }
    }
}

@end
