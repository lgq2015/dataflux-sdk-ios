//
//  IssueLogAttachmentUrl.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueLogAttachmentUrl.h"

@implementation IssueLogAttachmentUrl
- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = PWSafeDictionaryVal(dict, @"content");
    self.externalDownloadURL= content;
}
@end
