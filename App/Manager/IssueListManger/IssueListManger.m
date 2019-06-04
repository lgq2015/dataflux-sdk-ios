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
#import "IssueChatDataManager.h"
#import "IssueLogListModel.h"
#import "IssueLogModel.h"


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

       // [self creatIssueBoardTable];
        [self createIssueSourceTable];
        [self createIssueListTable];
        [self createIssueLogTable];
        [self createIssueLogChatReadTable];

    }];

    // issue source update
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME
                       dicOrModel:@{@"isVirtual": SQL_INTEGER,
                       }];

    // issue udpate
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{
            @"tagsStr": SQL_TEXT,
            @"issueSourceId": SQL_TEXT,
            @"credentialJSONStr": SQL_TEXT,
            @"markStatus": SQL_TEXT,
            @"markTookOverInfoJSONStr": SQL_TEXT,
            @"markEndAccountInfoStr": SQL_TEXT,
            @"endTime":SQL_TEXT,
            @"readAtInfoStr":SQL_TEXT,
            @"isEnded":SQL_BLOB,
            @"needAttention":SQL_BLOB,
    }];
    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:@{
            @"scanCheckEndTime":SQL_TEXT,
    }];

    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{
            @"createTime": SQL_TEXT,
            @"lastIssueLogSeq": SQL_INTEGER,
            @"issueLogRead": SQL_INTEGER,
            @"seq": SQL_INTEGER,
            @"atLogSeq": SQL_INTEGER,
            @"cellHeight":SQL_INTEGER,
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
            @"atInfoJSONStr": SQL_TEXT,
            @"atStatusStr": SQL_TEXT,
    }];


    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME dicOrModel:@{
            @"getMsgTime": SQL_TEXT,
            @"lastMsgTime": SQL_TEXT,
    }];

    [self.getHelper pw_alterTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:@{
            @"localUpdateTime": SQL_TEXT,
    }];

}
- (void)createIssueLogChatReadTable{
    NSString *tableName = PW_DB_ISSUE_ISSUE_LOG_READ_NAME;
    NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];
    
    NSDictionary *params = @{
                             @"seq":SQL_INTEGER,
                             @"issueId":SQL_TEXT
                             };
    [dict addEntriesFromDictionary:params];
    
    if (![self.getHelper pw_isExistTable:tableName]) {
        
        [self.getHelper pw_createTable:tableName dicOrModel:dict];
        
    }
}
-(IssueType)getCurrentIssueType{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
   
    BOOL isContain= [cache containsObjectForKey:KCurrentIssueListType];
    if (isContain) {
        NSNumber *currentType = (NSNumber *)[cache objectForKey:KCurrentIssueListType];
         return (IssueType)[currentType integerValue];
    }else{
        return IssueTypeAll;
    }
}
/**
 * @param type 存储用户使用记录 当前issueType选择
 */
