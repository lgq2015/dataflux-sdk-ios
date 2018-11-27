//
//  LogManager.m
//  App
//
//  Created by 胡蕾蕾 on 2018/10/26.
//  Copyright © 2018年 hll. All rights reserved.
//

/*
 日志打印规范：时间+类+方法名+参数
 日志缓存要与应用缓存分离
 日志缓存需要避免磁盘频繁io，需要内存做缓冲，等累计到一定数量再计入磁盘，并且在应用退出时也需要记录
 日志需要根据日志等级筛选过滤
 日志需要全局配置进行，日志路径，日志等级，日志打印是否开启的配置
 */
#import "LogManager.h"
static LogManager * _instance = nil;
// 日志保留最大天数
static const int LogMaxSaveDay = 7;
// 日志文件保存目录
static const NSString* LogFilePath = @"/Documents/CCLog/";
@implementation LogManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[super allocWithZone:NULL] init] ;
        }
    });
    return _instance;
}


#pragma mark - init
- (instancetype)init{
    self = [super init];
    return self;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [LogManager shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [LogManager shareInstance] ;
    
}
@end
