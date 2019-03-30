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

#define ISSUE_SOURCE_FILTER_SELECTION  @" AND (issueSourceId='' OR issueSourceId IN (SELECT id FROM issue_source))"

typedef void (^loadDataSuccess)(NSArray *datas, NSNumber *pageMaker);

typedef void (^pageBlock)(NSNumber *pageMarker);

@interface IssueListManger ()
@property(nonatomic, strong) NSMutableArray *issueList;
@property(nonatomic, copy) NSString *tableName;
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
                        @"credentialJSON": SQL_TEXT,
                        @"credentialJSONstr": SQL_TEXT,
                        @"scanCheckStartTime": SQL_TEXT,
                        @"scanCheckInQueueTime": SQL_TEXT,
                        @"optionsJSONStr": SQL_TEXT,
                };

        [dict addEntriesFromDictionary:params];
        [self.getHelper pw_createTable:tableName dicOrModel:params];
    } else {
//        NSDictionary * params = @{
//                @"optionsJSONStr":SQL_TEXT
//        };
//        [[self getHelper] pw_alterTable:tableName dicOrModel:params];
    }

}


- (NSString *)getDBName {
    DLog(@"getDBName == %@", getPWUserID);
    return NSStringFormat(@"%@/%@", getPWUserID, PW_DBNAME_ISSUE);
}

- (void)createData {
    self.issueList = [NSMutableArray new];
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
        model.pageMaker = @0;
        [self.infoDatas addObject:model];
    }
}

#pragma mark ========== public method ==========

// 全量更新/会判断是否需要更新
- (void)downLoadAllIssueList {
    if ([getPWUserID isEqualToString:@""] || self.tableName == nil) {
        if ([userManager loadUserInfo]) {
            self.tableName = [userManager.curUserInfo.userID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    }
    [self doDownLoadAllIssueList];
}

- (void)doDownLoadAllIssueList {
    BOOL update = [self isNeedUpdateAll];
    if (update) {
        NSDictionary *params = @{@"_withLatestIssueLog": @YES, @"orderBy": @"actSeq", @"_latestIssueLogLimit": @1, @"orderMethod": @"asc", @"pageSize": @100};
        self.issueList = [NSMutableArray new];

        if ([self.getHelper pw_isExistTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME]) {
            [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
        }

        [self loadIssueListWithParam:params completion:^(NSArray *datas, NSNumber *pageMaker) {
            [self dealWithIssueData:self.issueList pageMaker:pageMaker];
        }];
    }
}

// 更新 issueList
- (void)newIssueNeedUpdate {
    self.issueList = [NSMutableArray new];

    [self.getHelper pw_inDatabase:^{
        NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

        NSArray *infoDatas = [self.getHelper pw_lookupTable:infoTableName dicOrModel:[InfoBoardModel class] whereFormat:nil];
        if (infoDatas.count == 0) {
            [self downLoadAllIssueList];
        } else {
            InfoBoardModel *model = infoDatas[0];
            NSDictionary *params;
            if (model.pageMaker == 0) {
                params = @{@"_withLatestIssueLog": @YES, @"orderBy": @"actSeq", @"_latestIssueLogLimit": @1, @"_latestIssueLogSubType": @"comment", @"orderMethod": @"asc", @"pageSize": @100};
            } else {
                params = @{@"_withLatestIssueLog": @YES, @"orderBy": @"actSeq", @"_latestIssueLogLimit": @1, @"_latestIssueLogSubType": @"comment", @"orderMethod": @"asc", @"pageSize": @100, @"pageMarker": model.pageMaker};
            }
            [self loadIssueListWithParam:params completion:^(NSArray *datas, NSNumber *pageMaker) {
                if (datas.count > 0) {
                    NSMutableArray *newDatas = [NSMutableArray new];
                    [datas enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

                        IssueModel *model = [[IssueModel alloc] initWithDictionary:obj];

                        [newDatas addObject:model];
                    }];
                    [newDatas enumerateObjectsUsingBlock:^(IssueModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
                        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@' ", model.issueId];
                        NSArray *issuemodel = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
                        if (issuemodel.count > 0) {
                            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model whereFormat:whereFormat];
                        } else {
                            [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model];
                        }
                    }];
                    [self dealDataForInfoBoardWithPageMaker:pageMaker];
                }

            }];
        }
    }];

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

// issueList/GET
- (void)loadIssueListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion {
    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count > 0) {
                [self.issueList addObjectsFromArray:data];
                NSDictionary *pageInfo = content[@"pageInfo"];
                long pageMarker = [pageInfo longValueForKey:@"pageMarker" default:0];
                NSNumber *pageMarker1 = [NSNumber numberWithLong:pageMarker];
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params addEntriesFromDictionary:param];
                [params setValue:pageMarker1 forKey:@"pageMarker"];
                [self loadNextIssueListWithParam:params completion:^(NSArray *_Nonnull datas, NSNumber *_Nonnull pageMaker) {
                    completion(datas, pageMaker);
                }];
            } else {
                completion(self.issueList, param[@"pageMarker"]);
            }
        } else {

        }
    }                 failBlock:^(NSError *error) {

    }];
}

