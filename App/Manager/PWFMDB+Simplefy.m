//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "PWFMDB+Simplefy.h"

#define DEFAULT_PRIMARY_KEY @"pw_default_id"


@implementation PWFMDB (Simplefy)

- (NSMutableDictionary *)getSimplyFyDefaultTable {
    return [@{DEFAULT_PRIMARY_KEY: @"integer"} mutableCopy];
}

- (NSArray *)defaultExcludeKey {
    return @[ERROR_CODE,ERROR_MSG,CODE];
}


-(void)pw_createTable:(NSString *)tableName dicOrModel:(id)nameArrpr {
    [self pw_createTable:tableName dicOrModel:nameArrpr excludeName:self.defaultExcludeKey primaryKey:DEFAULT_PRIMARY_KEY];
}

-(void)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray*)nameArrpr {
    [nameArrpr arrayByAddingObjectsFromArray:self.defaultExcludeKey];
    [self pw_createTable:tableName dicOrModel:parameters excludeName:nameArrpr primaryKey:DEFAULT_PRIMARY_KEY];
}

@end