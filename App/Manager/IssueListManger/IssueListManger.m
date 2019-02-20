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
    InfoBoardModel *monitor = [[InfoBoardModel alloc]initWithJsonDictionary:@{@"type":@0,@"messageCount":@"0",@"subTitle":@"",@"state":@0}];
    InfoBoardModel *security = [[InfoBoardModel alloc]initWithJsonDictionary:@{@"type":@3,@"messageCount":@"2",@"subTitle":@"",@"state":@0}];
    InfoBoardModel *consume = [[InfoBoardModel alloc]initWithJsonDictionary:@{@"type":@1,@"messageCount":@"0",@"subTitle":@"",@"state":@0}];
    InfoBoardModel *optimization = [[InfoBoardModel alloc]initWithJsonDictionary:@{@"type":@4,@"messageCount":@"0",@"subTitle":@"",@"state":@0}];
    InfoBoardModel *alert = [[InfoBoardModel alloc]initWithJsonDictionary:@{@"type":@2,@"messageCount":@"0",@"subTitle":@"",@"state":@0}];
    self.infoDatas = [[NSMutableArray alloc]initWithArray:@[monitor,security,consume,optimization,alert]];
    self.tableName = [userManager.curUserInfo.userID stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

#pragma mark ========== 全量更新/会判断是否需要更新 ==========
- (void)downLoadAllIssueList{
    BOOL update = [self isNeedUpdateAll];
    if (update) {
        NSDictionary *params =@{@"_withLatestIssueLog":@YES,@"orderBy":@"seq",@"_latestIssueLogLimit":@1,@"orderMethod":@"desc",@"pageSize":@10};
    self.issueList = [NSMutableArray new];
    if ([[PWFMDB shareDatabase] pw_isExistTable:self.tableName]) {
            [[PWFMDB shareDatabase] pw_deleteAllDataFromTable:self.tableName];
    }
    [self loadIssueListWithParam:params];
}
}
#pragma mark ========== 判断是否需要全量更新 ==========
- (BOOL)isNeedUpdateAll{
    NSString *lastTime = getLastTime;
    if ([lastTime isEqualToString:@""]) {
        return YES;
    }else{
        return [self isSameDay:[lastTime longValue] Time2:[[NSString getNowTimeTimestamp] longValue]];
    }
}
#pragma mark ========== 添加或修改 issueList ==========
- (void)insertIssue{
    
}
#pragma mark ========== issueList/GET ==========
- (void)loadIssueListWithParam:(NSDictionary *)param{
    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count>0) {
                [self.issueList addObjectsFromArray:data];
            }
            NSDictionary *pageInfo = content[@"pageInfo"];
            NSNumber *pageMarker =[NSNumber numberWithLong:[pageInfo longValueForKey:@"pageMarker" default:0]];
            if(![pageMarker isEqual:@0]){
                NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
                [params addEntriesFromDictionary:param];
                [params setValue:pageMarker forKey:@"pageMarker"];
                [self loadNextIssueListWithParam:params];
            }else{
                [self dealWithIssueData:self.issueList];
            }
        }else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)loadNextIssueListWithParam:(NSDictionary *)param{
    [self loadIssueListWithParam:param];
}
#pragma mark ========== 数据库存储 ==========
- (void)dealWithIssueData:(NSArray *)data{
    DLog(@"%@",data);
    if (data.count>0) {
        NSMutableArray *array = [NSMutableArray new];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            IssueModel *model = [[IssueModel alloc]initWithDictionary:obj error:&error];
            NSArray *logs =  model.latestIssueLogs;
            NSData *logData=  [NSJSONSerialization dataWithJSONObject:logs options:NSJSONWritingPrettyPrinted error:&error];
            model.latestIssueLogsStr = [[NSString alloc]initWithData:logData encoding:NSUTF8StringEncoding];
             NSDictionary *rendered =  model.renderedText;
            if(!rendered){
                model.renderedTextStr = @"";
            }else{
            NSData *renderedData=  [NSJSONSerialization dataWithJSONObject:rendered options:NSJSONWritingPrettyPrinted error:&error];
            model.renderedTextStr = [[NSString alloc]initWithData:renderedData encoding:NSUTF8StringEncoding];
            }
            [array addObject:model];
        }];
     
      PWFMDB *pwfmdb = [PWFMDB shareDatabase];
   //存在issue表
    if ([pwfmdb pw_isExistTable:self.tableName]) {
//          [pwfmdb pw_inDatabase:^{
            BOOL isopen = [pwfmdb pw_insertTable:self.tableName dicOrModelArray:array];
            if(isopen){
            [self dealDataForInfoBoard:YES];
            }
//        }];
    }else{
        
        NSDictionary *dict = @{@"type":@"text",@"title":@"text",@"content":@"text",@"level":@"text",@"issueId":@"text",@"updateTime":@"text",@"actSeq":@"integer",@"isRead":@"integer",@"status":@"text",@"latestIssueLogsStr":@"text",@"renderedTextStr":@"text",@"origin":@"text"};
        BOOL isCreate = [pwfmdb pw_createTable:self.tableName dicOrModel:dict];
        if(isCreate)
            if([pwfmdb pw_insertTable:self.tableName dicOrModelArray:array]){
                [self dealDataForInfoBoard:YES];
            }
        }
    }
}
#pragma mark ========== InfoBoard需要的数据处理 ==========
-(void)dealDataForInfoBoard:(BOOL)isfull{
    if(isfull){
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = [userManager.curUserInfo.userID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSArray *nameArray = @[@"misc",@"security",@"expense",@"optimization",@"alarm"];
        for (NSInteger i=0; i<nameArray.count; i++) {
           NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' order by actSeq desc",nameArray[i]];
            NSArray *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
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
                if ([issue.level isEqualToString:@"danger"]) {
                    self.infoDatas[i].state = PWInfoBoardItemStateSeriousness;
                }else if([issue.level isEqualToString:@"warning"]){
                    self.infoDatas[i].state = PWInfoBoardItemStateWarning;
                }else{
                    self.infoDatas[i].state = PWInfoBoardItemStateRecommend;
                }
                if([issue.renderedTextStr isEqualToString:@""]){
                    self.infoDatas[i].subTitle = issue.title;
                }else{
                    NSDictionary *dict = [NSString dictionaryWithJsonString:issue.renderedTextStr];
                    self.infoDatas[i].subTitle = dict[@"title"];
                }
            }
            self.infoDatas[i].messageCount = itemDatas.count>99?@"99+":[NSString stringWithFormat:@"%lu",(unsigned long)itemDatas.count];
            
            DLog(@"%@",itemDatas);
        }
     }
}
#pragma mark ========== 判断首页是否连接 ==========
-(BOOL)judgeIssueConnectState{
    __block BOOL connect = [getConnectState boolValue];
    if (!connect) {
        NSDictionary *param = @{@"pageNumber":@1,@"pageSize":@1};
        [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                NSDictionary *content = response[@"content"];
                NSArray *data = content[@"data"];
                if (data.count>0) {
                    connect = YES;
                    setConnect(YES);
                    [kUserDefaults synchronize];
                }else{
                    NSDictionary *params =@{@"orderBy":@"actSeq",@"orderMethod":@"desc",@"pageSize":@1};
                    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
                        if ([response[@"errCode"] isEqualToString:@""]) {
                            NSDictionary *content = response[@"content"];
                            NSArray *data = content[@"data"];
                            if (data.count>0) {
                                connect = YES;
                                setConnect(YES);
                                [kUserDefaults synchronize];
                            }
                        }
                    } failBlock:^(NSError *error) {
                        
                    }];
                }
            }
        } failBlock:^(NSError *error) {
        }];
    }
    
    return connect;
}
#pragma mark ========== 为InfoBoard提供数据 ==========
- (NSArray *)getInfoBoardData{
    [self dealDataForInfoBoard:YES];
    return self.infoDatas;
}
- (NSArray *)getIssueListWithIssueType:(NSString *)type{
    
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *whereFormat = [NSString stringWithFormat:@"where type = '%@' order by actSeq desc",type];
    NSArray *itemDatas = [pwfmdb pw_lookupTable:self.tableName dicOrModel:[IssueModel class] whereFormat:whereFormat];
    return itemDatas;
}
#pragma mark ========== 判断是否为同一天 ==========
- (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2
{
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
