//
//  IssueSourceManger.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^detectTimeStr)(NSString *str);
typedef void (^updateIssueSource)(NSArray *ary);
@interface IssueSourceManger : NSObject
//单例
SINGLETON_FOR_HEADER(IssueSourceManger)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写


/**
 每次打开app更新情报源列表
 */
- (void)downLoadAllIssueSourceList:(detectTimeStr)strblock;

/**
 获取basic issueSource count
 */
- (NSInteger)getBasicIssueSourceCount;
/**
 获取  首页 检测时间
 */
- (void)getLastDetectionTime:(detectTimeStr)strblock;
/**
  更新本地 issuesource
 */
- (void)updateAllIssueSourceList:(updateIssueSource)aryblock;
/**
 预展示 issuesource
 */
- (NSArray *)getIssueSourceList;
@end

NS_ASSUME_NONNULL_END
