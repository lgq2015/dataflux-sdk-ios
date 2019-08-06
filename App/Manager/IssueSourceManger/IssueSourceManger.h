//
//  IssueSourceManger.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class BaseReturnModel;

NS_ASSUME_NONNULL_BEGIN
@interface IssueSourceManger : NSObject
@property(nonatomic, copy) NSString *lastRefreshTime; //上次更新时间

//单例
SINGLETON_FOR_HEADER(IssueSourceManger)

- (void)downLoadAllIssueSourceList:(void (^)(BaseReturnModel *))callBackStatus;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写


/**
 每次打开app更新云服务列表
 */
- (void)downLoadAllIssueSourceList;

/**
 获取basic issueSource count
 */
- (NSInteger)getBasicIssueSourceCount;

/**
 获取  首页 检测时间
 */
- (NSString *)getLastDetectionTimeStatement;

/**
 预展示 issuesource
 */
- (NSArray *)getIssueSourceList;

- (NSInteger)getIssueSourceCount;

/**
 预展示 issuesource name 与 provider
 */
- (NSDictionary *)getIssueSourceNameAndProviderWithID:(NSString *)issueSourceID;
//- (void)checkToGetDetectionStatement:(void (^)(NSString *))getTime;

- (void)deleteIssueSourceById:(NSArray *)issueSourceIds;

/**
 退出处理
 */
-(void)logout;
@end

NS_ASSUME_NONNULL_END
