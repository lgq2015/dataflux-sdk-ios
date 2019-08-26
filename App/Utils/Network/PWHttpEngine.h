//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface PWHttpEngine : NSObject

+ (instancetype)sharedInstance;


- (PWURLSessionTask *)getProbe:(NSString *)uploadId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)patchProbe:(NSString *)uploadId name:(NSString *)desc callBack:(void (^)(id))callback;

- (PWURLSessionTask *)deleteProbe:(NSString *)uploadId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getMessageDetail:(NSString *)entityId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getIssueDetail:(NSString *)issueId callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getIssueSource:(NSInteger)pageSize page:(NSInteger)page callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getIssueList:(NSInteger)pageSize pageMarker:(long long)pageMarker callBack:(void (^)(id))callback;

- (PWURLSessionTask *)getChatIssueLog:(NSInteger)pageSize issueId:(NSString *)issueId pageMarker:(long long)pageMarker orderMethod:(NSString *)orderMethod callBack:(void (^)(id))callback;

/**
 * @param text 讨论 文本
 */
- (PWURLSessionTask *)addIssueLogWithIssueid:(NSString *)issueid text:(NSString *)text atInfoJSON:(NSDictionary *)atInfoJSON callBack:(void (^)(id))callback;
/**
* @param issueid issueID
* @param expertGroup 专家
* @param content 预约电话沟通功能
*/
- (PWURLSessionTask *)issueTicketOpenWithIssueid:(NSString *)issueid expertGroup:(NSString *)expertGroup content:(NSString *)content callBack:(void (^)(id))callback;

- (PWURLSessionTask *)heartBeatWithCallBack:(void (^)(id))callback;

/**
 * @param logid logid 获取情报日志附件外部下载链接地址
 */
- (PWURLSessionTask *)issueLogAttachmentUrlWithIssueLogid:(NSString *)logid callBack:(void (^)(id))callback;
/**
 * @param issueID  获取聊天里每个用户 已读的位置
 */
- (PWURLSessionTask *)getIssueLogReadsInfoWithIssueID:(NSString *)issueID callBack:(void (^)(id))callback;
//- (PWURLSessionTask *)getCurrentTeamMemberListcallBack:(void (^)(id))callback;
/**
 * @param issuelogID  发出 已读的位置
 */
- (PWURLSessionTask *)postIssueLogReadsLastReadSeqRecord:(NSString *)issuelogID callBack:(void (^)(id))callback;

- (PWURLSessionTask *)modifyIssueWithIssueid:(NSString *)issueid markStatus:(NSString *)markStatus text:(NSString *)text atInfoJSON:(NSDictionary *)atInfoJSON callBack:(void (^)(id))callback;
- (PWURLSessionTask *)modifyIssueWithIssueid:(NSString *)issueid assignedToAccountId:(NSString *)accountId callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)recoveIssueWithIssueid:(NSString *)issueid callBack:(void (^)(id response))callback;
/**
 * @param start  查询日历起始时间
 * @param end    查询日历终止时间
 */
- (PWURLSessionTask *)getCalendarDotWithStartTime:(NSString *)start EndTime:(NSString *)end callBack:(void (^)(id response))callback;
/**
 * @param start  查询日历起始时间
 * @param end    查询日历终止时间
 */
- (PWURLSessionTask *)getCalendarListWithStartTime:(NSString *)start EndTime:(NSString *)end pageMarker:(long)pageMarker orderMethod:(NSString *)orderMethod callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)checkRegisterWithPhone:(NSString *)phone callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)issueWatchWithIssueId:(NSString *)issueId isWatch:(BOOL)isWatch callBack:(void (^)(id response))callback;

- (PWURLSessionTask *)deviceRegistration:(NSString *)deviceId registrationId:(NSString *)registrationId callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)getNotificationRuleListWithPage:(NSInteger )page  callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)subscribeNotificationRuleWithID:(NSString *)ruleID callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)unsubscribeNotificationRuleWithID:(NSString *)ruleID callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)deleteNotificationRuleWithRuleId:(NSString *)ruleID
                                              callBack:(void (^)(id response))callback;
-(PWURLSessionTask *)addNotificationRuleWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
-(PWURLSessionTask *)editNotificationRuleWithParam:(NSDictionary *)param ruleId:(NSString *)ruleId callBack:(void (^)(id response))callback;
/**
 * 获取当前团队成员列表
 */
-(PWURLSessionTask *)getCurrentTeamMemberListWithCallBack:(void (^)(id response))callback;
/**
 * 获取当前用户信息
 */
-(PWURLSessionTask *)getCurrentAccountInfoWithCallBack:(void (^)(id response))callback;
/**
 * 获取当前Team信息
 */
-(PWURLSessionTask *)getCurrentTeamInfoWithCallBack:(void (^)(id response))callback;
/**
 * 获取常量字典
 */
-(PWURLSessionTask *)getUtilsConstWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
/**
 * 获取teamList
 */
-(PWURLSessionTask *)getAuthTeamListCallBack:(void (^)(id response))callback;
/**
 * 获取teamIssueCount
 */
-(PWURLSessionTask *)getTeamIssueCountCallBack:(void (^)(id response))callback;
-(PWURLSessionTask *)getTeamProductCallBack:(void (^)(id response))callback;
/**
 * 获取系统消息未读个数
 */
-(PWURLSessionTask *)getSystemMessageUnreadCountWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
/**
 * 获取收藏列表
 */
-(PWURLSessionTask *)getFavoritesListWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
/**
 * 删除收藏的文章
 */
-(PWURLSessionTask *)deleteFavoritesWithFavoID:(NSString *)favoID callBack:(void (^)(id response))callback;
/**
 * 验证码登录
 */
-(PWURLSessionTask *)authSmsLoginWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
-(PWURLSessionTask *)authPasswordLoginWithParam:(NSDictionary *)param callBack:(void (^)(id response))callback;
@end
