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
- (BOOL)validatePhoneNumber;

/**
 检验密码格式是否正确
 */
- (BOOL)validatePassWordForm;
/**
  返回手机型号
 */
+ (NSString *)getCurrentDeviceModel;
/**
 检验是否为邮箱
 */
- (BOOL)validateEmail;
/**
 检验是否为一级域名
 */
- (BOOL)validateTopLevelDomain;
/**
 检验是否为url链接
 */
- (BOOL)isUrlAddress;
/**
  检验是否含有特殊字符
 */
-(BOOL)validateSpecialCharacter;
/**
 UTC时间转换
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *)formatter;
+ (NSString *)yearMonthDayDateUTC:(NSString *)utcDate formatter:(NSString *)formatter;
- (NSString *)accurateTimeStr;
/**
 时间转换
 */
+ (NSString *)compareCurrentTime:(NSString *)str;
- (BOOL)validateNumber;
+ (NSString *)progressLabText:(NSDictionary *)dict;
- (NSString *)getTimeFromTimestamp;
/**
  时间间隔超过30秒
 */
- (BOOL)timeIntervalAboveThirtySecond;
/**
 计算文件大小
 */
+ (NSString *)transformedValue:(id)value;

- (NSUInteger )charactorNumber;
-(NSString *)subStringWithLength:(NSInteger )count;
/**
  前后空格去除
 */
- (NSString *)removeFrontBackBlank;
@end
