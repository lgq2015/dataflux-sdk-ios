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

typedef void (^pageBlock) (NSNumber * pageMarker);
@interface IssueListManger()
@property (nonatomic, strong) NSMutableArray *issueList;
@property (nonatomic, copy) NSString *tableName;
@end
@implementation IssueListManger
+ (instancetype)sharedIssueListManger{
    static IssueListManger *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        [_sharedManger createData];
        
    });
    return _sharedManger;
}
- (void)createData{
    self.issueList = [NSMutableArray new];
}
#pragma mark ========== public method ==========

// 全量更新/会判断是否需要更新
- (void)downLoadAllIssueList{
    if ([getPWUserID isEqualToString:@""] || self.tableName == nil) {
        if ([userManager loadUserInfo]) {
            self.tableName = [userManager.curUserInfo.userID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    }
        [self doDownLoadAllIssueList];
}
- (void)doDownLoadAllIssueList{
    BOOL update = [self isNeedUpdateAll];
    if (update) {
        NSDictionary *params =@{@"_withLatestIssueLog":@YES,@"orderBy":@"actSeq",@"_latestIssueLogLimit":@1,@"orderMethod":@"asc",@"pageSize":@100};
        self.issueList = [NSMutableArray new];
        if ([[PWFMDB shareDatabase] pw_isExistTable:getPWUserID]) {
            [[PWFMDB shareDatabase] pw_deleteAllDataFromTable:getPWUserID];
        }
        [self loadIssueListWithParam:params completion:^(NSArray *datas,NSNumber *pageMaker) {
            [self dealWithIssueData:self.issueList pageMaker:pageMaker];
        }];
}
}
// 更新 issueList
- (void)newIssueNeedUpdate{
    self.issueList = [NSMutableArray new];
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *infoTableName = [NSString stringWithFormat:@"%@infoBoard",getPWUserID];
    
    NSArray *infoDatas = [pwfmdb pw_lookupTable:infoTableName dicOrModel:[InfoBoardModel class] whereFormat:nil];
    if (infoDatas.count == 0) {
        [self downLoadAllIssueList];
    }else{
        InfoBoardModel *model = infoDatas[0];
        
        NSDictionary *params =@{@"_withLatestIssueLog":@YES,@"orderBy":@"actSeq",@"_latestIssueLogLimit":@1,@"orderMethod":@"asc",@"pageSize":@100,@"pageMarker":model.pageMaker};
        [self loadIssueListWithParam:params completion:^(NSArray *datas,NSNumber *pageMaker) {
            if(datas.count>0){
                NSMutableArray *newDatas = [NSMutableArray new];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSError *error;
                IssueModel *model = [[IssueModel alloc]initWithDictionary:obj error:&error];
                NSArray *logs =  model.latestIssueLogs;
                if (logs.count>0) {
                        NSString *logstr = [logs jsonStringEncoded];
                        model.latestIssueLogsStr =logstr;
                }
                NSDictionary *rendered = model.renderedText;
               if(!rendered){
                        model.renderedTextStr = @"";
                }else{
                    NSString *renderedTextStr = [rendered jsonPrettyStringEncoded];
                    model.renderedTextStr = renderedTextStr;
                }
                    NSDictionary *reference = model.reference;
                if(!reference){
                    model.referenceStr = @"";
                }else{
                    model.referenceStr = [reference jsonPrettyStringEncoded];
                }
                [newDatas addObject:model];
                }];
                [newDatas enumerateObjectsUsingBlock:^(IssueModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                  NSString *whereFormat = [NSString stringWithFormat:@"where issueId = '%@'",model.issueId];
                    NSArray *issuemodel = [pwfmdb pw_lookupTable:getPWUserID dicOrModel:[IssueModel class] whereFormat:whereFormat];
                    if (issuemodel.count>0) {
                      [pwfmdb pw_updateTable:getPWUserID dicOrModel:model whereFormat:whereFormat];
                    }else{
                      [pwfmdb pw_insertTable:getPWUserID dicOrModel:model];
                    }
                }];
                 [self dealDataForInfoBoardWithPageMaker:pageMaker];
            }
           
        }];
    }
}
- (NSArray *)getIssueListWithIssueType:(NSString *)type{

    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' order by actSeq desc",type];
    NSArray *itemDatas = [pwfmdb pw_lookupTable:getPWUserID dicOrModel:[IssueModel class] whereFormat:whereFormat];
    return itemDatas;
}
- (NSArray *)getInfoBoardData{
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *infoTableName = [NSString stringWithFormat:@"%@infoBoard",getPWUserID];

    NSArray<InfoBoardModel*> *infoDatas = [pwfmdb pw_lookupTable:infoTableName dicOrModel:[InfoBoardModel class] whereFormat:nil];
    
    self.infoDatas = [NSMutableArray arrayWithArray:infoDatas];
    return infoDatas;
}
#pragma mark ========== private method ==========
// 判断是否需要全量更新
- (BOOL)isNeedUpdateAll{
        NSDate *lastTime = getLastTime;
        if (lastTime == nil) {
            return YES;
        }else{
            return ![NSDate date].isToday;
        }
}
// issueList/GET
- (void)loadIssueListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion{
    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count>0) {
                [self.issueList addObjectsFromArray:data];
                NSDictionary *pageInfo = content[@"pageInfo"];
                long pageMarker =[pageInfo longValueForKey:@"pageMarker" default:0];
                NSNumber *pageMarker1 =[NSNumber numberWithLong:pageMarker];
                NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
                [params addEntriesFromDictionary:param];
                [params setValue:pageMarker1 forKey:@"pageMarker"];
                [self loadNextIssueListWithParam:params completion:^(NSArray * _Nonnull datas, NSNumber * _Nonnull pageMaker) {
                    completion(datas,pageMaker);
                }];
            }else{
                completion(self.issueList,param[@"pageMarker"]);
            }
        }else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)loadNextIssueListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion{
    [self loadIssueListWithParam:param completion:^(NSArray * _Nonnull datas, NSNumber * _Nonnull pageMaker) {
        completion(datas,pageMaker);
    }];
}

