//
//  IssueListManger.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InfoBoardModel;
NS_ASSUME_NONNULL_BEGIN
@interface IssueListManger : NSObject
@property (nonatomic, strong) NSMutableArray<InfoBoardModel *> *infoDatas;

//单例
SINGLETON_FOR_HEADER(IssueListManger)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写

- (void)downLoadAllIssueList;
- (BOOL)judgeIssueConnectState;
- (void)insertIssue;
- (NSArray *)getInfoBoardData;
- (NSArray *)getIssueListWithIssueType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
