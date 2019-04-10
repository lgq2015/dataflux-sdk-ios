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

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        self.dbQueue = fmdb;
        [_db close];
        self.db = [fmdb valueForKey:@"_db"];
    }
    return _dbQueue;
}



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
        DLog(@"%@",path);
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

    NSString *parentPath =  [path stringByDeletingLastPathComponent];

    if (![[NSFileManager defaultManager] fileExistsAtPath:parentPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    FMDatabase *fmdb = [FMDatabase databaseWithPath:path];

    if ([fmdb open]) {
        self = [self init];
        if (self) {
            self.db = fmdb;
            self.dbPath = path;
            DLog(@"%@",path);
            return self;
        }
    }
    return nil;
}
- (BOOL)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters primaryKey:(NSString *)primaryKey
{
    return [self pw_createTable:tableName dicOrModel:parameters excludeName:nil primaryKey:primaryKey];
}

- (BOOL)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr primaryKey:(NSString *)primaryKey
{

    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    } else {
        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(parameters);
            }
        } else if ([parameters isKindOfClass:[NSObject class]]) {
            CLS = [parameters class];
        } else {
            CLS = parameters;
        }
        dic = [self modelToDictionary:CLS excludePropertyName:nameArr];
    }

    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", tableName,primaryKey];

    int keyCount = 0;
    for (NSString *key in dic) {

        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:primaryKey]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }

        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }

    BOOL creatFlag;
    creatFlag = [_db executeUpdate:fieldStr];
    DLog(@"%@",fieldStr);
    return creatFlag;
}
- (NSString *)createTable:(NSString *)tableName dictionary:(NSDictionary *)dic excludeName:(NSArray *)nameArr primaryKey:(NSString *)primaryKey
{
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", tableName,primaryKey];

    int keyCount = 0;
    for (NSString *key in dic) {

        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:primaryKey]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }

        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }

    return fieldStr;
}

- (NSString *)createTable:(NSString *)tableName model:(Class)cls excludeName:(NSArray *)nameArr primaryKey:(NSString *)primaryKey
{
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY,", tableName,primaryKey];

    NSDictionary *dic = [self modelToDictionary:cls excludePropertyName:nameArr];
    int keyCount = 0;
    for (NSString *key in dic) {

        keyCount++;
        if ([key isEqualToString:primaryKey]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }

        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }

    return fieldStr;
}

#pragma mark - *************** runtime
- (NSDictionary *)modelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {

        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([nameArr containsObject:name]) continue;

        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];

        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }

    }
    free(properties);

    return mDic;
}
// 获取model的key和value
- (NSDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName clomnArr:(NSArray *)clomnArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);

    for (int i = 0; i < outCount; i++) {

        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (![clomnArr containsObject:name]) {
            continue;
        }

        id value = [model valueForKey:name];
        if (value) {
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);

    return mDic;
}

- (NSString *)propertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }

    return resultStr;
}

// 得到表里的字段名称
- (NSArray *)getColumnArr:(NSString *)tableName db:(FMDatabase *)db
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];

    FMResultSet *resultSet = [db getTableSchema:tableName];

    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    [resultSet close];
    return mArr;
}
#pragma mark - *************** 增删改查
- (BOOL)pw_insertTable:(NSString *)tableName dicOrModel:(id)parameters
{
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    return [self insertTable:tableName dicOrModel:parameters columnArr:columnArr];
}

- (BOOL)insertTable:(NSString *)tableName dicOrModel:(id)parameters columnArr:(NSArray *)columnArr
{
    BOOL flag;
    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else {
        dic = [self getModelPropertyKeyValue:parameters tableName:tableName clomnArr:columnArr];
    }

    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];

    for (NSString *key in dic) {

        if (![columnArr containsObject:key] ) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];

        [argumentsArr addObject:dic[key]];
    }

    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];

    [finalStr appendFormat:@") values (%@)", tempStr];

    flag = [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    return flag;
}

- (BOOL)pw_deleteTable:(NSString *)tableName whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@  %@", tableName,where];
    flag = [_db executeUpdate:finalStr];

    return flag;
}

- (BOOL)pw_updateTable:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSDictionary *dic;
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else {
        dic = [self getModelPropertyKeyValue:parameters tableName:tableName clomnArr:clomnArr];
    }

    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];

    for (NSString *key in dic) {

        if (![clomnArr containsObject:key]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }

    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];


    flag =  [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];

    return flag;
}


