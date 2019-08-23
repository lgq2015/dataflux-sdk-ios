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
#import "SelectObject.h"
#import "MemberInfoModel.h"
#import "SourceModel.h"
#import "OriginModel.h"
#define ISSUE_LIST_PAGE_SIZE  100

NSString *const ILMStringAll = @"ALL";
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
                                                                                 @"statusChangeAccountInfoStr":SQL_TEXT,
                                                                                 @"assignAccountInfoStr":SQL_TEXT,
                                                                                 @"assignedToAccountInfoStr":SQL_TEXT,
                                                                                 @"watchInfoJSONStr":SQL_TEXT,
                                                                                 @"originExecMode":SQL_TEXT,
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
                                                                                 @"alertHubTitle":SQL_TEXT,
                                                                            @"origin_forSearch":SQL_TEXT,
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
                                                                                @"issueSnapshotJSON_cacheStr":SQL_TEXT,
                                                                                @"assignedToAccountInfoStr":SQL_TEXT,
                                                                                @"childIssueStr":SQL_TEXT,
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
-(SelectObject *)getCurrentSelectObject{
    YYCache *cache = [[YYCache alloc]initWithName:KSelectObject];
    BOOL isContain= [cache containsObjectForKey:KCurrentIssueListType];
    if (isContain) {
        
        SelectObject *currentType = (SelectObject *)[cache objectForKey:KCurrentIssueListType];
        if (currentType.issueOrigin == nil) {
            OriginModel *origin = [OriginModel new];
            origin.name = NSLocalizedString(@"local.AllOrigin", @"");
            origin.origin =ILMStringAll;
            currentType.issueOrigin = origin;
            SourceModel *source = [SourceModel new];
            source.sourceID =ILMStringAll;
            source.name = NSLocalizedString(@"local.AllIssueSource", @"");
            currentType.issueSource = source;
            MemberInfoModel *model = [MemberInfoModel new];
            model.memberID = ILMStringAll;
            model.name =NSLocalizedString(@"local.AllAssigned", @"");
            currentType.issueAssigned = model;
        }
        return  currentType;
    }else{
        SelectObject *sel = [[SelectObject alloc]init];
        sel.issueSortType = 1;
        sel.issueType = 1;
        sel.issueLevel = 1;
        sel.issueFrom = 1;
        OriginModel *origin = [OriginModel new];
        origin.name =  NSLocalizedString(@"local.AllOrigin", @"");
        origin.origin =ILMStringAll;
        sel.issueOrigin = origin;
        SourceModel *source = [SourceModel new];
        source.sourceID =ILMStringAll;
        source.name = NSLocalizedString(@"local.AllIssueSource", @"");
        sel.issueSource = source;
        MemberInfoModel *model = [MemberInfoModel new];
        model.memberID = ILMStringAll;
        model.name = NSLocalizedString(@"local.AllAssigned", @"");
        sel.issueAssigned = model;
        return sel;
    }
}
-(void)setCurrentSelectObject:(SelectObject *)sel{
    YYCache *cache = [[YYCache alloc]initWithName:KSelectObject];
    BOOL isContain= [cache containsObjectForKey:KCurrentIssueListType];
    if(isContain){
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning=YES;
    }
    [cache setObject:sel forKey:KCurrentIssueListType];
}
- (NSArray *)getHistoryOriginInput{
    YYCache *cache = [[YYCache alloc]initWithName:KSelectObject];
    BOOL isContain= [cache containsObjectForKey:KHistoryOriginSearch];
    if (isContain) {
        return  (NSArray *)[cache objectForKey:KHistoryOriginSearch];
    }else{
        return nil;
    }
}
- (void)setHistoryOriginInputWithArray:(NSArray *)array{
    YYCache *cache = [[YYCache alloc]initWithName:KSelectObject];
    BOOL isContain= [cache containsObjectForKey:KHistoryOriginSearch];
    if(isContain){
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning=YES;
    }
    [cache setObject:array forKey:KHistoryOriginSearch];
}

