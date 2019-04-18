//
//  IssueListManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueListManger.h"
#import "IssueModel.h"
#import "IssueBoardModel.h"
#import "PWFMDB.h"
#import "UserManager.h"
#import "TeamInfoModel.h"
#import "PWFMDB+Simplefy.h"
#import "PWHttpEngine.h"
#import "IssueListModel.h"
#import "IssueSourceManger.h"
#import "PWSocketManager.h"

#define ISSUE_LIST_PAGE_SIZE  100


@interface IssueListManger ()
@property(nonatomic, assign) BOOL isFetching;
@end

@implementation IssueListManger
+ (instancetype)sharedIssueListManger {
    static IssueListManger *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        [_sharedManger createData];

    });
    return _sharedManger;
}

- (void)onDBInit {
    [self.getHelper pw_inDatabase:^{

        [self creatIssueBoardTable];
        [self createIssueSourceTable];
        [self createIssueListTable];
        [self createIssueLogTable];


    }];

    // issue source update
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME
                       dicOrModel:@{@"scanCheckInQueueTime": SQL_TEXT,
                       }];
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME
                       dicOrModel:@{@"isVirtual": SQL_INTEGER,
                       }];

    // issue udpate
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{
            @"tagsStr": SQL_TEXT,
            @"issueSourceId": SQL_TEXT,
            @"credentialJSONStr": SQL_TEXT,
    }];

    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{
            @"createTime": SQL_TEXT,
            @"lastIssueLogSeq": SQL_INTEGER,
            @"issueLogRead": SQL_INTEGER,
            @"seq": SQL_INTEGER,

    }];

    //issue log update
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME dicOrModel:@{
            @"imageData": SQL_BLOB,
            @"fileData": SQL_BLOB,
            @"text": SQL_TEXT,
            @"fileName": SQL_TEXT,
            @"fileType": SQL_TEXT,
            @"imageName": SQL_TEXT,
            @"sendError": SQL_INTEGER,
    }];

    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME dicOrModel:@{
            @"dataCheckFlag": SQL_INTEGER,
    }];

}

- (void)creatIssueBoardTable {
    NSString *tableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;
    if (![self.getHelper pw_isExistTable:tableName]) {
        NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];

        NSDictionary *params =
                @{
                        @"type": SQL_INTEGER,
                        @"state": SQL_INTEGER,
                        @"typeName": SQL_TEXT,
                        @"messageCount": SQL_TEXT,
                        @"subTitle": SQL_TEXT,
                        @"pageMaker": SQL_TEXT,
                        @"seqAct": SQL_INTEGER
                };

        [dict addEntriesFromDictionary:params];

        [self.getHelper pw_createTable:tableName dicOrModel:params];

    }

}

- (void)createIssueListTable {

    NSString *tableName = PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME;
    if (![self.getHelper pw_isExistTable:tableName]) {

        NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];
        NSDictionary *params =
                @{
                        @"type": SQL_TEXT,
                        @"title": SQL_TEXT,
                        @"content": SQL_TEXT,
                        @"level": SQL_TEXT,
                        @"issueId": SQL_TEXT,
                        @"issueSourceId": SQL_TEXT,
                        @"createTime": SQL_TEXT,
                        @"updateTime": SQL_TEXT,
                        @"actSeq": SQL_INTEGER,
                        @"seq": SQL_INTEGER,
                        @"isRead": SQL_INTEGER,
                        @"status": SQL_TEXT,
                        @"latestIssueLogsStr": SQL_TEXT,
                        @"renderedTextStr": SQL_TEXT,
                        @"origin": SQL_TEXT,
                        @"accountId": SQL_TEXT,
                        @"subType": SQL_TEXT,
                        @"originInfoJSONStr": SQL_TEXT,
                        @"lastIssueLogSeq": SQL_INTEGER,
                        @"issueLogRead": SQL_INTEGER,
                };
        [dict addEntriesFromDictionary:params];
        [self.getHelper pw_createTable:tableName dicOrModel:params];

    }

}


