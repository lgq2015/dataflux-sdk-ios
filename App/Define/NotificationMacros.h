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

#define KNotificationUpdateIssueList     @"KNotificationUpdateIssueList"
#define KNotificationUpdateIssueDetail     @"KNotificationUpdateIssueDetail"
#define KNotificationNewIssueLog     @"KNotificationNewIssueLog"
#define KNotificationFetchComplete     @"KNotificationFetchComplete"
//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"
//团队切换
#define KNotificationSwitchTeam @"KNotificationSwitchTeam"
//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"
//监听重新拉取讨论数据
#define KNotificationSocketConnecting @"KNotificationRefetchIssChatDatas"
//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"
#define KTeamCacheName @"KTeamCacheName"
//当前团队
#define KTeamModelCache @"KTeamModelCache"
//团队成员
#define KTeamMemberCacheName    [NSString stringWithFormat:@"%@/KTeamMemberCacheName", getPWDefaultTeamID]
//团队产品
#define KTeamProductDict       [NSString stringWithFormat:@"%@/KTeamProductDict", getPWUserID]
//团队列表
#define KTeamListCacheName @"KTeamListCacheName"
#define kAuthTeamListDict       [NSString stringWithFormat:@"%@/kAuthTeamListDict",  getPWUserID]

// 常量显示
#define KUtilsConst   @"KUtilsConst"
//用户model缓存
#define KUserModelCache @"KUserModelCache"
#define KNotificationIssueSourceChange @"KNotificationIssueSourceChange"
#define KNotificationConnectStateCheck @"KNotificationConnectStateCheck"

#define KNotificationInfoBoardDatasUpdate @"KNotificationInfoBoardDatasUpdate"
#define KNotificationNewIssue @"KNotificationNewIssue"
#define KNotificationNewRemoteNoti @"KNotificationNewRemoteNoti"
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

#pragma mark ========== 常量 ==========
#define KUtilsConstCacheName      @"KUtilsConstCacheName"

#define KIssueSourceNameModelCache @"KIssueSourceNameModelCache"
//支付宝支付回调
#define KZhifubaoPayResult @"KZhifubaoPayResult"

#endif /* NotificationMacros_h */
