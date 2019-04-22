//
//  IssueListManger.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class IssueBoardModel;
@class IssueModel;
@class BaseReturnModel;
@class IssueLogModel;
NS_ASSUME_NONNULL_BEGIN

@interface IssueListManger : BaseSqlHelper
@property (nonatomic, strong) NSMutableArray<IssueBoardModel *> *infoDatas;

//单例
SINGLETON_FOR_HEADER(IssueListManger)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (void)updateIssueLogInIssue:(NSString *)issueId data:(IssueLogModel *)data;

- (void)readIssue:(NSString *)issueId;

- (BOOL)getIssueLogReadStatus:(NSString *)issueId;

/**
 首页展示类型判断
 */
-(BOOL)judgeIssueConnectState;

- (void)updateIssueBoardGetMsgTime:(NSString *)type;

/**
 每次打开app需要判断首页展示的数据 会内部判断是否需要更新


 */
- (void)fetchIssueList:(BOOL)getAllDatas;

- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus getAllDatas:(BOOL)getAllDatas;

- (IssueModel *)getIssueDataByData:(NSString *)issueId;

/**
 首页infoBoard数据提供
 */
- (NSArray *)getIssueBoardData;

- (void)checkSocketConnectAndFetchIssue:(void (^)(BaseReturnModel *))callBackStatus;

- (BOOL)isInfoBoardInit;

/**
 情报分类页数据源获取
 */
- (NSArray *)getIssueListWithIssueType:(NSString *)type;
/**
  切换账号 清空首页infoBoard缓存信息
 */
- (void)createData;

- (BOOL)checkIssueLastStatus:(NSString *)issueId;

- (void)deleteIssueWithIssueSourceID:(NSArray *)sourceIds ;

- (void)clearAllIssueData;
@end

NS_ASSUME_NONNULL_END
