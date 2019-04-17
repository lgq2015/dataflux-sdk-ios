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

#define KNotificationChatNewDatas     @"KNotificationChatNewDatas"
//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"
//监听重新拉取讨论数据
#define KNotificationReFetchIssChatDatas @"KNotificationRefetchIssChatDatas"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"
#define KTeamCacheName @"KTeamCacheName"
#define KTeamMemberCacheName    [NSString stringWithFormat:@"%@/KTeamMemberCacheName", getPWUserID]
#define KTeamProductDict       [NSString stringWithFormat:@"%@/KTeamProductDict", getPWUserID]
//用户model缓存
#define KUserModelCache @"KUserModelCache"
#define KTeamModelCache @"KTeamModelCache"
#define KNotificationIssueSourceChange @"KNotificationIssueSourceChange"
#define KNotificationConnectStateCheck @"KNotificationConnectStateCheck"

#define KNotificationInfoBoardDatasUpdate @"KNotificationInfoBoardDatasUpdate"
#define KNotificationNewIssue @"KNotificationNewIssue"

#pragma mark - ——————— team相关 ————————
//team创建成功
#define KNotificationTeamStatusChange  @"KNotificationTeamStatusChange"
//#define KNotificationTeamNeedChange    @"KNotificationTeamNeedChange"
#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"
#pragma mark - ——————— 我的 ————————
#define KNotificationUserInfoChange    @"KNotificationUserInfoChange"
#define KNotificationFeedBack          @"KNotificationFeedBack"

#define KNotificationAppResignActive @"KNotificationAppResignActive"

#endif /* NotificationMacros_h */
