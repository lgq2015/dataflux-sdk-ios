//
//  IssueModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueModel.h"

@implementation IssueModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithLocalDict:dict];
    }
    return self;
}

- (void)setValueWithLocalDict:(NSDictionary *)dict {
    self.type = [dict stringValueForKey:@"type" default:@""];
    self.title = [dict stringValueForKey:@"title" default:@""];
    self.level = [dict stringValueForKey:@"level" default:@""];
    self.content = [dict stringValueForKey:@"content" default:@""];
    self.accountId = [dict stringValueForKey:@"originInfoAccountId_cache" default:@""];
    self.issueSourceId = [dict stringValueForKey:@"issueSourceId" default:@""];
    self.issueId = [dict stringValueForKey:@"id" default:@""];
    self.updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    self.createTime = [dict stringValueForKey:@"createTime" default:@""];
    self.localUpdateTime = self.createTime;
    self.status = [dict stringValueForKey:@"status" default:@""];
    self.actSeq = [dict longValueForKey:@"actSeq" default:0];
    self.seq = [dict longValueForKey:@"seq" default:0];
    self.origin = [dict stringValueForKey:@"origin" default:@""];
    self.ticketStatus = [dict stringValueForKey:@"ticketStatus" default:@""];
    self.subType = [dict stringValueForKey:@"subType" default:@""];
    NSArray *logs = [dict mutableArrayValueForKey:@"latestIssueLogs"];
    if (logs.count > 0) {
        NSString *logstr = [logs jsonStringEncoded];
        self.lastIssueLogSeq = [logs[0] longLongValueForKey:@"seq" default:0];
        self.latestIssueLogsStr = logstr;
    }
    NSDictionary *tags = PWSafeDictionaryVal(dict, @"tags");
    if (tags) {
        self.tagsStr = [tags jsonStringEncoded];
    }
    NSDictionary *rendered = PWSafeDictionaryVal(dict, @"renderedText");
    self.renderedTextStr = rendered ? [rendered jsonPrettyStringEncoded] : @"";

    NSDictionary *originInfoJSON = PWSafeDictionaryVal(dict, @"originInfoJSON");
    if (originInfoJSON) {

    }
    self.originInfoJSONStr = originInfoJSON ? [originInfoJSON jsonPrettyStringEncoded] : @"";
    self.isRead = NO;
    self.issueLogRead= self.lastIssueLogSeq <= 0;

}

- (void)setValueWithDict:(NSDictionary *)dict {
    [super setValueWithDict:dict];
    NSDictionary *content = dict[@"content"];
    [self setValueWithLocalDict:content];

}


- (void)checkInvalidIssue {

    if ([self.subType isEqualToString:@"buildInCheck"]
            && ![self.originInfoJSONStr isEqualToString:@""]) {
        NSDictionary *dict = [self.originInfoJSONStr jsonValueDecoded];
        NSString *checkKey = [dict stringValueForKey:@"checkKey" default:@""];
        if ([checkKey isEqualToString:@"invalidIssueSource"]) {
            self.title = @"情报源异常";
            self.isInvalidIssue = YES;
        }
    }

}

@end
