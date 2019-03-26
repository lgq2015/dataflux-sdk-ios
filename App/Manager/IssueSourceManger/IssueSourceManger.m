//
//  IssueSourceManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceManger.h"
#import "IssueListManger.h"

typedef void (^loadDataSuccess)(NSArray *datas);

@interface IssueSourceManger ()
@property(nonatomic, strong) NSMutableArray *issueSourceList;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, copy) detectTimeStr strBlock;   //-> 回掉
@property(nonatomic, copy) updateIssueSource aryBlock; //
@property(nonatomic, copy) NSString *lastRefreshTime; //上次更新时间
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

- (void)downLoadAllIssueSourceList:(detectTimeStr)strblock {
    self.strBlock = strblock;
    [self downLoadAllIssueSourceListWithTypeTime:YES];
}

- (NSInteger)getBasicIssueSourceCount {

    __block NSInteger count = 0;

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = @"where provider = 'aliyun' or  provider = 'aws' or provider = 'qcloud' or provider= 'ucloud' or provider = 'domain'";
        NSDictionary *dict = @{@"id": @"TEXT"};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        count = array.count;
    }];
    return count;
}

- (void)getLastDetectionTime:(detectTimeStr)strblock {
    //判断时间间隔
    if (self.lastRefreshTime && ![self.lastRefreshTime timeIntervalAboveThirtySecond]) {
        //小于30s
        self.strBlock = strblock;
        [self getLastDetectionTimeNow];
    } else {
        [self downLoadAllIssueSourceListWithTypeTime:YES];
    }
}
- (void)updateAllIssueSourceList:(updateIssueSource)aryblock{
      self.aryBlock = aryblock;
      self.issueSourceList = [NSMutableArray new];
      [self downLoadAllIssueSourceListWithTypeTime:NO];
    
}

- (NSArray *)getIssueSourceListWithoutLock {
    NSString *whereFormat = @"";
    NSDictionary *dict =
            @{
                    @"provider": @"TEXT",
                    @"name": @"TEXT",
                    @"teamId": @"TEXT",
                    @"scanCheckStatus": @"TEXT",
                    @"provider": @"TEXT",
                    @"teamId": @"TEXT",
                    @"updateTime": @"TEXT",
                    @"id": @"TEXT",
                    @"credentialJSON": @"TEXT",
                    @"credentialJSONstr": @"TEXT",
                    @"scanCheckStartTime": @"TEXT",
                    @"scanCheckInQueueTime": @"TEXT"
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

#pragma mark ------------------ privite ------------------

- (void)getIssueSourceListprivite {
    NSArray *array = [self getIssueSourceListWithoutLock];
    if (array.count > 0) {
        self.aryBlock ? self.aryBlock(array) : nil;
    } else {
        self.aryBlock ? self.aryBlock(@[]) : nil;
    }

}

//  istime  是否是获取首页更新检测时间
- (void)downLoadAllIssueSourceListWithTypeTime:(BOOL)istime {
    self.currentPage = 1;
    self.issueSourceList = [NSMutableArray new];
    NSDictionary *param = @{@"pageSize": @100, @"pageNumber": [NSNumber numberWithInteger:self.currentPage]};

    [self loadIssueSourceListWithParam:param completion:^(NSArray *_Nonnull datas) {
        [self dealDataWith:datas isTime:istime];
    }];
}

- (void)dealDataWith:(NSArray *)datas isTime:(BOOL)istime {
    NSMutableArray *array = [NSMutableArray new];

    if (datas.count > 0) {
        [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
            if (![obj[@"credentialJSON"] isKindOfClass:[NSNull class]]) {
                NSString *credentialJSON = [obj[@"credentialJSON"] jsonPrettyStringEncoded];
                [dict setValue:credentialJSON forKey:@"credentialJSONstr"];
            }
            [array addObject:dict];
        }];

        [self.getHelper pw_inDatabase:^{
            if ([self.getHelper pw_isExistTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME]) {
                [self dealWithData:array isTime:istime];
            } else {

                NSArray *issuccess = [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModelArray:array];
                if (issuccess.count == 0) {
                    istime ? [self getLastDetectionTimeNow] : [self getIssueSourceListprivite];
                }
            }
        }];


    } else {
        [self.getHelper pw_inDatabase:^{
            [self dealWithData:array isTime:istime];
        }];
    }
    self.lastRefreshTime = [NSDate getNowTimeTimestamp];
}

- (void)dealWithData:(NSArray *)array isTime:(BOOL)istime {
    NSArray *issuelist = [self getIssueSourceListWithoutLock];
    if (issuelist.count > 0) {

        __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:5];
        //找到数据库中有,新数据中没有的数据
        [issuelist enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {

            __block BOOL isHave = NO;
            [array enumerateObjectsUsingBlock:^(NSDictionary *newDict, NSUInteger idx, BOOL *_Nonnull stop) {

                if ([dict[@"id"] isEqualToString:newDict[@"id"]]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:dict];
            }
        }];

        if (difObject.count > 0) {
            [difObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[IssueListManger sharedIssueListManger]delectIssueWithIsseuSourceID:[obj stringValueForKey:@"id" default:@""]];
            }];
            
        }


        [self.getHelper pw_deleteAllDataFromTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME];
        NSArray *issuccess = [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModelArray:array];
        if (issuccess.count == 0) {
            istime ? [self getLastDetectionTimeNow] : [self getIssueSourceListprivite];
        }


    } else {
        if (array.count == 0) {
            self.strBlock ? self.strBlock(@"尚未进行检测") : nil;
        } else {

            NSArray *issuccess = [self.getHelper pw_insertTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModelArray:array];
            if (issuccess) {
                istime ? [self getLastDetectionTimeNow] : [self getIssueSourceListprivite];
            }

        }

    }
