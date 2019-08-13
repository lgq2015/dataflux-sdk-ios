//
//  UtilsConstManager.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UtilsConstManager : NSObject
SINGLETON_FOR_HEADER(UtilsConstManager)

- (void)getAllUtilsConst;
- (void)getserviceCodeNameByKey:(NSString *)key name:(void(^)(NSString *name))name;
/**
 获取专家名称
 */
- (void)getExpertNameByKey:(NSString *)key name:(void(^)(NSString *name))name;
/**
 获取云服务名称
 */
- (void)getIssueSourceNameByKey:(NSString *)key name:(void(^)(NSString *name))name;
- (void)getIssueLevelNameByKey:(NSString *)key name:(void(^)(NSString *name))name;

- (void)getTeamISPs:(void(^)(NSArray *isps))ISPs;
- (void)getTradesData:(void(^)(NSArray *data))trades;
- (void)getDistrictData:(void(^)(NSArray *data))district;
@end

NS_ASSUME_NONNULL_END
