//
// Created by Brandon on 2019-03-31.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueSourceModel.h"


@implementation IssueSourceModel {

}


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}


-(void)setValueWithDict:(NSDictionary *)dict {

    self.provider = [dict stringValueForKey:@"provider" default:@""];
    self.name = [dict stringValueForKey:@"name" default:@""];
    self.teamId = [dict stringValueForKey:@"teamId" default:@""];
    self.scanCheckStatus = [dict stringValueForKey:@"scanCheckStatus" default:@""];
    self.id = [dict stringValueForKey:@"id" default:@""];
    self.credentialJSONStr = [PWSafeDictionaryVal(dict, @"credentialJSON") jsonStringEncoded];
    self.scanCheckStartTime = [dict stringValueForKey:@"scanCheckStartTime" default:@""];
    self.scanCheckInQueueTime = [dict stringValueForKey:@"scanCheckInQueueTime" default:@""];
    self.optionsJSONStr =  [PWSafeDictionaryVal(dict, @"optionsJSON")jsonStringEncoded];


}
@end
