//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class IssueLogModel;
@class IssueLogListModel;

#define ISSUE_CHAT_PAGE_SIZE 100


@interface IssueChatDataManager : NSObject 
+ (instancetype)sharedInstance;

- (void)fetchLatestChatIssueLog:(NSString *)issueId with:(void (^)(BaseReturnModel *))callback withFetchStatus:(BOOL)withStatus;

- (void)fetchLatestChatIssueLog:(NSString *)issueId callBack:(void (^)(BaseReturnModel *))callback;

- (long long)getLastDataCheckSeqInOnPage:(NSString *)issueId pageMarker:(long long)pageMarker;

- (void)fetchHistory:(NSString *)issueId pageMarker:(long long)pageMarker callBack:(void (^)(IssueLogListModel *))callback;

- (void)cacheChatIssueLogDatasToDB:(NSArray<IssueLogModel *> *)datas;

- (void)insertChatIssueLogDataToDB:(NSString *)issueId data:(IssueLogModel *)data deleteCache:(BOOL)deleteCache;

- (NSArray *)getChatIssueLogDatas:(NSString *)issueId startSeq:(long long)startSeq endSeq:(long long)endSeq;

- (void)setSendingDataFailInDataDB:(NSString *)issueId;

- (long long)getLastIssueLogSeqFromIssueLog:(NSString *)issueId;

- (long long)getLastChatIssueLogMarker:(NSString *)issueId;

- (void)shutDown;
@end
