//
// Created by Brandon on 2019-03-27.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "NSDictionary+URL.h"


@implementation NSDictionary (URL)
- (NSString *)queryString {
    NSURLComponents *components = [NSURLComponents new];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in [self allKeys]) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:self[key]]];
    }
    components.queryItems = queryItems;
    return [components.URL description];
}

@end