-(void)setCurrentIssueType:(IssueType)type{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    [cache removeObjectForKey:KCurrentIssueListType];
    [cache setObject:[NSNumber numberWithInteger:(NSInteger)type] forKey:KCurrentIssueListType];
}
-(IssueViewType)getCurrentIssueViewType{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    BOOL isContain= [cache containsObjectForKey:KCurrentIssueViewType];
    if (isContain) {
        NSNumber *currentType = (NSNumber *)[cache objectForKey:KCurrentIssueViewType];
        return (IssueViewType)[currentType integerValue];
    }else{
        return IssueViewTypeNormal;
    }
}
-(void)setCurrentIssueViewType:(IssueViewType)type{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    [cache removeObjectForKey:KCurrentIssueViewType];
    [cache setObject:[NSNumber numberWithInteger:(NSInteger)type] forKey:KCurrentIssueViewType];
}
- (void)creatIssueBoardTable {
    NSString *tableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;
    if (![self.getHelper pw_isExistTable:tableName]) {
        NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];

        NSDictionary *params = @{
                                 @"type": SQL_TEXT,
                                 @"subType": SQL_TEXT,
                                 @"content": SQL_TEXT,
                                 @"subType": SQL_TEXT,
                                 @"updateTime": SQL_TEXT,
                                 @"sendStatus": SQL_INTEGER
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
    return NSStringFormat(@"%@/%@/%@", getPWUserID,getPWDefaultTeamID, PW_DBNAME_ISSUE);
}

- (void)createData {
    self.infoDatas = [NSMutableArray new];
    NSArray *nameArray = @[@"alarm", @"security", @"expense", @"optimization", @"misc"];
    for (NSInteger i = 0; i < 5; i++) {
        IssueBoardModel *model = [IssueBoardModel new];
        model.type = i;
        model.subTitle = @"";
        model.state = PWInfoBoardItemStateRecommend;
        model.read = YES;
        model.typeName = nameArray[i];
        model.messageCount = @"0";
//        model.pageMaker = @0;
        [self.infoDatas addObject:model];
    }
}

#pragma mark ========== public method ==========


/**
 * 根据 pageMarker
 * @param pageMaker 请求标记
 */
- (void)fetchAllIssueWithPageMarker:(long long)pageMaker allDatas:(NSMutableArray *)allDatas
                     lastDataStatus:(void (^)(BaseReturnModel *))callBackStatus clearCache:(BOOL)clearCache {
    [[PWHttpEngine sharedInstance] getIssueList:ISSUE_LIST_PAGE_SIZE pageMarker:pageMaker callBack:^(id o) {
        IssueListModel *listModel = (IssueListModel *) o;
        DLog(@"PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME = %@", [self.getHelper pw_columnNameArray:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME]);
        if (listModel.isSuccess) {

            [allDatas addObjectsFromArray:listModel.list];
            if (listModel.list.count < ISSUE_LIST_PAGE_SIZE) {

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.getHelper pw_inTransaction:^(BOOL *rollback) {

                        if (clearCache) {
                            [self mergeReadData:allDatas];
                            [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
                        }

                        [allDatas enumerateObjectsUsingBlock:^(IssueModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
                            NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@' ", model.issueId];
                            NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
                            if (array.count > 0) {
                                IssueModel *cacheModel = array[0];
                                if(cacheModel.lastIssueLogSeq<model.lastIssueLogSeq){
                                    model.localUpdateTime = model.updateTime;
                                    model.isRead = NO;
                                    model.issueLogRead = NO;
                                } else{
                                    model.issueLogRead = cacheModel.issueLogRead;
                                    model.localUpdateTime = cacheModel.localUpdateTime;
                                    model.isRead = cacheModel.isRead;
                                    model.issueLogRead = cacheModel.issueLogRead;
                                }
                                [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model whereFormat:whereFormat];
                            } else {
                                [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:model];
                            }
                        }];

                        [self refreshIssueBoardDatas];

                        rollback = NO;

                    }];
                    dispatch_async_on_main_queue(^{
                        if (callBackStatus == nil) {
                            setLastTime([NSDate date]);
//                            [kNotificationCenter postNotificationName:KNotificationUpdateIssueList object:nil
//                        userInfo:@{@"updateView":@(YES)}];
                        } else{
                            callBackStatus(listModel);
                        }
                        _isFetching =NO;
                    });
                });

            } else {
                long long lastPageMaker = ((IssueModel *) [allDatas lastObject]).actSeq;
                [self fetchAllIssueWithPageMarker:lastPageMaker allDatas:allDatas lastDataStatus:callBackStatus
                                       clearCache:clearCache];
            }

        } else{
            if (callBackStatus != nil) {
                callBackStatus(listModel);
            }
            _isFetching =NO;
            [SVProgressHUD dismiss];
        }

    }];

}

/**
 * 更新已读的时间
 */
-(void)updateIssueBoardGetMsgTime:(NSString *)type{
    [self.getHelper pw_inDatabase:^{
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME
                                             dicOrModel:@{@"lastMsgTime": SQL_TEXT} whereFormat:@"WHERE typeName='%@'", type];
        if (array.count > 0) {
            NSString *lastMsgTime = [array[0] stringValueForKey:@"lastMsgTime" default:@""];
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME
                                dicOrModel:@{@"getMsgTime": lastMsgTime} whereFormat:@"WHERE typeName='%@'", type];
        }

    }];
}
/**
 * 获取未读的类型
 * @return 获取未读的类型
 */
-(NSArray *)getUnReadType{
    NSMutableArray *typeArr = [NSMutableArray new];
    
    [self.getHelper pw_inDatabase:^{
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME
                                             dicOrModel:@{@"typeName": SQL_TEXT} whereFormat:@"WHERE getMsgTime < lastMsgTime"];
        for (NSDictionary *dic in array) {
            [typeArr addObject:[dic stringValueForKey:@"typeName" default:@""]];
        }
    }];

    return typeArr;
}

/**
 * 合并已读数据
 * @param allDatas 合并已读数据
 */
