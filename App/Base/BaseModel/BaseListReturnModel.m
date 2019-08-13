//
// Created by Brandon on 2019-04-18.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseListReturnModel.h"


@implementation BaseListReturnModel {

}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSArray *array;
    if ([dict[@"content"] isKindOfClass:NSDictionary.class]) {
        NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
        array = PWSafeArrayVal(content, @"data");
        if ([content containsObjectForKey:@"pageInfo"]) {
            NSDictionary *pageInfo = content[@"pageInfo"];
            self.count = [pageInfo longValueForKey:@"count" default:0];
            self.pageMarker = [pageInfo longValueForKey:@"pageMarker" default:-1];
            self.pageSize = [pageInfo longValueForKey:@"pageSize" default:0];
        }
    }else if([dict[@"content"] isKindOfClass:NSArray.class]){
        array = dict[@"content"];
    }
   
    self.list = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.list addObject:[self getItemData:obj]];
    }];


}


- (id)getItemData:(NSDictionary *)dic {
    return [[BaseReturnModel alloc] initWithDictionary:dic];
}

@end
