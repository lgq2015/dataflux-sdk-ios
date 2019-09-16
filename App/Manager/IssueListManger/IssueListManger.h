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
    IssueTypeReport,
    IssueTypeTask,
};
//typedef NS_ENUM(NSInteger ,IssueViewType){
//    IssueViewTypeNormal = 1,
//    IssueViewTypeAll = 2,
//};
typedef NS_ENUM(NSInteger ,IssueFrom){
    IssueFromMe = 1,   //与我相关的 包括@ 指派 标记 创建等
    IssueFromAll = 2,
};
typedef NS_ENUM(NSInteger ,IssueSortType){
    IssueSortTypeCreate = 1,
    IssueSortTypeUpdate = 2,
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
extern NSString *const ILMStringAll;
@interface IssueListManger : BaseSqlHelper

//单例
SINGLETON_FOR_HEADER(IssueListManger)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (void)updateIssueLogInIssue:(NSString *)issueId data:(IssueLogModel *)data;

- (void)readIssue:(NSString *)issueId;

- (void)readIssueLog:(NSString *)issueId;

- (BOOL)getIssueLogReadStatus:(NSString *)issueId;
// 更新列表高度缓存
- (void)updateIssueListCellHeight:(CGFloat)cellHeight issueId:(NSString *)issueId;

//- (void)updateIssueBoardGetMsgTime:(NSString *)type;

/**
 每次打开app需要判断首页展示的数据 会内部判断是否需要更新
 */
- (void)fetchIssueList:(BOOL)getAllDatas;

- (void)fetchIssueList:(void (^)(BaseReturnModel *))callBackStatus getAllDatas:(BOOL)getAllDatas;

- (IssueModel *)getIssueDataByData:(NSString *)issueId;


- (void)checkSocketConnectAndFetchIssue:(void (^)(BaseReturnModel *))callBackStatus;
- (void)checkSocketConnectAndFetchNewIssue:(void (^)(BaseReturnModel *))callBackStatus;


-(IssueSortType)getCurrentIssueSortType;

- (NSArray *)getIssueListWithSelectObject:(nullable SelectObject *)sel;
- (NSArray *)getIssueListWithSelectObject:(nullable SelectObject *)sel issueTitle:(NSString *)title;
- (SelectObject *)getCurrentSelectObject;
- (void)setCurrentSelectObject:(SelectObject *)sel;
- (NSArray *)getHistoryOriginInput;
- (NSArray *)getHistoryTitleInput;
- (void)setHistoryOriginInputWithArray:(NSArray *)array;
- (void)setSearchIssueTitleArray:(NSArray *)array;
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
