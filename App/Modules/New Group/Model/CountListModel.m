//
//  CountListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CountListModel.h"

@implementation CountListModel
- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.count_list = PWSafeArrayVal(content, @"count_list");
}
@end
