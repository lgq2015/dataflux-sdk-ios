//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class IssueLogModel;
@class IssueLogListModel;


@interface IssueChatDataManager : NSObject 
+ (instancetype)sharedInstance;

- (void)fetchLatestChatIssueLog:(NSString *)issueId callBack:(void (^)(IssueLogListModel *))callback;

- (void)cacheChatIssueLogDatasToDB:(NSString *)issueId datas:(NSArray<IssueLogModel *> *)datas;

- (void)insertChatIssueLogDataToDB:(NSString *)issueId data:(IssueLogModel *)data deleteCache:(BOOL)deleteCache;

- (NSArray *)getChatIssueLogDatas:(NSString *)issueId pageMarker:(long long)pageMarker;

- (long long)getLastIssueLogSeqFromIssueLog:(NSString *)issueId;

- (long long)getLastChatIssueLogMarker:(NSString *)issueId;

- (void)shutDown;
@end