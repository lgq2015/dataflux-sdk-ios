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


-(void)pw_createTable:(NSString *)tableName dicOrModel:(id)nameArrpr {
    [self pw_createTable:tableName dicOrModel:nameArrpr primaryKey:DEFAULT_PRIMARY_KEY];
}

-(void)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(id)nameArrpr {
    [self pw_createTable:tableName dicOrModel:parameters excludeName:parameters primaryKey:DEFAULT_PRIMARY_KEY];
}

@end