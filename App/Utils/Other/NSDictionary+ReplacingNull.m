//
//  NSDictionary+ReplacingNull.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NSDictionary+ReplacingNull.h"

@implementation NSDictionary (ReplacingNull)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replace = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (NSString *key in replace) {
        const id object = [self objectForKey:key];
        if (object == nul) {
            [replace setObject:blank forKey:key];
        }
    }
    return [replace copy];
}

//- (NSArray *)arrayValueForKey:(NSString *)key default:(NSArray *)def{
//    
//}

@end
