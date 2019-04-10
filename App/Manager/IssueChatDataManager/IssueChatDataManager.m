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

#define ISSUE_CHAT_PAGE_SIZE 100

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.getHelper pw_inDatabase:^{
            NSString *tableName = PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME;
            NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];

            NSDictionary *params = @{
                    @"type": SQL_TEXT,
                    @"subType": SQL_TEXT,
                    @"content": SQL_TEXT,
                    @"subType": SQL_TEXT,
                    @"updateTime": SQL_TEXT,
                    @"sendStatus": SQL_INTEGER,
                    @"issueId": SQL_TEXT,
                    @"id": SQL_TEXT,
                    @"seq": SQL_INTEGER,
                    @"origin": SQL_TEXT,
                    @"originInfoJSONStr": SQL_TEXT,
                    @"metaJsonStr": SQL_TEXT,
                    @"externalDownloadURLStr": SQL_TEXT,
                    @"accountInfoStr": SQL_TEXT,
                    @"createTime":SQL_TEXT,
            };

            [dict addEntriesFromDictionary:params];

            if (![self.getHelper pw_isExistTable:tableName]) {

                [self.getHelper pw_createTable:tableName dicOrModel:dict];

            }

        }];
        
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME dicOrModel:@{
              @"imageData":SQL_BLOB,
              @"fileData": SQL_BLOB,
              @"text": SQL_TEXT,
              @"fileName":SQL_TEXT,
              @"fileType":SQL_TEXT,
              @"imageName":SQL_TEXT,
              @"sendError":SQL_INTEGER,
    }];
        DLog(@"PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME = %@",[self.getHelper pw_columnNameArray:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME]);

    }

    return self;
}



- (PWFMDB *)getHelper {
    return [IssueListManger sharedIssueListManger].getHelper;
}

- (void)fetchAllChatIssueLog:(NSString *)issueId pageMarker:(long long)pageMarker
                    callBack:(void (^)(NSMutableArray <IssueLogModel *> *))callback {
    if (_isFetching)return;

    _isFetching = YES;
    NSMutableArray *array = [NSMutableArray <IssueLogModel *> new];
    [self fetchChatIssueLog:issueId withDatas:array pageMarker:pageMarker
                   callBack:^(BOOL b, NSString *errorCode) {
                       _isFetching = NO;
                       [self.getHelper pw_inTransaction:^(BOOL *rollback) {
                           [self cacheChatIssueLogDatasToDB:issueId datas:array];
                           callback(array);
                       }];
                   }];


}

- (void)fetchChatIssueLog:(NSString *)issueId withDatas:(NSMutableArray<IssueLogModel *> *)allDatas
               pageMarker:(long long)pageMarker callBack:(void (^)(BOOL, NSString *errorCode))callback {
    NSDictionary *param = @{
            @"pageSize": @ISSUE_CHAT_PAGE_SIZE,
            @"type": @"attachment,bizPoint,text",
            @"subType": @"exitExpertGroups,updateExpertGroups,call,comment",
            @"_withAttachmentExternalDownloadURL": @YES,
            @"pageMarker": @(pageMarker),
            @"_attachmentExternalDownloadURLOSSExpires": [NSNumber numberWithInt:3600]};

    [PWNetworking requsetHasTokenWithUrl:PW_issueLog(issueId) withRequestType:NetworkGetType
                          refreshRequest:NO
                                   cache:NO
                                  params:param
                           progressBlock:nil
                            successBlock:^(id response) {
                                NSString *errorCode = response[ERROR_CODE];
                                if ([response[ERROR_CODE] isEqualToString:@""]) {
                                    NSDictionary *content = response[@"content"];
                                    NSArray *data = content[@"data"];

                                    [data enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                        IssueLogModel *model = [[IssueLogModel alloc] initWithDictionary:obj];
                                        [allDatas addObject:model];
                                    }];


                                    if (data.count < ISSUE_CHAT_PAGE_SIZE) {
                                        callback(YES, @"");
                                    } else {
                                        [self fetchChatIssueLog:issueId withDatas:allDatas
                                                     pageMarker:pageMarker callBack:callback];
                                    }
                                } else {
                                    callback(NO, [errorCode toErrString]);
                                }
                            }
                               failBlock:^(NSError *error) {
                                   //fixme 中英文翻译问题
                                   callback(NO,  @"网络请求失败");
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
        }else{
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


        NSArray<IssueLogModel*> *results = [self.getHelper pw_lookupTable:table
                                               dicOrModel:[IssueLogModel class] withSql:range
                                              whereFormat:@" ORDER BY updateTime ASC,seq ASC", issueId];


        [array addObjectsFromArray:results];
    }];

    return array;
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


@end
