//
//  IssueListManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueListManger.h"
#import "IssueModel.h"
#import "InfoBoardModel.h"
#import "PWFMDB.h"
#import "UserManager.h"
#import "TeamInfoModel.h"
#import "PWFMDB+Simplefy.h"
#import "PWHttpEngine.h"
#import "IssueListModel.h"
#import "IssueSourceManger.h"

#define ISSUE_SOURCE_FILTER_SELECTION  @" AND (issueSourceId='' OR issueSourceId IN (SELECT id FROM issue_source))"
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
        [self creatIssueListTable];


    }];

    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME
                       dicOrModel:@{@"scanCheckInQueueTime": SQL_TEXT}];
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{@"issueSourceId": SQL_TEXT,}];
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{@"credentialJSONStr": SQL_TEXT,}];

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

- (void)creatIssueListTable {

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
                        @"updateTime": SQL_TEXT,
                        @"actSeq": SQL_INTEGER,
                        @"isRead": SQL_INTEGER,
                        @"status": SQL_TEXT,
                        @"latestIssueLogsStr": SQL_TEXT,
                        @"renderedTextStr": SQL_TEXT,
                        @"origin": SQL_TEXT,
                        @"accountId": SQL_TEXT,
                        @"subType": SQL_TEXT,
                        @"originInfoJSONStr": SQL_TEXT,
                        @"subType": SQL_TEXT
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
                };

        [dict addEntriesFromDictionary:params];
        [self.getHelper pw_createTable:tableName dicOrModel:params];
    }

}


- (NSString *)getDBName {
    DLog(@"getDBName == %@", getPWUserID);
    return NSStringFormat(@"%@/%@", getPWUserID, PW_DBNAME_ISSUE);
}

- (void)createData {
    self.infoDatas = [NSMutableArray new];
    NSArray *nameArray = @[@"alarm", @"security", @"expense", @"optimization", @"misc"];
    for (NSInteger i = 0; i < 5; i++) {
        InfoBoardModel *model = [InfoBoardModel new];
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
                     lastDataStatus:(void (^)(BaseReturnModel *))callBackStatus {
    [[PWHttpEngine sharedInstance] getIssueList:ISSUE_LIST_PAGE_SIZE pageMarker:pageMaker callBack:^(id o) {
        IssueListModel *listModel = (IssueListModel *) o;

        if (listModel.isSuccess) {

            [allDatas addObjectsFromArray:listModel.list];
            if (listModel.list.count < ISSUE_LIST_PAGE_SIZE) {
                [self.getHelper pw_inTransaction:^(BOOL *rollback) {
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
                [self fetchAllIssueWithPageMarker:lastPageMaker allDatas:allDatas lastDataStatus:callBackStatus];
            }

        }

        if (callBackStatus != nil) {
            callBackStatus(listModel);
        }
        _isFetching = NO;


    }];

}

- (void)fetchIssueList:(BOOL)check {
    [self fetchIssueList:nil check:check];

}

- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus check:(BOOL)check {
    if (_isFetching) {
        return;
    }

    _isFetching = YES;

    if (check) {
        BOOL update = [self isNeedUpdateAll];
        if (update) {
            [self.getHelper pw_inDatabase:^{
                if ([self.getHelper pw_isExistTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME]) {
                    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
                }
            }];
        }
    }

    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {

        if (model.isSuccess) {
            NSMutableArray *allDatas = [NSMutableArray new];
            long long lastPagerMaker = [self getLastPageMarker];
            [self fetchAllIssueWithPageMarker:lastPagerMaker allDatas:allDatas lastDataStatus:callBackStatus];
        } else {
            callBackStatus(model);
        }

    }];


}

- (BOOL)isInfoBoardInit {
    NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

    NSArray *infoDatas = [self.getHelper pw_lookupTable:infoTableName dicOrModel:[InfoBoardModel class] whereFormat:nil];
    //判断是否初始化
    return infoDatas.count == 0;
}


/**
 * 获取最好条数据的marker
 * @return
 */
- (long long)getLastPageMarker {
    __block long long seqAct = 0;

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = @"ORDER BY seqAct DESC";
        NSDictionary *dict = @{@"seqAct": SQL_INTEGER};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        if (array.count > 0) {
            seqAct = [array[0] longLongValueForKey:@"seqAct" default:0];
        }
    }];
    return seqAct;

}


- (NSArray *)getIssueListWithIssueType:(NSString *)type {
    NSMutableArray *array = [NSMutableArray new];
    [self.getHelper pw_inDatabase:^{

        NSString *whereFormat = [NSString stringWithFormat:@"WHERE type = '%@' %@ ORDER by actSeq DESC ", type, ISSUE_SOURCE_FILTER_SELECTION];
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

- (NSArray *)getInfoBoardData {
    NSMutableArray *array = [NSMutableArray new];
    [self.getHelper pw_inDatabase:^{
        NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

        NSArray<InfoBoardModel *> *infoDatas = [self.getHelper pw_lookupTable:infoTableName dicOrModel:[InfoBoardModel class] whereFormat:nil];

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
        NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' AND status !='expired' "
                                                           "AND status!='discarded' AND status!='recovered' %@ ORDER BY actSeq DESC", nameArray[i],
                        ISSUE_SOURCE_FILTER_SELECTION];
        NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
        InfoBoardModel *model = self.infoDatas[i];

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

- (void)readIssue:(NSString *)issueId {
    NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'", issueId];
    NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
    if (itemDatas.count > 0) {
        itemDatas[0].isRead = YES;
        [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:itemDatas[0] whereFormat:whereFormat];
    }
}

// 判断首页是否连接
- (void)judgeIssueConnectState:(void (^)(BOOL isConnect))isConnect {
    if ([getTeamState isEqualToString:PW_isTeam] && userManager.teamModel.isAdmin == NO) {
        setConnect(YES);
        [kUserDefaults synchronize];
        isConnect(YES);
    } else {
        NSDictionary *param = @{@"pageNumber": @1, @"pageSize": @1};
        [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSDictionary *content = response[@"content"];
                NSArray *data = content[@"data"];
                if (data.count > 0) {
                    setConnect(YES);
                    [kUserDefaults synchronize];
                    isConnect(YES);
                } else {
                    NSDictionary *params = @{@"orderBy": @"actSeq", @"orderMethod": @"desc", @"pageSize": @1};
                    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
                        if ([response[ERROR_CODE] isEqualToString:@""]) {
                            NSDictionary *content = response[@"content"];
                            NSArray *data = content[@"data"];
                            if (data.count > 0) {
                                setConnect(YES);
                                [kUserDefaults synchronize];
                                isConnect(YES);
                            } else {
                                isConnect(NO);
                            }
                        }
                    }                          failBlock:^(NSError *error) {
                        isConnect(NO);
                    }];
                }
            } else {
                isConnect(NO);
            }
        }                          failBlock:^(NSError *error) {
            isConnect(NO);
        }];
    }
}

- (void)deleteIssueWithIssueSourceID:(NSString *)issueSourceId {
    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where issueSourceId = '%@'", issueSourceId];
        [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME whereFormat:whereFormat];
        [self refreshIssueBoardDatas];
    }];

}

@end
