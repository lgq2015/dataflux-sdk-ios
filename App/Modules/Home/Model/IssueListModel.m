//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueListModel.h"
#import "IssueModel.h"


@implementation IssueListModel {

}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.list = [NSMutableArray new];

    NSArray *array = PWSafeArrayVal(content, @"data");

    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.list addObject:[[IssueModel alloc] initWithDictionary:obj]];
    }];


}


@end