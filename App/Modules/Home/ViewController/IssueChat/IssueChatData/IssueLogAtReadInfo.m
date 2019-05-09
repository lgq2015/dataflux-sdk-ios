//
//  IssueLogAtReadInfo.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueLogAtReadInfo.h"

@implementation IssueLogAtReadInfo
- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.readInfo= PWSafeDictionaryVal(content, @"readInfo");
    self.lastReadSeqInfo = PWSafeDictionaryVal(content, @"lastReadSeqInfo");
}
@end
