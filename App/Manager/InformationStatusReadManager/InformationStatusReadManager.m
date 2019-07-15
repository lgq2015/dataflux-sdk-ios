//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "InformationStatusReadManager.h"
#import "UserManager.h"
#import "NewsListModel.h"
#import "ReadStatusModel.h"
#import "PWFMDB+Simplefy.h"

#define COL_NAME_NEWS_ID @"newsId"


@interface InformationStatusReadManager ()


@end

@implementation InformationStatusReadManager {


}


+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

-(void)onDBInit {
    [self.getHelper pw_inDatabase:^{

        NSString *tableName = PW_DB_INFORMATION_TABLE_NAME;
        if (![self.getHelper pw_isExistTable:tableName]) {
            NSMutableDictionary *dict = [self.getHelper getSimplyFyDefaultTable];
            dict[COL_NAME_NEWS_ID] = @"text";
            [self.getHelper pw_createTable:PW_DB_INFORMATION_TABLE_NAME dicOrModel:dict];
        }
    }];

}

- (NSString *)getDBName {
    return NSStringFormat(@"%@/%@", getPWUserIDWithDBCompat, PW_DBNAME_INFORMATION);
}

/**
 * 同步已读的数据
 * @param datas
 */
- (void)setReadStatus:(NSArray<NewsListModel *> *)datas {
    [self.getHelper pw_inDatabase:^{

        NSMutableArray *currentDatas = [NSMutableArray new];

        [datas enumerateObjectsUsingBlock:^(NewsListModel *data, NSUInteger idx, BOOL *_Nonnull stop) {
            [currentDatas addObject:NSStringFormat(@"'%@'", data.newsID)];
        }];


        NSArray<ReadStatusModel *> *readDatas = [self.getHelper
                pw_lookupTable:PW_DB_INFORMATION_TABLE_NAME
                    dicOrModel:[ReadStatusModel class]
                   whereFormat:@"WHERE "COL_NAME_NEWS_ID" IN (%@)",
                               [currentDatas componentsJoinedByString:@","]];

        NSMutableArray *reads = [NSMutableArray new];
        [readDatas enumerateObjectsUsingBlock:^(ReadStatusModel *data, NSUInteger idx, BOOL *_Nonnull stop) {
            [reads addObject:data.newsId];
        }];

        [datas enumerateObjectsUsingBlock:^(NewsListModel *data, NSUInteger idx, BOOL *_Nonnull stop) {
            data.read = [reads containsObject:data.newsID];
        }];

    }];

}

/**
 * 存入读取的 id
 * @param id
 */
- (void)readInformation:(NSString *)id {
    [self.getHelper pw_inDatabase:^{
        NSDictionary *insertValues = @{COL_NAME_NEWS_ID: id};

        NSString *table = PW_DB_INFORMATION_TABLE_NAME;
        NSString *whereSql = @"WHERE "COL_NAME_NEWS_ID" ='%@'";
        NSArray *results = [self.getHelper pw_lookupTable:table dicOrModel:[ReadStatusModel class] whereFormat:whereSql, id];
        if (results.count > 0) {
            [self.getHelper pw_updateTable:table dicOrModel:insertValues whereFormat:whereSql, id];

        } else {
            [self.getHelper pw_insertTable:table dicOrModel:insertValues];
        }

    }];
}


@end
