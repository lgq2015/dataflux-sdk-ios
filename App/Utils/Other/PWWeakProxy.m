//
//  PWWeakProxy.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWWeakProxy.h"

@implementation PWWeakProxy
+ (instancetype)proxyWithTarget:(id)target {
    PWWeakProxy *proxy = [PWWeakProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}
@end
