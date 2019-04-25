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

#define ISSUE_CHAT_LATEST_MAX_SIZE 1000

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


-(void) fetchLatestChatIssueLog:(NSString *)issueId with:(void (^)(BaseReturnModel *))callback
                  withFetchStatus:(BOOL)withStatus{
    if (_isFetching){
        if(withStatus){
            BaseReturnModel *model = [BaseReturnModel new];
            model.errorCode = ERROR_CODE_LOCAL_IS_FETCHING;
            callback(model);
        }
        return;
    }

    _isFetching = YES;
    NSMutableArray *array = [NSMutableArray <IssueLogModel *> new];

    [self fetchLatestChatIssueLog:issueId withDatas:array pageMarker:0 callBack:^(IssueLogListModel *model) {
        _isFetching = NO;
        callback(model);
    }];

    
}

/**
 * 拉取最近的讨论内容
 * @param issueId
 * @param callback
 */
- (void)fetchLatestChatIssueLog:(NSString *)issueId callBack:(void (^)(BaseReturnModel *))callback {
    [self fetchLatestChatIssueLog:issueId with:callback withFetchStatus:NO];
}

/**
 * 拉取消息
 * @param issueId
 * @param allDatas
 * @param pageMarker
 * @param callback
 */
- (void)fetchLatestChatIssueLog:(NSString *)issueId withDatas:(NSMutableArray<IssueLogModel *> *)allDatas
                     pageMarker:(long long)pageMarker callBack:(void (^)(IssueLogListModel *))callback {

    [[PWHttpEngine sharedInstance]
            getChatIssueLog:ISSUE_CHAT_PAGE_SIZE
                    issueId:issueId
                 pageMarker:pageMarker orderMethod:@"desc"
                   callBack:^(id o) {


                       IssueLogListModel *listModel = (IssueLogListModel *) o;
                       if (listModel.isSuccess) {

                           [allDatas addObjectsFromArray:listModel.list];

                           BOOL containMarker = NO;
                           if (allDatas.count > 0) {
//
//
//                               long long lastSeq = [self getLastIssueLogSeqFromIssueLog:nil];
//                               if (lastSeq == allDatas.firstObject.seq) {
//                                   callback(listModel);
//                                   return;
//                               }

                               containMarker = [self containMarker:nil pageMarker:allDatas.lastObject.seq];

                           }

                           if (listModel.list.count < ISSUE_CHAT_PAGE_SIZE
                                   || allDatas.count > ISSUE_CHAT_LATEST_MAX_SIZE || containMarker) {

                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                   [self.getHelper pw_inTransaction:^(BOOL *rollback) {
                                       [self flagLastUpdateIssueDatas:allDatas];  //标记每个issue 中需要追加数据的标记
                                       [self cacheChatIssueLogDatasToDB:allDatas];
                                       rollback = NO;
                                   }];

                                   dispatch_sync_on_main_queue(^{
                                       callback(listModel);
                                   });
                               });


                           } else {
                               [self fetchLatestChatIssueLog:issueId withDatas:allDatas pageMarker:allDatas.lastObject.seq callBack:callback];
                           }
                       } else{
                           callback(listModel);
                       }


                   }];

}


- (long long)getLastDataCheckSeqInOnPage:(NSString *)issueId pageMarker:(long long)pageMarker {
    __block long long seq = 0L;

    [self.getHelper pw_inDatabase:^{
        NSString *where = [NSString stringWithFormat:@"WHERE issueId='%@'", issueId];
        if (pageMarker > 0) {
            where = [where stringByAppendingFormat:@"AND seq < '%lli' OR seq='%lli' AND seq>0",
                                                   pageMarker, pageMarker];
        }

        NSString *tableName = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;

        NSString *sqlTable = [NSString stringWithFormat:
                @"(SELECT seq,dataCheckFlag FROM %@ %@ ORDER BY seq DESC LIMIT %i)", tableName,
                where, ISSUE_CHAT_PAGE_SIZE];
        NSArray *array = [self.getHelper pw_lookupTable:tableName
                                             dicOrModel:@{@"seq": SQL_INTEGER}
                                                withSql:sqlTable
                                            whereFormat:@"WHERE dataCheckFlag=1"];

        if (array.count>0) {
            seq = [array[0] longLongValueForKey:@"seq" default:0];
        }
    }];
    return seq;


}

- (void)flagLastUpdateIssueDatas:(NSMutableArray<IssueLogModel *> *)array {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [array enumerateObjectsUsingBlock:^(IssueLogModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        IssueLogModel *cacheData = dic[newModel.issueId];
        if (cacheData) {
            if (cacheData.seq > newModel.seq) {
                dic[newModel.issueId] = newModel;
            }

        } else {
            dic[newModel.issueId] = newModel;
        }
    }];


    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, IssueLogModel *value, BOOL *stop) {
        BOOL contain = [self containWithoutLock:key pageMarker:value.seq];
        if (!contain) {
            value.dataCheckFlag = YES;
        }
    }];


}

/**
 * 拉取历史
 * @param issueId
 * @param pageMarker
 * @param callback
 */
