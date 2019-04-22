//
// Created by Brandon on 2019-04-18.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "BaseListReturnModel.h"


@implementation BaseListReturnModel {

}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.list = [NSMutableArray new];

    NSArray *array = PWSafeArrayVal(content, @"data");

    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.list addObject:[self getItemData:obj]];
    }];


}


- (id)getItemData:(NSDictionary *)dic {
    return [[BaseReturnModel alloc] initWithDictionary:dic];
}

@end