-(IssueSortType)getCurrentIssueSortType{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    BOOL isContain= [cache containsObjectForKey:KCurrentIssueViewType];
    if (isContain) {
        NSNumber *currentType = (NSNumber *)[cache objectForKey:KCurrentIssueViewType];
        return (IssueSortType)[currentType integerValue];
    }else{
        return IssueSortTypeCreate;
    }
}
-(void)setCurrentIssueSortType:(IssueSortType)type{
    YYCache *cache = [[YYCache alloc]initWithName:KIssueListType];
    [cache removeObjectForKey:KCurrentIssueViewType];
    [cache setObject:[NSNumber numberWithInteger:(NSInteger)type] forKey:KCurrentIssueViewType];
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
    return NSStringFormat(@"%@/%@/%@", getPWUserIDWithDBCompat,getPWDefaultTeamID, PW_DBNAME_ISSUE);
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
                            [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME dicOrModelArray:allDatas];
                        }else{
                        
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
                        }
                        //       [self refreshIssueBoardDatas];
                        
//                        rollback = NO;
                        
                    }];
                    dispatch_async_on_main_queue(^{
                        [self setLastFetchTime];
                        if (callBackStatus == nil) {
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
            //            [SVProgressHUD dismiss];
        }
        
    }];
    
}


/**
 * 合并已读数据
 * @param allDatas 合并已读数据
 */
