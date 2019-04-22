//
// Created by Brandon on 2019-04-21.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "AddIssueLogReturnModel.h"


@implementation AddIssueLogReturnModel {

}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.id= [content stringValueForKey:@"id" default:@""];
}

@end