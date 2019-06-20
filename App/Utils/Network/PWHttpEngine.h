//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

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
- (PWURLSessionTask *)getCalendarDotWithStartTime:(NSNumber *)start EndTime:(NSNumber *)end callBack:(void (^)(id response))callback;
/**
 * @param start  查询日历起始时间
 * @param end    查询日历终止时间
 */
- (PWURLSessionTask *)getCalendarListWithStartTime:(NSNumber *)start EndTime:(NSNumber *)end pageMarker:(long)pageMarker orderMethod:(NSString *)orderMethod callBack:(void (^)(id response))callback;
- (PWURLSessionTask *)checkRegisterWithPhone:(NSString *)phone callBack:(void (^)(id response))callback;
@end