- (void)createIssueSourceTable {
    NSString *tableName = PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME;
    NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];

    if (![self.getHelper pw_isExistTable:tableName]) {
        NSDictionary *params =
                @{
                        @"provider": SQL_TEXT,
                        @"name": SQL_TEXT,
                        @"teamId": SQL_TEXT,
                        @"scanCheckStatus": SQL_TEXT,
                        @"provider": SQL_TEXT,
                        @"teamId": SQL_TEXT,
                        @"updateTime": SQL_TEXT,
                        @"id": SQL_TEXT,
                        @"credentialJSONStr": SQL_TEXT,
                        @"scanCheckStartTime": SQL_TEXT,
                        @"scanCheckInQueueTime": SQL_TEXT,
                        @"optionsJSONStr": SQL_TEXT,
                        @"isVirtual": SQL_INTEGER,
                };

        [dict addEntriesFromDictionary:params];
        [self.getHelper pw_createTable:tableName dicOrModel:params];
    }

}

- (void)createIssueLogTable {

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
            @"createTime": SQL_TEXT,
            @"dataCheckFlag": SQL_TEXT,
    };

    [dict addEntriesFromDictionary:params];

    if (![self.getHelper pw_isExistTable:tableName]) {

        [self.getHelper pw_createTable:tableName dicOrModel:dict];

    }


}


- (NSString *)getDBName {
    return NSStringFormat(@"%@/%@", getPWUserID, PW_DBNAME_ISSUE);
}

- (void)createData {
    self.infoDatas = [NSMutableArray new];
    NSArray *nameArray = @[@"alarm", @"security", @"expense", @"optimization", @"misc"];
    for (NSInteger i = 0; i < 5; i++) {
        IssueBoardModel *model = [IssueBoardModel new];
        model.type = i;
        model.subTitle = @"";
        model.state = PWInfoBoardItemStateRecommend;
        model.seqAct = 0;
        model.typeName = nameArray[i];
        model.messageCount = @"0";
//        model.pageMaker = @0;
        [self.infoDatas addObject:model];
    }
}

#pragma mark ========== public method ==========


/**
 * 根据 pageMarker
 * @param pageMaker
 */
- (void)fetchAllIssueWithPageMarker:(long long)pageMaker allDatas:(NSMutableArray *)allDatas
                     lastDataStatus:(void (^)(BaseReturnModel *))callBackStatus clearCache:(BOOL)clearCache {
    [[PWHttpEngine sharedInstance] getIssueList:ISSUE_LIST_PAGE_SIZE pageMarker:pageMaker callBack:^(id o) {
        IssueListModel *listModel = (IssueListModel *) o;
        DLog(@"PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME = %@", [self.getHelper pw_columnNameArray:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME]);
        if (listModel.isSuccess) {

            [allDatas addObjectsFromArray:listModel.list];
            if (listModel.list.count < ISSUE_LIST_PAGE_SIZE) {

                [self.getHelper pw_inTransaction:^(BOOL *rollback) {

                    if (clearCache) {
                        [self mergeReadData:allDatas];
                        [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
                    }

                    [allDatas enumerateObjectsUsingBlock:^(IssueModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
                        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@' ", model.issueId];
                        NSArray *issuemodel = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
                        if (issuemodel.count > 0) {
                            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model whereFormat:whereFormat];
                        } else {
                            [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model];
                        }
                    }];

                    [self refreshIssueBoardDatas];
                    setLastTime([NSDate date]);
                    if (callBackStatus == nil) {
                        KPostNotification(KNotificationNewIssue, @YES);
                    }
                    rollback = NO;

                }];

            } else {
                long long lastPageMaker = ((IssueModel *) [allDatas lastObject]).actSeq;
                [self fetchAllIssueWithPageMarker:lastPageMaker allDatas:allDatas lastDataStatus:callBackStatus
                                       clearCache:clearCache];
            }

        }
        _isFetching = NO;
        if (callBackStatus != nil) {
            callBackStatus(listModel);
        }

    }];

}

/**
 * 合并已读数据
 * @param allDatas
 */