- (void)mergeReadData:(NSMutableArray *)allDatas {
    NSArray *cacheArr = [self getAllIssueData];
    [allDatas enumerateObjectsUsingBlock:^(IssueModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        [cacheArr enumerateObjectsUsingBlock:^(IssueModel *cacheModel, NSUInteger idx, BOOL *_Nonnull stop) {

            if ([newModel.issueId isEqualToString:cacheModel.issueId]) {
                if (newModel.lastIssueLogSeq <= cacheModel.lastIssueLogSeq) {
                    newModel.isRead = cacheModel.isRead;
                    newModel.issueLogRead = cacheModel.issueLogRead;
                    if (cacheModel.localUpdateTime.length > 0) {
                        newModel.localUpdateTime = cacheModel.localUpdateTime;
                    } else {
                        newModel.localUpdateTime = cacheModel.createTime;
                    }
                } else {
                    newModel.localUpdateTime = cacheModel.updateTime;
                }

            }
        }];
    }];
}

- (void)fetchIssueList:(BOOL)getAllDatas {
    [self fetchIssueList:nil getAllDatas:getAllDatas];

}


- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus
           getAllDatas:(BOOL)getAllDatas withStatus:(BOOL)withStatus{
    if (_isFetching) {
        if(withStatus){
            BaseReturnModel *model = [BaseReturnModel new];
            model.errorCode = ERROR_CODE_LOCAL_IS_FETCHING;
            callBackStatus(model);
        }
        return;
    }

    _isFetching = YES;

    BOOL needGetAllData = [self isNeedUpdateAll] || getAllDatas;

    [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {

        if (model.isSuccess) {
            NSMutableArray *allDatas = [NSMutableArray new];
            long long lastPagerMaker = needGetAllData ? 0 : [self getLastPageMarker];

            [self fetchAllIssueWithPageMarker:lastPagerMaker allDatas:allDatas
                               lastDataStatus:callBackStatus clearCache:needGetAllData];
        } else {
            if (callBackStatus) {
                callBackStatus(model);
            }
            _isFetching = NO;
            [SVProgressHUD dismiss];
        }

    }];
}

/**
 *   callBackStatus 为 nil 时 走 Notification 通知，如果不为 null 会回调
 * @param callBackStatus  callBackStatus 为 nil 时 走 Notification 通知
 * @param getAllDatas    callBackStatus 为 nil 时 走 Notification 通知
 */
- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus getAllDatas:(BOOL)getAllDatas {
    [self fetchIssueList:callBackStatus getAllDatas:getAllDatas withStatus:NO];
}

- (void)checkSocketConnectAndFetchNewIssue:(void (^)(BaseReturnModel *))callBackStatus{
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
        callBackStatus(model);
        
        //        [[IssueChatDataManager sharedInstance] fetchLatestChatIssueLog:nil callBack:^(BaseReturnModel *model) {
        [[PWSocketManager sharedPWSocketManager] connect:YES];
        //        }];
    }                                           getAllDatas:NO];
}

- (void)checkSocketConnectAndFetchIssue:(void (^)(BaseReturnModel *))callBackStatus {

    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model) {
        callBackStatus(model);

//        [[IssueChatDataManager sharedInstance] fetchLatestChatIssueLog:nil callBack:^(BaseReturnModel *model) {
            [[PWSocketManager sharedPWSocketManager] connect:YES];
//        }];
    }                                           getAllDatas:YES];

}

- (BOOL)isInfoBoardInit {
    __block BOOL isInit = NO;
    [self.getHelper pw_inDatabase:^{
        isInit = [self.getHelper pw_tableItemCount:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME] == 0;
    }];
    return isInit;
}


