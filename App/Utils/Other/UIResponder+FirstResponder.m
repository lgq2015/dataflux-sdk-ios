//
//  UIResponder+FirstResponder.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "UIResponder+FirstResponder.h"
static __weak id currentFirstResponder;
@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}


@end
