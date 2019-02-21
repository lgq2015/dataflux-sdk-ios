//
//  NSString+verify.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/13.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (verify)
/**
 检验是否为手机号
 */
+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;
/**
 检验密码格式是否正确
 */
+ (BOOL)validatePassWordForm:(NSString *)password;
/**
  返回手机型号
 */
+ (NSString *)getCurrentDeviceModel;
/**
 检验是否为邮箱
 */
+ (BOOL)validateEmail:(NSString *)pEmail;
/**
 时间戳
 */
+(NSString *)getNowTimeTimestamp;
/**
 UTC时间转换
 */
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *)formatter;
/**
 时间转换
 */
+ (NSString *)compareCurrentTime:(NSString *)str;
@end