//    if (array.count>0) {
//        self.aryBlock ? self.aryBlock(array) :nil;
//    }else{
//        self.aryBlock ? self.aryBlock(@[]) :nil;
//    }
}

- (void)getLastDetectionTimeNow {
    NSString *whereFormat = @"order by scanCheckInQueueTime desc";
    NSDictionary *dict = @{@"scanCheckInQueueTime": @"TEXT"};
    NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
    if (array.count == 0) {
        self.strBlock ? self.strBlock(@"尚未进行检测") : nil;
    } else {
        NSString *checkTime;
        NSString *time = array[0][@"scanCheckInQueueTime"];
        if (time == nil) {
            checkTime = @"尚未进行检测";
        }else{
        NSString *local = [NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            checkTime = [NSString stringWithFormat:@"最近一次检测时间：%@", [NSString compareCurrentTime:local]];
        }
        self.strBlock ? self.strBlock(checkTime) : nil;
    }
}

- (void)loadIssueSourceListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion {
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count > 0) {
                [self.issueSourceList addObjectsFromArray:data];
                NSDictionary *pageInfo = content[@"pageInfo"];
                long totalCount = [pageInfo longValueForKey:@"totalCount" default:0];

                if (totalCount > self.issueSourceList.count) {
                    self.currentPage++;
                    NSDictionary *params = @{@"pageSize": @100, @"pageNumber": [NSNumber numberWithInteger:self.currentPage]};
                    [self loadNextIssueSourceListWithParam:params completion:^(NSArray *_Nonnull datas) {
                        completion(datas);
                    }];
                } else {
                    completion(self.issueSourceList);
                }

            } else {
                completion(self.issueSourceList);
            }
        } else {
          //请求错误
        }

    } failBlock:^(NSError *error) {
         //网络请求错误
    }];
}

- (void)loadNextIssueSourceListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion {
    [self loadIssueSourceListWithParam:param completion:^(NSArray *_Nonnull datas) {
        completion(datas);
    }];
}

- (NSString *)getIssueSourceNameWithID:(NSString *)issueSourceID {
    __block NSString *name = @"";

    [self.getHelper pw_inDatabase:^{
        NSString *whereFormat = [NSString stringWithFormat:@"where id = '%@'", issueSourceID];
        NSDictionary *dict = @{@"name": @"TEXT"};
        NSArray *array = [self.getHelper pw_lookupTable:PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME dicOrModel:dict whereFormat:whereFormat];
        if (array.count == 0) {
            name = nil;
        } else {
            name = array[0][@"name"];
        }
    }];
    return name;
}

@end
