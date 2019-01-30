//
//  PWInfoSourceModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWInfoSourceModel.h"

@implementation PWInfoSourceModel
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithJson:dictionary];
    }
    return self;
}
- (void)setValueWithJson:(NSDictionary *)dict{
    self.name = dict[@"name"];
    self.issueId = dict[@"id"];
    self.provider = dict[@"provider"];
    if ([dict[@"scanCheckStatus"] isEqualToString:@"nerverStarted"]) {
        self.state = SourceStateNotDetected;
    }
    if ([dict[@"provider"] isEqualToString:@"aliyun"]) {
        self.type = SourceTypeAli;
    }
}
@end