- (void)mergeReadData:(NSMutableArray *)allDatas {
    NSArray *cacheArr = [self getAllIssueData];
    [allDatas enumerateObjectsUsingBlock:^(IssueModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        [cacheArr enumerateObjectsUsingBlock:^(IssueModel *cacheModel, NSUInteger idx, BOOL *_Nonnull stop) {

            if ([newModel.issueId isEqualToString:cacheModel.issueId]) {
                newModel.isRead = cacheModel.isRead;
                newModel.issueLogRead = cacheModel.issueLogRead;
            }

        }];
    }];
}

- (void)fetchIssueList:(BOOL)getAllDatas {
    [self fetchIssueList:nil getAllDatas:getAllDatas];

}

/**
 *   callBackStatus 为 nil 时 走 Notification 通知，如果不为 null 会
 * @param callBackStatus
 * @param getAllDatas
 */
- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus getAllDatas:(BOOL)getAllDatas {
    if (_isFetching) {
        return;
    }

    _isFetching = YES;

    BOOL needGetAllData = [self isNeedUpdateAll] || getAllDatas;

    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {

        if (model.isSuccess) {
            NSMutableArray *allDatas = [NSMutableArray new];
            long long lastPagerMaker = needGetAllData ? 0 : [self getLastPageMarker];
            [self fetchAllIssueWithPageMarker:lastPagerMaker allDatas:allDatas
                               lastDataStatus:callBackStatus clearCache:needGetAllData];;
        } else {
            if (callBackStatus) {
                callBackStatus(model);
            }
            _isFetching = NO;
        }

    }];


}


-(void)checkSocketConnectAndFetchIssue:(void (^)(BaseReturnModel *))callBackStatus{

    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
        callBackStatus(model);
        [[PWSocketManager sharedPWSocketManager] connect];

    } getAllDatas:YES];

}

- (BOOL)isInfoBoardInit {
    __block BOOL isInit = NO;
    [self.getHelper pw_inDatabase:^{
        isInit = [self.getHelper pw_tableItemCount:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME] == 0;
    }];
    return isInit;
}


/**
 * 获取最好条数据的marker
 * @return
 */
- (long long)getLastPageMarker {
    __block long long seqAct = 0;

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = @"ORDER BY actSeq DESC";
        NSDictionary *dict = @{@"actSeq": SQL_INTEGER};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        if (array.count > 0) {
            seqAct = [array[0] longLongValueForKey:@"actSeq" default:0];
        }
    }];
    return seqAct;

}


- (NSArray *)getIssueListWithIssueType:(NSString *)type {
    NSMutableArray *array = [NSMutableArray new];
    [self.getHelper pw_inDatabase:^{

        NSString *whereFormat = [NSString stringWithFormat:@"WHERE type = '%@' AND status!='discarded' AND status!='recovered' ORDER by seq DESC ", type];
        NSArray *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
        [array addObjectsFromArray:itemDatas];
    }];

    return array;
}

- (IssueModel *)getIssueDataByData:(NSString *)issueId {
    __block IssueModel *data = nil;
    [self.getHelper pw_inDatabase:^{
        NSArray<IssueModel *> *datas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class]
                                                          whereFormat:@"WHERE issueId='%@'", issueId];
        if (datas.count > 0) {
            data = datas[0];
        }
    }];

    return data;


}

- (NSArray *)getAllIssueData {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                                             dicOrModel:[IssueModel class] whereFormat:nil];
    [array addObjectsFromArray:itemDatas];

    return array;
}


- (NSArray *)getIssueBoardData {
    NSMutableArray *array = [NSMutableArray new];
    [self.getHelper pw_inDatabase:^{
        NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

        NSArray<IssueBoardModel *> *infoDatas = [self.getHelper pw_lookupTable:infoTableName dicOrModel:[IssueBoardModel class] whereFormat:nil];

        if (infoDatas.count == 0) {
            [self createData];

            [array addObjectsFromArray:self.infoDatas];
        } else {
            [array addObjectsFromArray:infoDatas];

        }
    }];
    return array;
}

#pragma mark ========== private method ==========

// 判断是否需要全量更新
- (BOOL)isNeedUpdateAll {
    NSDate *lastTime = getLastTime;
    if (lastTime == nil) {
        return YES;
    } else {
        return ![NSDate date].isToday;
    }
}


#pragma mark ========== infoBoard 数据库创建相关 ==========

