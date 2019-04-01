//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class IssueLogModel;


@interface IssueChatDataManager : NSObject 
+ (instancetype)sharedInstance;

- (void)fetchAllChatIssueLog:(NSString *)issueId pageMarker:(long long)pageMarker callBack:(void (^)(NSMutableArray <IssueLogModel *> *))callback;

- (void)cacheChatIssueLogDatasToDB:(NSString *)issueId datas:(NSArray<IssueLogModel *> *)datas;

- (void)insertChatIssueLogDataToDB:(NSString *)issueId data:(IssueLogModel *)data deleteCache:(BOOL)deleteCache;

- (NSArray *)getChatIssueLogDatas:(NSString *)issueId pageMarker:(long long)pageMarker;

- (long long)getLastChatIssueLogMarker:(NSString *)issueId;
@end