- (void)loadNextIssueListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion {
    [self loadIssueListWithParam:param completion:^(NSArray *_Nonnull datas, NSNumber *_Nonnull pageMaker) {
        completion(datas, pageMaker);
    }];
}

#pragma mark ========== 数据库==========

//数据库存储
- (void)dealWithIssueData:(NSArray *)data pageMaker:(NSNumber *)pageMaker {
    DLog(@"%@", data);
    if (data.count > 0) {
        NSMutableArray *array = [NSMutableArray new];
        [data enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            IssueModel *model = [[IssueModel alloc] initWithDictionary:obj];
            [array addObject:model];
        }];

        [self.getHelper pw_inDatabase:^{
            //存在issue表
            if ([self.getHelper pw_isExistTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME]) {
//           [pwfmdb pw_inDatabase:^{
                NSArray *resultMArr = [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModelArray:array];
                if (resultMArr.count == 0) {
                    setLastTime([NSDate date]);
                    [self dealDataForInfoBoardWithPageMaker:pageMaker];
                } else {

                }
//        }];
            } else {

//        NSDictionary *dict = @{@"type":SQL_TEXT,@"title":SQL_TEXT,@"content":SQL_TEXT,@"level":SQL_TEXT,@"issueId":SQL_TEXT,@"updateTime":SQL_TEXT,@"actSeq":SQL_INTEGER,@"isRead":SQL_INTEGER,@"status":SQL_TEXT,@"latestIssueLogsStr":SQL_TEXT,@"renderedTextStr":SQL_TEXT,@"origin":SQL_TEXT,@"accountId":SQL_TEXT,@"subType":SQL_TEXT,@"originInfoJSONStr":SQL_TEXT,@"subType":SQL_TEXT};
//        BOOL isCreate = [pwfmdb pw_createTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:dict primaryKey:@"PWId"];
//        if(isCreate){
                NSArray *resultMArr = [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModelArray:array];
//
                if (resultMArr.count == 0) {
                    setLastTime([NSDate date]);
                    [self dealDataForInfoBoardWithPageMaker:pageMaker];
                } else {

                }
//          }];
//        }
            }
        }];

    } else {
        [self.getHelper pw_inDatabase:^{
            [self dealDataForInfoBoardWithPageMaker:pageMaker];
        }];

    }
}

- (void)createInfoBoardFmdbWithData:(NSArray *)array {

    NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

    if ([self.getHelper pw_isExistTable:infoTableName]) {
        [self.getHelper pw_deleteAllDataFromTable:infoTableName];
        [self.getHelper pw_insertTable:infoTableName dicOrModelArray:array];
    } else {

        [self.getHelper pw_insertTable:infoTableName dicOrModelArray:array];

    }

    KPostNotification(KNotificationInfoBoardDatasUpdate, @YES);
    KPostNotification(KNotificationNewIssue, @YES);


}

#pragma mark ========== infoBoard 数据库创建相关 ==========

// InfoBoard需要的数据处理
- (void)dealDataForInfoBoardWithPageMaker:(NSNumber *)pageMaker {

    NSString *tableName = PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME;
    NSArray *nameArray = @[@"alarm", @"security", @"expense", @"optimization", @"misc"];
    NSMutableArray *infoArray = [NSMutableArray new];
    for (NSInteger i = 0; i < nameArray.count; i++) {
        NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' AND status !='expired' AND status!='discarded' AND status!='recovered' %@ ORDER BY actSeq DESC", nameArray[i],
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
        }else{
            model.state = PWInfoBoardItemStateRecommend;
        }
        model.messageCount = itemDatas.count > 99 ? @"99+" : [NSString stringWithFormat:@"%lu", (unsigned long) itemDatas.count];
        if (pageMaker != nil) {
            model.pageMaker = pageMaker;
        }

        [infoArray addObject:model];
    }
    [self createInfoBoardFmdbWithData:infoArray];

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

- (void)delectIssueWithIsseuSourceID:(NSString *)issueSourceId {
    NSString *whereFormat = [NSString stringWithFormat:@"where issueSourceId = '%@'", issueSourceId];
    [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME whereFormat:whereFormat];
    [self dealDataForInfoBoardWithPageMaker:nil];

}

@end