#pragma mark ========== 数据库==========
//数据库存储
- (void)dealWithIssueData:(NSArray *)data pageMaker:(NSNumber *)pageMaker{
    DLog(@"%@",data);
    if (data.count>0) {
        NSMutableArray *array = [NSMutableArray new];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            IssueModel *model = [[IssueModel alloc]initWithDictionary:obj error:&error];
            NSArray *logs =  model.latestIssueLogs;
            if (logs.count>0) {
                NSString *logstr = [logs jsonStringEncoded];
                model.latestIssueLogsStr =logstr;
            }
             NSDictionary *rendered = model.renderedText;
            if(!rendered){
                model.renderedTextStr = @"";
            }else{
                NSString *renderedTextStr = [rendered jsonPrettyStringEncoded];
                model.renderedTextStr = renderedTextStr;
            }
            NSDictionary *reference = model.reference;
            if(!reference){
                model.referenceStr = @"";
            }else{
                model.referenceStr = [reference jsonPrettyStringEncoded];
            }
            [array addObject:model];
        }];
     
      PWFMDB *pwfmdb = [PWFMDB shareDatabase];
   //存在issue表
    if ([pwfmdb pw_isExistTable:getPWUserID]) {
//           [pwfmdb pw_inDatabase:^{
            NSArray  *resultMArr = [pwfmdb pw_insertTable:getPWUserID dicOrModelArray:array];
            if(resultMArr.count== 0){
            setLastTime([NSDate date]);
            [self dealDataForInfoBoardWithPageMaker:pageMaker];
            }else{
                
            }
//        }];
    }else{

        NSDictionary *dict = @{@"type":@"text",@"title":@"text",@"content":@"text",@"level":@"text",@"issueId":@"text",@"updateTime":@"text",@"actSeq":@"integer",@"isRead":@"integer",@"status":@"text",@"latestIssueLogsStr":@"text",@"renderedTextStr":@"text",@"origin":@"text",@"reference":@"text",@"PWId":@"text"};
        BOOL isCreate = [pwfmdb pw_createTable:getPWUserID dicOrModel:dict primaryKey:@"PWId"];
        if(isCreate){
       NSArray  *resultMArr = [pwfmdb pw_insertTable:getPWUserID dicOrModelArray:array];
//
            if(resultMArr.count==0){
                setLastTime([NSDate date]);
                [self dealDataForInfoBoardWithPageMaker:pageMaker];
            }else{
                
            }
//          }];
        }
    }
    }else{
        [self dealDataForInfoBoardWithPageMaker:pageMaker];
    }
}
-(void)createInfoBoardFmdbWithData:(NSArray *)array{
    
    NSString *infoTableName = [NSString stringWithFormat:@"%@infoBoard",getPWUserID];
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    if ([pwfmdb pw_isExistTable:infoTableName]) {
        [pwfmdb pw_deleteAllDataFromTable:infoTableName];
        [pwfmdb pw_insertTable:infoTableName dicOrModelArray:array];
    }else{
        NSDictionary *dict = @{@"type":@"integer",@"state":@"integer",@"typeName":@"text",@"messageCount":@"text",@"subTitle":@"text",@"pageMaker":@"text",@"seqAct":@"integer"};
    BOOL isCreate = [pwfmdb pw_createTable:infoTableName dicOrModel:dict primaryKey:@"PWId"];
    if (isCreate) {
        [pwfmdb pw_insertTable:infoTableName dicOrModelArray:array];
    }
    }
    KPostNotification(KNotificationInfoBoardDatasUpdate, @YES);
}

