//
//  PWFMDB.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/28.
//  Copyright © 2018 hll. All rights reserved.
//

#import "PWFMDB.h"
#import "FMDB.h"
#import <objc/runtime.h>
@interface PWFMDB ()

@property (nonatomic, strong)NSString *dbPath;
@property (nonatomic, strong)FMDatabaseQueue *dbQueue;
@property (nonatomic, strong)FMDatabase *db;

@end
@implementation PWFMDB
static PWFMDB *jqdb = nil;

+ (instancetype)shareDatabase
{
    return [PWFMDB shareDatabase:nil];
}

+ (instancetype)shareDatabase:(NSString *)dbName
{
    return [PWFMDB shareDatabase:dbName path:nil];
}
+ (instancetype)shareDatabase:(NSString *)dbName path:(NSString *)dbPath
{
    if (!jqdb) {
        
        NSString *path;
        if (!dbName) {
            dbName = @"PWFMDB.sqlite";
        }
        if (!dbPath) {
            path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
        } else {
            path = [dbPath stringByAppendingPathComponent:dbName];
        }
        FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
        if ([fmdb open]) {
            jqdb = PWFMDB.new;
            jqdb.db = fmdb;
            jqdb.dbPath = path;
        }
    }
    if (![jqdb.db open]) {
        DLog(@"database can not open !");
        return nil;
    };
    return jqdb;
}
- (instancetype)initWithDBName:(NSString *)dbName
{
    return [self initWithDBName:dbName path:nil];
}

- (instancetype)initWithDBName:(NSString *)dbName path:(NSString *)dbPath
{
    if (!dbName) {
        dbName = @"PWFMDB.sqlite";
    }
    NSString *path;
    if (!dbPath) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    } else {
        path = [dbPath stringByAppendingPathComponent:dbName];
    }
    
    FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
    
    if ([fmdb open]) {
        self = [self init];
        if (self) {
            self.db = fmdb;
            self.dbPath = path;
            return self;
        }
    }
    return nil;
}
@end