- (void)mergeReadData:(NSMutableArray *)allDatas {
    NSMutableArray *cacheArr = [[self getAllIssueData] mutableCopy];
    if (cacheArr.count == 0 && allDatas.count>0) {
        [allDatas enumerateObjectsUsingBlock:^(IssueModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isRead = YES;
        }];
    }else{
    [allDatas enumerateObjectsUsingBlock:^(IssueModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
        [[cacheArr copy] enumerateObjectsUsingBlock:^(IssueModel *cacheModel, NSUInteger idx, BOOL *_Nonnull stop) {

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
                *stop = YES;
                [cacheArr removeObjectAtIndex:idx];
            }
        }];
    }];
    }
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
        
        [[PWSocketManager sharedPWSocketManager] connect:YES];
    
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
#pragma mark ========== LastFetchTime ==========
- (void)setLastFetchTime{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamLastFetchTime];
    NSString *key =[userManager getTeamModel].teamID;
    [cache setObject:[NSDate date] forKey:key];
}
- (NSDate *)getLastFetchTime{
    YYCache *cache = [[YYCache alloc]initWithName:KTeamLastFetchTime];
    NSString *key = [userManager getTeamModel].teamID;
    NSDate *date = (NSDate *)[cache objectForKey:key];
    if(date){
        return date;
    }else{
        return nil;
    }
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
- (NSArray *)getIssueListWithSelectObject:(nullable SelectObject *)sel{
    if (sel == nil || sel.issueOrigin == nil) {
     sel= [self getCurrentSelectObject];
        if(sel.issueFrom != IssueFromAll &&sel.issueFrom != IssueFromMe ){
            sel.issueFrom = IssueFromAll;
        }
    }
    NSString *typeStr,*statesStr,*sortStr,*levelStr,*fromMeStr,*sourceStr,*orignStr,*assignStr;
    NSMutableArray *array = [NSMutableArray new];
    switch (sel.issueSortType) {
        case IssueSortTypeCreate:
            sortStr = @"ORDER by seq DESC";
            break;
        case IssueSortTypeUpdate:
            sortStr = @"ORDER by lastIssueLogSeq DESC";
            break;
    }
    switch (sel.issueLevel) {
        case IssueLevelAll:
            levelStr = @"";
            break;
        case IssueLevelDanger:
            levelStr = @"level = 'danger'";
            break;
        case IssueLevelCommon:
            levelStr = @"level = 'info'";
            break;
        case IssueLevelWarning:
            levelStr = @"level = 'warning'";

            break;
    }
    switch (sel.issueType) {
        case IssueTypeAlarm:
            typeStr = @"type = 'alarm'";
            break;
        case IssueTypeSecurity:
            typeStr = @"type = 'security'";
            break;
        case IssueTypeExpense:
            typeStr = @"type = 'expense'";
            break;
        case IssueTypeOptimization:
            typeStr = @"type = 'optimization'";
            break;
        case IssueTypeMisc:
            typeStr = @"type = 'misc'";
            break;
        case IssueTypeAll:
            typeStr = @"";
            break;
            
    }
    
    switch (sel.issueFrom) {
        case IssueFromMe:
            fromMeStr = [NSString stringWithFormat:@"watchInfoJSONStr LIKE '%%%%%%%%%@%%%%%%%%'",userManager.curUserInfo.userID];
            statesStr = @"";
            break;
        case IssueFromAll:
            fromMeStr = @"";
            statesStr =@"status = 'created'";
            break;
    }
    NSString *whereFormat = [NSString new];
    if ([statesStr isEqualToString:@""] && [levelStr isEqualToString:@""] && [typeStr isEqualToString:@""]&&[fromMeStr isEqualToString:@""]) {
        whereFormat = sortStr;
    }else{
        __block NSString *appendStr= @"";
        NSMutableArray *formatStr ;
        if (fromMeStr.length>0) {
            formatStr = [@[statesStr,typeStr,levelStr,fromMeStr] mutableCopy];
        }else{
            formatStr = [@[statesStr,typeStr,levelStr] mutableCopy];
        }
        if (![sel.issueAssigned.memberID isEqualToString:ILMStringAll]) {
            if(sel.issueAssigned.memberID.length>0){
                assignStr = [NSString stringWithFormat:@"assignedToAccountInfoStr LIKE '%%%%%%%%%@%%%%%%%%'",sel.issueAssigned.memberID];
            }else{
                assignStr = @"assignedToAccountInfoStr =''";
            }
            [formatStr addObject:assignStr];
        }
        if (![sel.issueSource.sourceID isEqualToString:ILMStringAll]) {
            if (sel.issueSource.sourceID.length>0) {
                sourceStr = [NSString stringWithFormat:@"issueSourceId = '%@'",sel.issueSource.sourceID];
            }else{
                sourceStr =@"issueSourceId = ''";
            }
            [formatStr addObject:sourceStr];
        }
        if (![sel.issueOrigin.origin isEqualToString:ILMStringAll]) {
            
            orignStr = sel.issueOrigin.origin;
            if (orignStr.length>0) {
                if([orignStr isEqualToString:@"issueEngine"]){
                    orignStr = @"originExecMode ='crontab'";
                }else if([orignStr isEqualToString:@"alertHub"]){
                    orignStr = [NSString stringWithFormat:@"originExecMode ='alertHub' AND originInfoJSONStr LIKE '%%%%%%%%%@%%%%%%%%'",sel.issueOrigin.name];
                }else{
                    orignStr =[NSString stringWithFormat:@"origin ='%@'",orignStr];
                }
            }else{
                orignStr = @"originExecMode ='alertHub'";
            }
            [formatStr addObject:orignStr];
        }
        
        [formatStr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (appendStr.length == 0) {
                appendStr =  [appendStr stringByAppendingString:obj];
            }else{
                if (obj.length>0) {
                    appendStr=   [appendStr stringByAppendingString:[NSString stringWithFormat:@" AND %@",obj]];
                }
                
            }
        }];
        whereFormat = [NSString stringWithFormat:@"WHERE %@ %@",appendStr,sortStr];
    }
    
    [self.getHelper pw_inDatabase:^{
        
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


#pragma mark ========== private method ==========

// 判断是否需要全量更新
- (BOOL)isNeedUpdateAll {
    NSDate *lastTime =[self getLastFetchTime];
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
        
    }];
    
}


- (void)clearAllIssueData {
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME];
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME];
    [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME];
    
    
}

- (void)shutDown {
    [super shutDown];
    _isFetching = NO;
}

@end