// InfoBoard需要的数据处理
-(void)dealDataForInfoBoardWithPageMaker:(NSNumber *)pageMaker{
  
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = getPWUserID;
        NSArray *nameArray = @[@"alarm",@"security",@"expense",@"optimization",@"misc"];
       NSMutableArray *infoArray = [NSMutableArray new];
        for (NSInteger i=0; i<nameArray.count; i++) {
           NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' AND status !='expired' AND status!='discarded' order by actSeq desc",nameArray[i]];
            NSArray<IssueModel*> *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
            InfoBoardModel *model = [InfoBoardModel new];

            if (itemDatas.count>0) {
            __block IssueModel *issue = [[IssueModel alloc]init];
            __block NSString *level = @"info";
            [itemDatas enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([issue.level isEqualToString:@""]){
                    issue = obj;
                }
                if (![obj.level isEqualToString:level]) {
                    if ([obj.level isEqualToString:@"danger"]) {
                        issue = obj;
                        *stop = YES;
                    }
                    if([obj.level isEqualToString:@"warning"]){
                        issue = obj;
                        level = @"warning";
                    }
                }
            }];
                model.type = i;
                if ([issue.level isEqualToString:@"danger"]) {
                    model.state = PWInfoBoardItemStateSeriousness;
                }else if([issue.level isEqualToString:@"warning"]){
                    model.state = PWInfoBoardItemStateWarning;
                }else if([issue.level isEqualToString:@"info"]){
                    model.state = PWInfoBoardItemStateInfo;
                }else{
                     model.state = PWInfoBoardItemStateRecommend;
                }
                if([issue.renderedTextStr isEqualToString:@""]){
                    model.subTitle = issue.title;
                }else{
                    NSDictionary *dict = [issue.renderedTextStr jsonValueDecoded];
                    model.subTitle = dict[@"title"];
                }
                 model.seqAct = itemDatas[0].actSeq;
            }else{
                 model.type = i;
                 model.subTitle =@"";
                 model.state = PWInfoBoardItemStateRecommend;
                 model.seqAct = 0;
            }
            model.messageCount = itemDatas.count>99?@"99+":[NSString stringWithFormat:@"%lu",(unsigned long)itemDatas.count];
            model.pageMaker = pageMaker;
            model.typeName = nameArray[i];
            [infoArray addObject:model];
        }
         [self createInfoBoardFmdbWithData:infoArray];
  
    
}
// 判断首页是否连接
-(void)judgeIssueConnectState:(void(^)(BOOL isConnect))isConnect{
    
        NSDictionary *param = @{@"pageNumber":@1,@"pageSize":@1};
        [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                NSDictionary *content = response[@"content"];
                NSArray *data = content[@"data"];
                if (data.count>0) {
                    setConnect(YES);
                    [kUserDefaults synchronize];
                    isConnect(YES);
                }else{
                    NSDictionary *params =@{@"orderBy":@"actSeq",@"orderMethod":@"desc",@"pageSize":@1};
                    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
                        if ([response[@"errCode"] isEqualToString:@""]) {
                            NSDictionary *content = response[@"content"];
                            NSArray *data = content[@"data"];
                            if (data.count>0) {
                                setConnect(YES);
                                [kUserDefaults synchronize];
                                isConnect(YES);
                            }else{
                               isConnect(NO);
                            }
                        }
                    } failBlock:^(NSError *error) {
                        isConnect(NO);
                    }];
                }
            }else{
             isConnect(NO);
            }
        } failBlock:^(NSError *error) {
           isConnect(NO);
        }];
}



#pragma mark ========== infoBoard 数据库创建相关 ==========

@end
