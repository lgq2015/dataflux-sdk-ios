//
//  IssueSourceManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceManger.h"
#import "IssueListManger.h"
#import "PWHttpEngine.h"
#import "IssueSourceListModel.h"
#import "BaseReturnModel.h"

#define ISSUE_SOURCE_PAGE_SIZE 100

@interface IssueSourceManger ()
//@property(nonatomic, copy) NSString *lastRefreshTime; //上次更新时间
@end

@implementation IssueSourceManger
+ (instancetype)sharedIssueSourceManger {
    static IssueSourceManger *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        [_sharedManger createData];
    });
    return _sharedManger;
}

- (void)createData {

}

// 重构脏代码，之后有时间再重新写
- (PWFMDB *)getHelper {
    return [IssueListManger sharedIssueListManger].getHelper;
}

#pragma mark ------------------ public  ------------------

- (void)downLoadAllIssueSourceList:(void (^)(BaseReturnModel *))callBackStatus {
    NSMutableArray *allDatas = [NSMutableArray new];

    [self getIssueAllSourceByPage:1 alldatas:allDatas lastDataStatus:^(BaseReturnModel *model) {
        if (model.isSuccess) {

            [self.getHelper pw_inTransaction:^(BOOL *rollback) {


                [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME];

                [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModelArray:allDatas];

                rollback = NO;
            }];

        }
        if (callBackStatus) {
            callBackStatus(model);
        }

    }];
}

- (void)downLoadAllIssueSourceList {
    [self downLoadAllIssueSourceList:nil];
}

// 获取基础类的 情报源总数
- (NSInteger)getBasicIssueSourceCount {

    __block NSInteger count = 0;

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = @"WHERE provider = 'aliyun' OR  provider = 'aws' OR provider = 'qcloud' OR provider= 'ucloud' OR provider = 'domain'";
        NSDictionary *dict = @{@"id": SQL_TEXT};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        count = array.count;
    }];
    return count;
}

/**
 * 返回检测描述
 * @return
 */
- (NSString *)getLastDetectionTimeStatement {

    __block NSString *statement = @"";

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = @"ORDER BY scanCheckInQueueTime DESC";
        NSDictionary *dict = @{@"scanCheckInQueueTime": SQL_TEXT};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        if (array.count == 0) {
            statement = @"尚未进行检测";
        } else {
            NSString *time = [array[0] stringValueForKey:@"scanCheckInQueueTime" default:@""];
            if (time.length > 0) {
               BOOL ishas= [[IssueListManger sharedIssueListManger] checkIssueEngineIsHasIssue];
                NSString *local = [NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                statement = [NSString stringWithFormat:@"%@为您检测", [NSString compareCurrentTime:local]];
                if (!ishas) {
                  statement = [NSString stringWithFormat:@"%@为您检测\n恭喜您，您的系统非常健康", [NSString compareCurrentTime:local]];
                }
                
            } else {
                statement = @"尚未进行检测";
            }
        }
    }];

    return statement;

}


/**
 * 从 page 开始获取到所有数据
 * @param page
 * @param allData
 * @param callBackStatus
 */
- (void)getIssueAllSourceByPage:(NSInteger)page alldatas:(NSMutableArray *)allData lastDataStatus:(void (^)(BaseReturnModel *))callBackStatus {

    [[PWHttpEngine sharedInstance] getIssueSource:ISSUE_SOURCE_PAGE_SIZE page:page callBack:^(id o) {

        IssueSourceListModel *listModel = (IssueSourceListModel *) o;
        if (listModel.isSuccess) {
            [allData addObjectsFromArray:listModel.list];

            if (listModel.list.count < ISSUE_SOURCE_PAGE_SIZE) {

                callBackStatus(listModel);

            } else {
                [[PWHttpEngine sharedInstance] getIssueSource:ISSUE_SOURCE_PAGE_SIZE page:page + 1 callBack:callBackStatus];
            }

        } else {
            callBackStatus(listModel);
        }


    }];

}

- (NSArray *)getIssueSourceListWithoutLock {
    NSString *whereFormat = @"";
    NSDictionary *dict =
            @{
                    @"provider": SQL_TEXT,
                    @"name": SQL_TEXT,
                    @"teamId": SQL_TEXT,
                    @"scanCheckStatus": SQL_TEXT,
                    @"updateTime": SQL_TEXT,
                    @"id": SQL_TEXT,
                    @"credentialJSONStr": SQL_TEXT,
                    @"scanCheckStartTime": SQL_TEXT,
                    @"scanCheckInQueueTime": SQL_TEXT,
                    @"optionsJSONStr": SQL_TEXT,
                    @"isVirtual": SQL_INTEGER,


            };
    NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
    return array;
}

- (NSArray *)getIssueSourceList {
    NSMutableArray *datas = [NSMutableArray new];
    [[self getHelper] pw_inDatabase:^{
        [datas addObjectsFromArray:self.getIssueSourceListWithoutLock];
    }];
    return datas;
}

- (NSInteger)getIssueSourceCount {
    __block NSInteger count = 0;
    [[self getHelper] pw_inDatabase:^{
        count = [[self getHelper] pw_tableItemCount:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME];
    }];

    return count;

}


- (NSString *)getIssueSourceNameWithID:(NSString *)issueSourceID {
    __block NSString *name = @"";

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where id = '%@'", issueSourceID];
        NSDictionary *dict = @{@"name": SQL_TEXT};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        if (array.count == 0) {
            name = nil;
        } else {
            name = array[0][@"name"];
        }
    }];
    return name;
}

/**
 * 页面刷新时间小于30秒则不起效
 * @param time
 */
- (void)checkToGetDetectionStatement:(void (^)(NSString *))getTime {
    if (self.lastRefreshTime && ![self.lastRefreshTime timeIntervalAboveThirtySecond]) {


    } else {
        getTime([self getLastDetectionTimeStatement]);
        self.lastRefreshTime = [NSDate getNowTimeTimestamp];

    }

}


- (void)deleteIssueSourceById:(NSArray *)issueSourceIds {
    [self.getHelper pw_inTransaction:^(BOOL *rollback) {
        [issueSourceIds enumerateObjectsUsingBlock:^(NSString *issueSourceId, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *whereFormat = [NSString stringWithFormat:@"where id = '%@'", issueSourceId];
            [self.getHelper pw_deleteTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME whereFormat:whereFormat];
        }];

    }];

}


- (void)logout {
    self.lastRefreshTime = nil;
}
@end