- (void)fetchHistory:(NSString *)issueId pageMarker:(long long)pageMarker callBack:(void (^)(IssueLogListModel *))callback {

    [[PWHttpEngine sharedInstance] getChatIssueLog:ISSUE_CHAT_PAGE_SIZE issueId:issueId
                                        pageMarker:pageMarker orderMethod:@"desc"
                                          callBack:^(id o) {
                                              IssueLogListModel *data = (IssueLogListModel *) o;
                                              if (data.isSuccess) {
                                                  if (data.list.count >= ISSUE_CHAT_PAGE_SIZE) {
                                                      BOOL contain = [self containMarker:issueId
                                                              pageMarker:((IssueLogModel *)data.list.lastObject).seq];
                                                      if (!contain) {
                                                          ((IssueLogModel *) data.list.lastObject).dataCheckFlag = YES;
                                                      }
                                                  }

                                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                                                      [self.getHelper pw_inTransaction:^(BOOL *rollback) {
                                                          [self cacheChatIssueLogDatasToDB:data.list];

                                                          if (pageMarker > 0) {

                                                              NSString *sql= [NSString stringWithFormat:@"WHERE issueId='%@' AND seq='%lli' ",issueId,pageMarker];
                                                              [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME
                                                                                  dicOrModel:@{@"dataCheckFlag": @(NO)}
                                                                                 whereFormat:sql];
                                                          }

                                                          rollback = NO;
                                                      }];
                                                      dispatch_sync_on_main_queue(^{
                                                          callback(data);
                                                      });
                                                  });
                                              } else{
                                                  callback(data);
                                              }

                                          }];

}

/**
 * 是否包含数据
 * @param issueId
 * @param pageMarker
 * @return
 */
- (BOOL)containMarker:(NSString *)issueId pageMarker:(long long)pageMarker {
    __block BOOL contain = NO;

    [self.getHelper pw_inDatabase:^{
        contain = [self containWithoutLock:issueId pageMarker:pageMarker];
    }];

    return contain;

}

- (BOOL)containWithoutLock:(NSString *)issueId pageMarker:(long long)pageMarker {
    NSString *where = [NSString stringWithFormat:@"WHERE seq ='%lli' AND seq >0 ", pageMarker];
    if (issueId.length > 0) {
        where = [where stringByAppendingFormat:@"AND issueId='%@'", issueId];
    }

    NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME dicOrModel:@{@"seq": SQL_INTEGER} whereFormat:where];
    return array.count > 0;

}


/**
 * 缓存对应的数据
 * @param issueId
 * @param datas
 */
- (void)cacheChatIssueLogDatasToDB:(NSArray<IssueLogModel *> *)datas {
    NSString *table = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;
    NSString *whereSql = @"WHERE issueId ='%@' AND id='%@'";


    [datas enumerateObjectsUsingBlock:^(IssueLogModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray *results = [self.getHelper pw_lookupTable:table
                                               dicOrModel:@{@"id": SQL_TEXT}
                                              whereFormat:whereSql,
                                                          newModel.issueId, newModel.id];
        if (results.count > 0) {
            [self.getHelper pw_updateTable:table dicOrModel:newModel whereFormat:whereSql, newModel.issueId, newModel.id];
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

        [self cacheChatIssueLogDatasToDB:array];
        if (deleteCache) {
            NSString *where = @"WHERE issueId='%@' AND id='%@'";
            [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME
                               whereFormat:where, issueId, data.localTempUniqueId];
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
 * @param startSeq -1
 * @return
 */
- (NSArray *)getChatIssueLogDatas:(NSString *)issueId startSeq:(long long)startSeq endSeq:(long long)endSeq {

    NSMutableArray *array = [NSMutableArray new];

    [self.getHelper pw_inDatabase:^{
        NSString *table = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;
        NSString *where = NSStringFormat(@"WHERE issueId='%@'", issueId);
        if(endSeq>0){
            where= [where stringByAppendingFormat:@" AND seq > %lli  ", startSeq];
        }
        if (startSeq > 0) {
            where= [where stringByAppendingFormat:@" AND seq < %lli  ", startSeq];
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

/**
 * 将之前正在发送的消息标记失败
 * @param issueId
 */
-(void)setSendingDataFailInDataDB:(NSString *)issueId{
    [self.getHelper pw_inTransaction:^(BOOL *rollback) {
        NSString *where = NSStringFormat(@"WHERE issueId='%@'", issueId);

        [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME
                            dicOrModel:@{@"sendError":@YES} whereFormat:where];
    }];

}


- (long long)getLastIssueLogSeqFromIssueLog:(NSString *)issueId {
    __block long long seq = 1L;

    [self.getHelper pw_inDatabase:^{
        NSDictionary *dic = @{@"seq": SQL_INTEGER};
        NSString *whereFormat = @"";
        if (issueId.length > 0) {
            whereFormat = [NSString stringWithFormat:@"WHERE issueId = '%@'", issueId];
        }
        whereFormat = [whereFormat stringByAppendingString:@" ORDER BY seq DESC LIMIT 1"];
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
