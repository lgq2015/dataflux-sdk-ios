//
//  PWWeakProxy.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWWeakProxy : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end

NS_ASSUME_NONNULL_END
