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
- (NSString *)getLastDetectionTime;
@end

NS_ASSUME_NONNULL_END
