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
    self.count_list = PWSafeArrayVal(dict, @"content");
}
@end
