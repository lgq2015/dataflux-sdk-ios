//
//  PWSocketManager.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SocketIO;

NS_ASSUME_NONNULL_BEGIN

@interface PWSocketManager : NSObject

+ (instancetype)sharedPWSocketManager;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (void)connectWithToken:(NSString *)token success:(void(^)())success fail:(void(^)())fail;
@end

NS_ASSUME_NONNULL_END
