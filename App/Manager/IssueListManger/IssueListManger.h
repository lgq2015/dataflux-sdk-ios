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
typedef void (^loadDataSuccess)(NSArray *datas,NSNumber *pageMaker);

@interface IssueListManger : NSObject
@property (nonatomic, strong) NSMutableArray<InfoBoardModel *> *infoDatas;

//单例
SINGLETON_FOR_HEADER(IssueListManger)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
/**
 首页展示类型判断
 */
-(void)judgeIssueConnectState:(void(^)(BOOL isConnect))isConnect;
/**
 每次打开app需要判断首页展示的数据
 */
- (void)downLoadAllIssueList;
/**
  socket 推送需要更新
 */
- (void)newIssueNeedUpdate;
/**
 首页infoBoard数据提供
 */
- (NSArray *)getInfoBoardData;
/**
 情报分类页数据源获取
 */
- (NSArray *)getIssueListWithIssueType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
