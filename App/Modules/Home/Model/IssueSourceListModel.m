//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueSourceListModel.h"
#import "IssueSourceModel.h"


@implementation IssueSourceListModel {

}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];

    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");

    self.list = [NSMutableArray new];

    NSArray *array = PWSafeArrayVal(content, @"data");
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.list addObject:[[IssueSourceModel alloc] initWithDictionary:dict]];
    }];


}
@end