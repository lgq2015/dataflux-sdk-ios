//
//  IssueListManger.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

typedef NS_ENUM(NSInteger ,IssueType){
    IssueTypeAll = 1,
    IssueTypeAlarm ,
    IssueTypeSecurity,
    IssueTypeExpense,
    IssueTypeOptimization,
    IssueTypeMisc,
};
typedef NS_ENUM(NSInteger ,IssueViewType){
    IssueViewTypeNormal = 1,
    IssueViewTypeAll = 2,
};
typedef NS_ENUM(NSInteger ,IssueSortType){
    IssueSortTypeCreate = 1,
    IssueViewTypeUpdate = 2,
};
typedef NS_ENUM(NSInteger ,IssueLevel){
    IssueLevelAll= 1,
    IssueLevelDanger,
    IssueLevelWarning,
    IssueLevelCommon,
};
@class IssueBoardModel;
@class IssueModel;
@class BaseReturnModel;
@class IssueLogModel;
@class SelectObject;
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

- (void)readIssueLog:(NSString *)issueId;

- (void)updateIssueBoardLastMsgTime:(NSString *)type updateTime:(NSString *)updateTime;

- (BOOL)getIssueLogReadStatus:(NSString *)issueId;
// 更新列表高度缓存
- (void)updateIssueListCellHeight:(CGFloat)cellHeight issueId:(NSString *)issueId;
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
- (void)checkSocketConnectAndFetchNewIssue:(void (^)(BaseReturnModel *))callBackStatus;

- (BOOL)isInfoBoardInit;
-(IssueSortType)getCurrentIssueSortType;
-(IssueType)getCurrentIssueType;
/**
 情报分类页数据源获取
 */
- (NSArray *)getIssueListWithIssueType:(IssueType)type issueLevel:(IssueLevel)issueLevel issueSortType:(IssueSortType)sortType;
- (NSArray *)getIssueListWithSelectObject:(nullable SelectObject *)sel;
-(SelectObject *)getCurrentSelectObject;
-(void)setCurrentSelectObject:(SelectObject *)sel;
/**
 24内恢复的情报列表o
 */
- (NSArray *)getRecoveredIssueListWithIssueType:(NSString *)type;

/**
  切换账号 清空首页infoBoard缓存信息
 */
- (void)createData;
/**
 首页 判断非自建情报 是否存在严重、紧急、一般状态的情报
 @return YES 存在  NO 不存在
 */
- (BOOL)checkIssueEngineIsHasIssue;
- (BOOL)checkIssueLastStatus:(NSString *)issueId;

- (void)deleteIssueWithIssueSourceID:(NSArray *)sourceIds ;

- (void)clearAllIssueData;
@end

NS_ASSUME_NONNULL_END