/**
 * 获取最后条数据的marker
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
-(void)updateIssueListCellHeight:(CGFloat)cellHeight issueId:(NSString *)issueId{
    [self.getHelper pw_inDatabase:^{
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                                             dicOrModel:@{@"cellHeight": SQL_INTEGER} whereFormat:@"WHERE issueId='%@'", issueId];
        if (array.count > 0) {
//            NSString *lastMsgTime = [array[0] stringValueForKey:@"cellHeight" default:@""];
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                                dicOrModel:@{@"cellHeight": [NSNumber numberWithFloat:cellHeight]} whereFormat:@"WHERE issueId='%@'", issueId];
        }
        
    }];
}

- (NSArray *)getIssueListWithIssueType:(IssueType )type issueViewType:(IssueViewType)viewType{
    if(type == 0){
      type = [self getCurrentIssueType];
    }else{
        [self setCurrentIssueType:type];
    }
    if (viewType == 0) {
        viewType = [self getCurrentIssueViewType];
    }else{
        [self setCurrentIssueViewType:viewType];
    }
    NSMutableArray *array = [NSMutableArray new];
    NSString *typeStr,*whereFormat,*statesStr;
    BOOL isALL = NO;
    switch (type) {
        case IssueTypeAlarm:
            typeStr = @"alarm";
            break;
        case IssueTypeSecurity:
            typeStr = @"security";
            break;
        case IssueTypeExpense:
            typeStr = @"expense";
            break;
        case IssueTypeOptimization:
            typeStr = @"optimization";
            break;
        case IssueTypeMisc:
            typeStr = @"misc";
            break;
        case IssueTypeAll:
            isALL = YES;
            break;
    };
    switch (viewType) {
        case IssueViewTypeNormal:
            statesStr =@"AND needAttention = true AND status = 'created'";
            break;
        case IssueViewTypeAll:
            statesStr = @"";
            break;
    }
    if (isALL) {
        if(statesStr.length>0){
            //WHERE needattention = true
            whereFormat =@"WHERE needAttention = true AND status = 'created'  ORDER by seq DESC";
        }else{
            whereFormat =@" ORDER by seq DESC";
        }
        
    }else{
       whereFormat = [NSString stringWithFormat:@"WHERE type = '%@' %@  ORDER by seq DESC ", typeStr,statesStr];
    }
    [self.getHelper pw_inDatabase:^{

        NSArray *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:[IssueModel class] whereFormat:whereFormat];
        [array addObjectsFromArray:itemDatas];
    }];

    return array;
}
- (NSArray *)getRecoveredIssueListWithIssueType:(NSString *)type{
    NSMutableArray *array = [NSMutableArray new];
    [self.getHelper pw_inDatabase:^{
        
        NSString *whereFormat = [NSString stringWithFormat:@"WHERE type = '%@' AND status ='recovered' ORDER by seq DESC ", type];
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

            for(IssueBoardModel *model in infoDatas){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
                [dateFormatter setTimeZone:localTimeZone];
                NSDate *getMsgTime = [dateFormatter dateFromString:model.getMsgTime];
                NSDate *lasMsgTime = [dateFormatter dateFromString:model.lastMsgTime];

                model.read = !((!getMsgTime||[getMsgTime compare:lasMsgTime] == NSOrderedAscending)
                    &&model.state!=PWInfoBoardItemStateRecommend);

            }
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
        return !lastTime.isToday;
    }
}
- (BOOL)checkIssueEngineIsHasIssue{
    NSString *tableName = PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME;

    NSString *whereFormat = @"where origin = 'issueEngine' AND status!='discarded' AND status!='recovered'";
     NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
    if (itemDatas.count>0) {
        return YES;
    }else{
        return NO;
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
                if (issue.level == nil ||[issue.level isEqualToString:@""]) {
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
            NSString *updateSql = [NSString stringWithFormat:@"where type = '%@'"
                                                               "AND status!='discarded' AND status!='recovered' ORDER BY localUpdateTime DESC", nameArray[i]];
            NSArray *updateArrays = [self.getHelper pw_lookupTable:tableName dicOrModel:@{@"localUpdateTime":SQL_TEXT} whereFormat:updateSql];
            if (updateArrays.count > 0) {
                model.lastMsgTime = [updateArrays[0] stringValueForKey:@"localUpdateTime" default:@""];
            }
        } else {
            model.state = PWInfoBoardItemStateRecommend;
        }
        model.messageCount = itemDatas.count > 99 ? @"99+" : [NSString stringWithFormat:@"%lu", (unsigned long) itemDatas.count];
        [infoArray addObject:model];
    }

    NSString *infoTableName = PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME;

    [infoArray enumerateObjectsUsingBlock:^(IssueBoardModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *whereFormat = [NSString stringWithFormat:@"where typeName = '%@' ", model.typeName];
        NSArray *array = [self.getHelper pw_lookupTable:infoTableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
        if (array.count > 0) {
            [self.getHelper pw_updateTable:infoTableName dicOrModel:model whereFormat:whereFormat];
        } else {
            [self.getHelper pw_insertTable:infoTableName dicOrModel:model];
        }
    }];


    dispatch_async_on_main_queue(^{
        KPostNotification(KNotificationInfoBoardDatasUpdate, nil);
    });
}


/**
 * 
 * @param issueId
 * @param data
 */
