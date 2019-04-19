//
// Created by Brandon on 2019-03-25.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "HandBookManager.h"
#import "LibraryModel.h"
#import "PWFMDB+Simplefy.h"


@implementation HandBookManager {

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
    NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;

    if (![[self getHelper] pw_isExistTable:tableName]) {
        [[self getHelper] pw_createTable:tableName dicOrModel:[LibraryModel class]];
    }

}


- (NSString *)getDBName {
     DLog(@"%@",getPWUserID);
    return NSStringFormat(@"%@/%@", getPWUserID, PW_DBNAME_LIBRARY);
}


/**
 * 缓存数据
 * @param datas
 */
- (void)cacheHandBooks:(NSArray *)datas {

    NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;

    [self.getHelper pw_inTransaction:(void (^)(BOOL *)) ^{

        [datas enumerateObjectsUsingBlock:^(LibraryModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *where = @"WHERE handbookId='%@'";
            NSString *handbookId = newModel.handbookId;
            newModel.orderNum = idx;
            NSArray *itemDatas = [self.getHelper pw_lookupTable:tableName
                                                     dicOrModel:@{@"handbookId": @"TEXT"}
                                                    whereFormat:where,
                                                                handbookId];
            if (itemDatas.count > 0) {
                [self.getHelper pw_updateTable:tableName dicOrModel:newModel whereFormat:where, handbookId];
            } else {
                [self.getHelper pw_insertTable:tableName dicOrModel:newModel];
            }
        }];
    }];
}

/**
 * 清空所有数据
 */
- (void)deleteAllHandBooks{
    NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;
    [self.getHelper pw_inTransaction:(void (^)(BOOL *)) ^{
        [self.getHelper pw_deleteAllDataFromTable:tableName];
    }];
}

- (NSMutableArray<LibraryModel*> *)getHandBooks {

    NSMutableArray *array = [NSMutableArray new];
    NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;

    [self.getHelper pw_inDatabase:^{
        NSArray<LibraryModel *> *itemDatas =
                [self.getHelper pw_lookupTable:tableName
                                    dicOrModel:[LibraryModel class]
                                   whereFormat:@" order by orderNum asc"];
        [array addObjectsFromArray:itemDatas];
    }];

    return array;

}


@end
