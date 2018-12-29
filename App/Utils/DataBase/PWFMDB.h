//
//  PWFMDB.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/28.
//  Copyright © 2018 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWFMDB : NSObject
/**
 单例方法创建数据库, 如果使用shareDatabase创建,则默认在NSDocumentDirectory下创建PWFMDB.sqlite, 但只要使用这三个方法任意一个创建成功, 之后即可使用三个中任意一个方法获得同一个实例,参数可随意或nil
 
 dbName 数据库的名称 如: @"Users.sqlite", 如果dbName = nil,则默认dbName=@"PWFMDB.sqlite"
 dbPath 数据库的路径, 如果dbPath = nil, 则路径默认为NSDocumentDirectory
 */
+ (instancetype)shareDatabase;
+ (instancetype)shareDatabase:(NSString *)dbName;
+ (instancetype)shareDatabase:(NSString *)dbName path:(NSString *)dbPath;
/**
 非单例方法创建数据库
 
 @param dbName 数据库的名称 如: @"Users.sqlite"
 dbPath 数据库的路径, 如果dbPath = nil, 则路径默认为NSDocumentDirectory
 */
- (instancetype)initWithDBName:(NSString *)dbName;
- (instancetype)initWithDBName:(NSString *)dbName path:(NSString *)dbPath;
/**
 创建表 通过传入的model或dictionary(如果是字典注意类型要写对),虽然都可以不过还是推荐以下都用model
 
 @param tableName 表的名称
 @param parameters 设置表的字段,可以传model(runtime自动生成字段)或字典(格式:@{@"name":@"TEXT"})
 @return 是否创建成功
 */
- (BOOL)pw_createTable:(NSString *)tableName dicOrModel:(id)parameters;

@end