- (void)updateIssueLogInIssue:(NSString *)issueId data:(IssueLogModel *)data {
    [self.getHelper pw_inDatabase:^{
        NSString *sql = @"WHERE issueId='%@'";
        NSString *table = PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME;
        NSArray *array = [self.getHelper pw_lookupTable:table
                                             dicOrModel:@{@"seq": SQL_INTEGER}
                                            whereFormat:sql, issueId];
        
        if (array.count > 0) {
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                       @"lastIssueLogSeq": @(data.seq),
                                                                                       @"latestIssueLogsStr": [data createLastIssueLogJsonString],
                                                                                       @"isRead": @(0),
                                                                                       @"issueLogRead": @(0),
                                                                                       @"localUpdateTime": data.updateTime,
                                                                                       
                                                                                       }];
            if(data.atStatusStr.length>0){
                NSDictionary *atStatus = [data.atStatusStr jsonValueDecoded];
                NSArray *unreadAccounts = PWSafeArrayVal(atStatus,@"unreadAccounts");
                [unreadAccounts enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *accountID = [obj stringValueForKey:@"accountId" default:@""];
                    if ([accountID isEqualToString:userManager.curUserInfo.userID]) {
                        [dic setObject:@(data.seq) forKey:@"atLogSeq"];
                    }
                }];
            }
            [self.getHelper pw_updateTable:table dicOrModel:dic
                               whereFormat:sql, issueId];

        }

    }];

}


/**
 * 查看 issue
 * @param issueId
 */
- (void)readIssue:(NSString *)issueId {

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'", issueId];
        NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                dicOrModel:[IssueModel class] whereFormat:whereFormat];
        if (itemDatas.count > 0) {
            itemDatas[0].isRead = YES;
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:itemDatas[0]
                               whereFormat:whereFormat];
        }
    }];

}

/**
 * 查看讨论
 * @param issueId
 */
-(void)readIssueLog:(NSString *)issueId{
    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'", issueId];
        NSArray<IssueModel *> *itemDatas = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                dicOrModel:[IssueModel class] whereFormat:whereFormat];
        if (itemDatas.count > 0) {
            itemDatas[0].issueLogRead = YES;
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModel:itemDatas[0]
                               whereFormat:whereFormat];
        }
    }];
}

/**
 * 更新未读消息时间
 * @param type
 * @param updateTime
 */
-(void)updateIssueBoardLastMsgTime:(NSString *)type updateTime:(NSString *)updateTime{
    [self.getHelper pw_inDatabase:^{
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME
                                             dicOrModel:@{@"lastMsgTime": SQL_TEXT}
                                             whereFormat:@"WHERE typeName='%@'", type];
        if (array.count > 0) {
            [self.getHelper pw_updateTable:PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME
                                dicOrModel:@{@"lastMsgTime": updateTime} whereFormat:@"WHERE typeName='%@'", type];
        }

    }];
}

/**
 * 获取讨论已读状态
 * @param issueId
 * @return
 */
- (BOOL)getIssueLogReadStatus:(NSString *)issueId {
    __block BOOL isRead = YES;
    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'", issueId];
        NSArray * array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                dicOrModel:@{@"issueLogRead":SQL_INTEGER} whereFormat:whereFormat];
        if(array.count>0){
            isRead =[array[0] boolValueForKey:@"issueLogRead" default:YES];
        }
    }];
    return isRead;
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
            ([getTeamState isEqualToString:PW_isTeam] && !userManager.teamModel.isAdmin)) {
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

/**
 * 获取在 issue 中，最后一条 issuelog 的 seq
 * @param issueId
 * @return
 */
- (long long)getLastIssueLogSeqFromIssue:(NSString *)issueId {
    __block long long seq = 1L;

    [self.getHelper pw_inDatabase:^{
        NSDictionary *dic = @{@"lastIssueLogSeq": SQL_INTEGER};
        NSString *whereFormat = [NSString stringWithFormat:@"WHERE issueId = '%@' ORDER BY lastIssueLogSeq DESC LIMIT 1",
                                                           issueId];
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME
                                             dicOrModel:dic whereFormat:whereFormat];
        if (array.count > 0) {
            seq = [array[0] longLongValueForKey:@"lastIssueLogSeq" default:1];
        }
    }];
    return seq;
}


/**
 * 检测尾部数据是否已经完整
 * @param issueId
 * @return
 */
- (BOOL)checkIssueLastStatus:(NSString *)issueId {
    return [self getLastIssueLogSeqFromIssue:issueId] <= [[IssueChatDataManager sharedInstance] getLastIssueLogSeqFromIssueLog:issueId];
}

/**
 * 根据云服务删除情报
 * @param sourceIds
 */
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
