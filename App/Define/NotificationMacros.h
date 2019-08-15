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
#pragma mark ----------      通知     ----------
#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"
#define KNotificationReloadIssueList     @"KNotificationReloadIssueList"
#define KNotificationReloadRuleList    @"KNotificationReloadRuleList"
#define KNotificationUpdateIssueList     @"KNotificationUpdateIssueList"
#define KNotificationUpdateIssueDetail     @"KNotificationUpdateIssueDetail"
#define KNotificationNewIssueLog     @"KNotificationNewIssueLog"
#define KNotificationFetchComplete     @"KNotificationFetchComplete"
#define KNotificationRecordLastReadSeq @"KNotificationRecordLastReadSeq"
//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"
//团队切换
#define KNotificationSwitchTeam @"KNotificationSwitchTeam"
//修改团队成员备注
#define KNotificationEditTeamNote @"KNotificationEditTeamNote"
//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"
//监听重新拉取讨论数据
#define KNotificationSocketConnecting @"KNotificationRefetchIssChatDatas"
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
#define KNotificationAppResignActive   @"KNotificationAppResignActive"
//支付宝支付回调
#define KZhifubaoPayResult @"KZhifubaoPayResult"
#pragma mark ----------      cache     ----------
#pragma mark ========== 常量 ==========
//库名
#define KUtilsConstCacheName       @"KUtilsConstCacheName"
//表名
#define KIssueSourceNameModelCache @"KIssueSourceNameModelCache"
//账号ISPs常量数组
#define KTeamISPsCacheName         @"KTeamISPsCacheName"
#define KIssueLevel                @"KIssueLevel"
#define KExpertGroups              @"KExpertGroups"
#define KTeamServiceCode           @"KTeamServiceCode"
#define KTeamIndustry              @"KTeamIndustry"
#define KTeamDistrict              @"KTeamDistrict"
#define KSystemMessageTypes        @"KSystemMessageTypes"
#pragma mark ========== Team相关 ==========
//库名
#define KTeamCacheName             @"KTeamCacheName"
//当前团队
#define KTeamModelCache            @"KTeamModelCache"
#define kAuthTeamIssueCountDict    [NSString stringWithFormat:@"%@/kAuthTeamIssueCountDict",  getPWUserID]
//团队成员
#define KTeamMemberCacheName       [NSString stringWithFormat:@"%@/KTeamMemberCacheName", getPWDefaultTeamID]
#define KTeamAdminId               [NSString stringWithFormat:@"%@/KTeamAdminId", getPWDefaultTeamID]
//团队产品
#define KTeamProductDict           [NSString stringWithFormat:@"%@/KTeamProductDict", getPWDefaultTeamID]

//库名
#define KTeamListCacheName         @"KTeamListCacheName"
#define kAuthTeamListDict          [NSString stringWithFormat:@"%@/kAuthTeamListDict",  getPWUserID]

//库名  teamId为表名
#define KTeamLastFetchTime         @"KTeamLastFetchTime"

#pragma mark ========== 筛选相关 ==========
//库名
#define KSelectObject              @"KSelectObject"
#define KCurrentSelectObject       @"KCurrentSelectObject"
#define KCurrentIssueListType      [NSString stringWithFormat:@"%@/KCurrentIssueListType", getPWDefaultTeamID]
#define KHistoryOriginSearch       [NSString stringWithFormat:@"%@/KHistoryOriginSearch", getPWDefaultTeamID]
//库名
#define KIssueListType             @"KIssueListType"
#define KCurrentIssueViewType      @"KCurrentIssueViewType"
#define KCurrentCalendarViewType   @"KCurrentCalendarViewType"

#pragma mark ========== 用户信息 ==========
//库名
#define KUserCacheName             @"KUserCacheName"
//用户model缓存
#define KUserModelCache            @"KUserModelCache"



#endif /* NotificationMacros_h */
