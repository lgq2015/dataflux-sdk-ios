//
//  NotificationMacros.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#ifndef NotificationMacros_h
#define NotificationMacros_h
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"

#define KNotificationIssueSourceChange @"KNotificationIssueSourceChange"

#define KNotificationInfoBoardDatasUpdate @"KNotificationInfoBoardDatasUpdate"
#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"
#endif /* NotificationMacros_h */
