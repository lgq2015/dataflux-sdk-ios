//
// Created by Brandon on 2019-03-25.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "HandBookManager.h"
#import "PWDraggableModel.h"
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


- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;

        if (![[self getHelper] pw_isExistTable:tableName]) {
            [[self getHelper] pw_createTable:tableName dicOrModel:[PWDraggableModel class]];
        }

    }

    return self;
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

        [datas enumerateObjectsUsingBlock:^(PWDraggableModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
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

- (NSMutableArray<PWDraggableModel*> *)getHandBooks {

    NSMutableArray *array = [NSMutableArray new];
    NSString *tableName = PW_DB_LIBRARY_TABLE_NAME;

    [self.getHelper pw_inDatabase:^{
        NSArray<PWDraggableModel *> *itemDatas =
                [self.getHelper pw_lookupTable:tableName
                                    dicOrModel:[PWDraggableModel class]
                                   whereFormat:@" order by orderNum asc"];
        [array addObjectsFromArray:itemDatas];
    }];

    return array;

}


@end
