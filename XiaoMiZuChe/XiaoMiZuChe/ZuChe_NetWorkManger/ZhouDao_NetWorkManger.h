//
//  ZhouDao_NetWorkManger.h
//  ZhouDao
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhouDao_NetWorkManger : NSObject

/**检测网路状态**/
+ (void)netWorkStatus;

/*!
 *  GET请求        不缓存数据
 *
 *  @param url     url
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)GetJSONWithUrl:(NSString *)url
            isNeedHead:(BOOL)neeadHead
               success:(void (^)(NSDictionary *jsonDic))success
                  fail:(void (^)())fail;

/*!
 *  POST请求          不缓存数据
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param fail       失败的回调
 */
+ (void)PostJSONWithUrl:(NSString *)urlStr
             parameters:(NSDictionary *)parameters
             isNeedHead:(BOOL)neeadHead
                success:(void (^)(NSDictionary *jsonDic))success
                   fail:(void (^)())fail;

/*!
 *  POST请求              上传多张图片
 *
 *  @param urlStr         url
 *  @param parameters     post参数
 *  @param allImageArrays 装图片的数组
 *  @param success        成功的回调
 *  @param fail           失败的回调
 */
+ (void)postUploadWithUrl:(NSString *)urlStr
               parameters:(NSDictionary *)parameters
               WithImgDic:(NSDictionary *)allImgDic
                  success:(void (^)(NSDictionary * jsonDic))success
                     fail:(void (^)())fail;
/*!
 *  POST请求       上传单张图片
 *
 *  @param url     url
 *  @param msgDic  post参数
 *  @param image   图片
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)postOneImgUrlString:(NSString *)url
                     msgDic:(NSDictionary *)msgDic
                      image:(UIImage *)image
                    success:(void (^)(NSDictionary *))success
                       fail:(void (^)())fail;

/*!
 *  POST请求       form表单 （post参数里面带图片，语音等文本）
 *
 *  @param url     url
 *  @param para  post参数
 *  @param fileDataDic   二进制的文本
 *  @param fileNamePrefix   文本的名字前缀（可能是多个。最终名字是前缀名字加上key名拼接的）
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)setFormDataWithUrl:(NSString  *)url
                  WithPara:(NSDictionary *)para
           WithFileDataDic:(NSDictionary *)fileDataDic
        WithFileNamePrefix:(NSString *)fileNamePrefix
                   success:(void (^)(NSDictionary *dic))success
                      fail:(void (^)())fail;

@end
