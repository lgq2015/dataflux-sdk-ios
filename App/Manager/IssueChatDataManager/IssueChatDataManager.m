//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "IssueChatDataManager.h"
#import "IssueLogModel.h"
#import "PWFMDB+Simplefy.h"
#import "IssueListManger.h"
#import "NSString+ErrorCode.h"
#import "IssueLogListModel.h"

#define ISSUE_CHAT_PAGE_SIZE 8
#define ISSUE_CHAT_LASTEST_MAX_SIZE 10

@interface IssueChatDataManager ()

@property(nonatomic) BOOL isFetching;

@end

@implementation IssueChatDataManager {

}


+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}


- (PWFMDB *)getHelper {
    return [IssueListManger sharedIssueListManger].getHelper;
}

- (void)fetchLatestChatIssueLog:(NSString *)issueId callBack:(void (^)(IssueLogListModel *))callback {
    if (_isFetching)return;

    _isFetching = YES;
    NSMutableArray *array = [NSMutableArray <IssueLogModel *> new];
    [self fetchLatestChatIssueLog:issueId withDatas:array maxSize:0 callBack:callback];


}

/**
 * 拉取消息
 * @param issueId
 * @param allDatas
 * @param pageMarker
 * @param callback
 */
- (void)fetchLatestChatIssueLog:(NSString *)issueId withDatas:(NSMutableArray<IssueLogModel *> *)allDatas maxSize:(NSInteger)maxSize callBack:(void (^)(IssueLogListModel *))callback {

    [[PWHttpEngine sharedInstance]
            getChatIssueLog:ISSUE_CHAT_PAGE_SIZE
                    issueId:issueId
                 pageMarker:0 orderMethod:@"desc"
                   callBack:^(id o) {
                       IssueLogListModel *listModel = (IssueLogListModel *) o;
                       if (listModel.isSuccess) {

                           [allDatas addObjectsFromArray:listModel.list];

                           if (listModel.list.count < ISSUE_CHAT_PAGE_SIZE|| allDatas.count > ISSUE_CHAT_LASTEST_MAX_SIZE) {
                               
                               [self.getHelper pw_inTransaction:^(BOOL *rollback) {
                                   [self cacheChatIssueLogDatasToDB:issueId datas:allDatas];
                               }];
                           } else {
                               [self fetchLatestChatIssueLog:issueId withDatas:allDatas maxSize:0 callBack:callback];
                           }
                       } else {

                           [iToast alertWithTitleCenter:listModel.errorMsg];
                       }

                       _isFetching = NO;
                       callback(listModel);


                   }];

}

/**
 * 缓存对应的数据
 * @param issueId
 * @param datas
 */
- (void)cacheChatIssueLogDatasToDB:(NSString *)issueId datas:(NSArray<IssueLogModel *> *)datas {
    NSString *table = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;
    NSString *whereSql = @"WHERE issueId ='%@' AND id='%@'";

    [datas enumerateObjectsUsingBlock:^(IssueLogModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray *results = [self.getHelper pw_lookupTable:table
                                               dicOrModel:@{@"id": SQL_TEXT}
                                              whereFormat:whereSql,
                                                          issueId, newModel.id];
        if (results.count > 0) {
            [self.getHelper pw_updateTable:table dicOrModel:newModel whereFormat:whereSql, issueId, newModel.id];
        } else {
            [self.getHelper pw_insertTable:table dicOrModel:newModel];
        }
    }];


}


/**
 * 插入聊天数据
 * @param issueId
 * @param data
 * @param deleteCache
 */
- (void)insertChatIssueLogDataToDB:(NSString *)issueId
                              data:(IssueLogModel *)data deleteCache:(BOOL)deleteCache {

    [self.getHelper pw_inDatabase:^{
        NSArray *array = @[data];

        [self cacheChatIssueLogDatasToDB:issueId datas:array];
        if (deleteCache) {
            NSString *where = @"WHERE issueId='%@' AND id='%@'";
            [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME
                               whereFormat:where, issueId, data.id];
        }
    }];
}


- (Class)extracted {
    return [IssueLogModel class];
}

/**
 *
 * 上拉获取历史数据 100条数据或获取 最新100条
 * @param issueId
 * @param pageMarker -1
 * @return
 */
- (NSArray *)getChatIssueLogDatas:(NSString *)issueId pageMarker:(long long)pageMarker {

    NSMutableArray *array = [NSMutableArray new];

    [self.getHelper pw_inDatabase:^{
        NSString *table = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;
        NSString *where = NSStringFormat(@"WHERE issueId='%@' ", issueId);
        if (pageMarker == -1L) {
            [where stringByAppendingFormat:@" AND seq < %lli AND seq>0 ", pageMarker];
        }

        NSString *range = NSStringFormat(@"(SELECT * FROM %@ %@ ORDER BY updateTime DESC ,"
                                         " seq DESC LIMIT %d)", table, where, ISSUE_CHAT_PAGE_SIZE);


        NSArray<IssueLogModel *> *results = [self.getHelper pw_lookupTable:table
                                                                dicOrModel:[IssueLogModel class] withSql:range
                                                               whereFormat:@" ORDER BY updateTime ASC,seq ASC", issueId];


        [array addObjectsFromArray:results];
    }];

    return array;
}


- (long long)getLastIssueLogSeqFromIssueLog:(NSString *)issueId {
    __block long long seq = 1L;

    [self.getHelper pw_inDatabase:^{
        NSDictionary *dic = @{@"seq": SQL_INTEGER};
        NSString *whereFormat = [NSString stringWithFormat:@"WHERE issueId = '%@' ORDER BY seq DESC LIMIT 1 ", issueId];
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME
                                             dicOrModel:dic whereFormat:whereFormat];
        if (array.count > 0) {
            seq = [array[0] longLongValueForKey:@"seq" default:1];
        }
    }];
    return seq;
}


/**
 * 获取最后条数据的seq
 * @param issueId
 * @return
 */
- (long long)getLastChatIssueLogMarker:(NSString *)issueId {
    __block long long seq = 1L;
    [self.getHelper pw_inDatabase:^{
        NSString *table = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;

        NSString *where = @"WHERE issueId='%@' ORDER BY seq DESC LIMIT 1";
        NSArray *arr = [self.getHelper pw_lookupTable:table dicOrModel:@{@"seq": SQL_INTEGER} whereFormat:where, issueId];

        if (arr.count > 0) {
            seq = [arr[0][@"seq"] longLongValue];
        }
    }];
    return seq;
}

- (void)shutDown {
    _isFetching = NO;
}


@end
