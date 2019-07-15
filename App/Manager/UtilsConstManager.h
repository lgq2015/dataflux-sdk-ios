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
- (void)getserviceCodeNameByKey:(NSString *)key name:(void(^)(NSString *name))name;
- (void)loadServiceCodeName:(nullable void (^)(NSDictionary *serviceCode))completion;
@end

NS_ASSUME_NONNULL_END