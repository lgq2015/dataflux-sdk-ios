//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWFMDB (Simplefy)


- (NSMutableDictionary *)getSimplyFyDefaultTable;

- (void)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters;

- (void)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArrpr;
@end