- (NSArray *)pw_lookupTable:(NSString *)tableName dicOrModel:(id)parameters
                    withSql:(NSString *)sqlTable whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    NSMutableString *finalStr;
    if(sqlTable.length>0){
        finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", sqlTable, where?where:@""];
    } else{
        finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    }

    NSArray *clomnArr = [self getColumnArr:tableName db:_db];

    FMResultSet *set = [_db executeQuery:finalStr];

    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;

        while ([set next]) {

            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {

                if ([dic[key] isEqualToString:SQL_TEXT]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SQL_INTEGER]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SQL_REAL]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SQL_BLOB]) {
                    id value = [set dataForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                }

            }

            if (resultDic) [resultMArr addObject:resultDic];
        }

    }else {

        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(parameters);
            }
        } else if ([parameters isKindOfClass:[NSObject class]]) {
            CLS = [parameters class];
        } else {
            CLS = parameters;
        }

        if (CLS) {
            NSDictionary *propertyType = [self modelToDictionary:CLS excludePropertyName:nil];

            while ([set next]) {

                id model = CLS.new;
                for (NSString *name in clomnArr) {
                    if ([propertyType[name] isEqualToString:SQL_TEXT]) {
                        id value = [set stringForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_INTEGER]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_REAL]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_BLOB]) {
                        id value = [set dataForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    }
                }

                [resultMArr addObject:model];
            }
        }

    }

    [set close];

    return resultMArr;
}




- (NSArray *)pw_lookupTable:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    NSArray *array =  [self pw_lookupTable:tableName dicOrModel:parameters withSql:nil whereFormat:where];

    return array;
}
// 直接传一个array插入
- (NSArray *)pw_insertTable:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray
{

    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    for (id parameters in dicOrModelArray) {

        BOOL flag = [self insertTable:tableName dicOrModel:parameters columnArr:columnArr];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }

    return resultMArr;
}

- (BOOL)pw_deleteTable:(NSString *)tableName
{

    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}

- (BOOL)pw_deleteAllDataFromTable:(NSString *)tableName
{

    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }

    return YES;
}

- (BOOL)pw_isExistTable:(NSString *)tableName
{

    FMResultSet *set = [_db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master "
                                         "WHERE type ='table' and name = ?", tableName];

    NSInteger count = 0;
    if ([set next]) {
        count = [set intForColumn:@"count"];
    }
    [set close];
    return count > 0;
}
- (NSArray *)pw_columnNameArray:(NSString *)tableName
{
    return [self getColumnArr:tableName db:_db];
}

- (int)pw_tableItemCount:(NSString *)tableName
{

    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];

    NSInteger count =0;
    if ([set next]) {
        count= [set intForColumn:@"count"];
    }
    [set close];
    return count;
}

- (void)close
{
    [_db close];
}
- (void)open
{
    [_db open];
}

- (BOOL)pw_alterTable:(NSString *)tableName dicOrModel:(id)parameters
{
    return [self pw_alterTable:tableName dicOrModel:parameters excludeName:nil];
}

- (BOOL)pw_alterTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr
{
    __block BOOL flag;
    [self pw_inTransaction:^(BOOL *rollback) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in parameters) {
                if (![_db columnExists:key inTableWithName:tableName]){
                    flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, parameters[key]]];
                    if (!flag) {
                        *rollback = YES;
                        return;
                    }

                }
//                if ([nameArr containsObject:key]) {
//                    continue;
//                }
            }

        } else {
            Class CLS;
            if ([parameters isKindOfClass:[NSString class]]) {
                if (!NSClassFromString(parameters)) {
                    CLS = nil;
                } else {
                    CLS = NSClassFromString(parameters);
                }
            } else if ([parameters isKindOfClass:[NSObject class]]) {
                CLS = [parameters class];
            } else {
                CLS = parameters;
            }
            NSDictionary *modelDic = [self modelToDictionary:CLS excludePropertyName:nameArr];
            NSArray *columnArr = [self getColumnArr:tableName db:_db];
            for (NSString *key in modelDic) {
                if (![columnArr containsObject:key] && ![nameArr containsObject:key]) {
                    flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, modelDic[key]]];
                    if (!flag) {
                        *rollback = YES;
                        return;
                    }
                }
            }
        }
    }];

    return flag;
}

// =============================   线程安全操作    ===============================

- (void)pw_inDatabase:(void(^)(void))block
{

    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        block();
    }];
}

- (void)pw_inTransaction:(void(^)(BOOL *rollback))block
{

    [[self dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(rollback);
    }];

}

@end