// InfoBoard需要的数据处理
- (void)refreshIssueBoardDatas {

    NSString *tableName = PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME;
    NSArray *nameArray = @[@"alarm", @"security", @"expense", @"optimization", @"misc"];
    NSMutableArray *infoArray = [NSMutableArray new];
    for (NSInteger i = 0; i < nameArray.count; i++) {
        NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@'"
                                                           "AND status!='discarded' AND status!='recovered' ORDER BY actSeq DESC", nameArray[i]];
        NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
        IssueBoardModel *model = self.infoDatas[i];

        if (itemDatas.count > 0) {
            __block IssueModel *issue = [[IssueModel alloc] init];
            __block NSString *level = @"info";
            [itemDatas enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([issue.level isEqualToString:@""]) {
                    issue = obj;
                }
                if (![obj.level isEqualToString:level]) {
                    if ([obj.level isEqualToString:@"danger"]) {
                        issue = obj;
                        *stop = YES;
                    }
                    if ([obj.level isEqualToString:@"warning"]) {
                        issue = obj;
                        level = @"warning";
                    }
                }
            }];
            model.type = i;
            if ([issue.level isEqualToString:@"danger"]) {
                model.state = PWInfoBoardItemStateSeriousness;
            } else if ([issue.level isEqualToString:@"warning"]) {
                model.state = PWInfoBoardItemStateWarning;
            } else if ([issue.level isEqualToString:@"info"]) {
                model.state = PWInfoBoardItemStateInfo;
            } else {
                model.state = PWInfoBoardItemStateRecommend;
            }
            if ([issue.renderedTextStr isEqualToString:@""]) {
                model.subTitle = issue.title;
            } else {
                NSDictionary *dict = [issue.renderedTextStr jsonValueDecoded];
                model.subTitle = dict[@"title"];
            }
            model.seqAct = itemDatas[0].actSeq;
        } else {
            model.state = PWInfoBoardItemStateRecommend;
        }
        model.messageCount = itemDatas.count > 99 ? @"99+" : [NSString stringWithFormat:@"%lu", (unsigned long) itemDatas.count];
        [infoArray addObject:model];
    }

    NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

    if ([self.getHelper pw_isExistTable:infoTableName]) {
        [self.getHelper pw_deleteAllDataFromTable:infoTableName];
        [self.getHelper pw_insertTable:infoTableName dicOrModelArray:infoArray];
    } else {

        [self.getHelper pw_insertTable:infoTableName dicOrModelArray:infoArray];

    }
    KPostNotification(KNotificationInfoBoardDatasUpdate, @YES);
}

/**
 * 查看 issue
 * @param issueId
 */
- (void)readIssue:(NSString *)issueId {

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'", issueId];
        NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
        if (itemDatas.count > 0) {
            itemDatas[0].isRead = YES;
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:itemDatas[0] whereFormat:whereFormat];
        }
    }];

}

- (NSInteger)getIssueCount {
    __block NSInteger count = 0;
    [[self getHelper] pw_inDatabase:^{
        count = [[self getHelper] pw_tableItemCount:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
    }];
    return count;
}


// 判断首页是否连接
- (BOOL)judgeIssueConnectState {
    if ([getIsHideGuide isEqualToString:PW_IsHideGuide] ||
            [getTeamState isEqualToString:PW_isTeam] && !userManager.teamModel.isAdmin) {
        return YES;
    } else {
        NSInteger sourceCount = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceCount];
        if (sourceCount > 0) {
            return YES;

        } else {
            NSInteger issueCount = [self getIssueCount];
            return issueCount > 0;
        }
    }
}

- (void)deleteIssueWithIssueSourceID:(NSArray *)sourceIds {
    [self.getHelper pw_inTransaction:^(BOOL *rollback) {

        [sourceIds enumerateObjectsUsingBlock:^(NSString *issueSourceId, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *whereFormat = [NSString stringWithFormat:@"where issueSourceId = '%@'", issueSourceId];
            [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME whereFormat:whereFormat];
        }];

        rollback = NO;

        [self refreshIssueBoardDatas];
    }];

}


- (void)clearAllIssueData {
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME];
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME];
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME];


}

- (void)shutDown {
    [super shutDown];
    _isFetching = NO;
}

@end
