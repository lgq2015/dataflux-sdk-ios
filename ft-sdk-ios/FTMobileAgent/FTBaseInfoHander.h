//
//  FTBaseInfoHander.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2019/12/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * _Nullable const FTBaseInfoHanderDeviceType;
extern NSString * _Nullable const FTBaseInfoHanderDeviceCPUType;
extern NSString * _Nullable const FTBaseInfoHanderDeviceCPUClock;
extern NSString * _Nullable const FTBaseInfoHanderBatteryTotal;
extern NSString * _Nullable const FTBaseInfoHanderDeviceGPUType;

NS_ASSUME_NONNULL_BEGIN

@interface FTBaseInfoHander : NSObject
/**
 *  获取设备相关信息
 */
+ (NSDictionary *)ft_getDeviceInfo;
/**
 *  获取运营商信息
 */
+ (NSString *)ft_getTelephonyInfo;
/**
 *  将字典转化Json字符串
 *  @param dict 需要转化的字典
 *  @return Json字符串
 */
+ (NSString *)ft_convertToJsonData:(NSDictionary *)dict;
/**
 *  获取设备分辨率
 */
+ (NSString *)ft_resolution;
/**
 *  @abstract
 *  获取当前时间戳
 *
 *  @return 时间戳
 */
+ (long long)ft_getCurrentTimestamp;
/**
 *  @abstract
 *  FT access 签名算法
 *
 *  @return 签名后字符串
 */
+(NSString*)ft_getSSOSignWithRequest:(NSMutableURLRequest *)request akSecret:(NSString *)akSecret data:(NSString *)data date:(NSString *)date;
/**
 *  @abstract
 *  获取GMT格式的时间
 *
 *  @return GMT格式的时间
 */
+ (NSString *)ft_currentGMT;
/**
 *  @abstract
 *  将json字符串转换成字典
 *
 *  @return 转换后字典
 */
+ (NSDictionary *)ft_dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  @abstract
 *  获取当前设备CPU使用率
 */
+ (long )ft_cpuUsage;
/**
 *  @abstract
 *  获取当前电池电量使用率
 */
+ (NSString *)ft_getBatteryUse;
/**
 *  @abstract
 *  获取设备总内存
 */
+ (long long)ft_getTotalMemorySize;
/**
 *  @abstract
 *  获取当前内存使用率
 */
+ (NSString *)ft_usedMemory;
/**
 *  @abstract
 *  获取前置摄像头像素
 */
+ (NSString *)ft_getFrontCameraPixel;
/**
 *  @abstract
 *  获取后置摄像头像素
 */
+ (NSString *)ft_getBackCameraPixel;
+(NSString *)removeFrontBackBlank:(NSString *)str;
+ (id)repleacingSpecialCharacters:(id )str;
@end

NS_ASSUME_NONNULL_END
