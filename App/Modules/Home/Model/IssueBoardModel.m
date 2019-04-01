//
//  IssueBoardModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueBoardModel.h"

@implementation IssueBoardModel
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithJson:dictionary];
    }
    return self;
    
}
- (void)setValueWithJson:(NSDictionary *)dict{
    self.messageCount = dict[@"messageCount"];
    self.type = [dict[@"type"] integerValue];
    self.subTitle = dict[@"subTitle"];
    self.state = [dict[@"state"] integerValue];
    self.typeName = dict[@"typeName"];
}

@end
