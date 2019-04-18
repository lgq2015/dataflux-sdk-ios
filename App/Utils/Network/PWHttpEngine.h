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
- (PWURLSessionTask *)addIssueLogWithIssueid:(NSString *)issueid text:(NSString *)text callBack:(void (^)(id))callback;
/**
* @param issueid issueID
* @param expertGroup 专家
* @param content 预约电话沟通功能
*/
- (PWURLSessionTask *)issueTicketOpenWithIssueid:(NSString *)issueid expertGroup:(NSString *)expertGroup content:(NSString *)content callBack:(void (^)(id))callback;

@end
