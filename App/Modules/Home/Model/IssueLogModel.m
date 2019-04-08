//
// Created by Brandon on 2019-03-24.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "IssueLogModel.h"


@implementation IssueLogModel {

}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict {
    self.type = [dict stringValueForKey:@"type" default:@""];
    self.content = [dict stringValueForKey:@"content" default:@""];
    self.issueId = [dict stringValueForKey:@"issueId" default:@""];
    self.updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    self.origin = [dict stringValueForKey:@"origin" default:@""];
    self.subType = [dict stringValueForKey:@"subType" default:@""];
    self.id = [dict stringValueForKey:@"id" default:@""];
    self.seq = [dict longLongValueForKey:@"seq" default:0];
    self.createTime =[dict stringValueForKey:@"createTime" default:@""];
    NSDictionary *originInfoJSON = PWSafeDictionaryVal(dict,@"originInfoJSON");
    NSDictionary *metaJson = PWSafeDictionaryVal(dict,@"metaJson");
    NSDictionary *externalDownloadURL = PWSafeDictionaryVal(dict,@"externalDownloadURL");
    NSDictionary *accountInfo = PWSafeDictionaryVal(dict,@"account_info");

    self.originInfoJSONStr = originInfoJSON ? [originInfoJSON jsonPrettyStringEncoded] : @"";
    self.metaJsonStr = metaJson ? [metaJson jsonPrettyStringEncoded] : @"";
    self.externalDownloadURLStr = externalDownloadURL ? [externalDownloadURL jsonPrettyStringEncoded] : @"";
    self.accountInfoStr = accountInfo ? [accountInfo jsonPrettyStringEncoded] : @"";

}

@end
