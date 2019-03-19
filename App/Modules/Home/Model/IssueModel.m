//
//  IssueModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueModel.h"

@implementation IssueModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithDict:dict];
    }
    return self;
}
- (void)setValueWithDict:(NSDictionary *)dict{
    self.type = [dict stringValueForKey:@"type" default:@""];
    self.title = [dict stringValueForKey:@"title" default:@""];
    self.level = [dict stringValueForKey:@"level" default:@""];
    self.content = [dict stringValueForKey:@"content" default:@""];
    self.accountId = [dict stringValueForKey:@"originInfoAccountId_cache" default:@""];
    self.issueId = [dict stringValueForKey:@"id" default:@""];
    self.updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    self.status = [dict stringValueForKey:@"status" default:@""];
    self.actSeq = [dict longValueForKey:@"actSeq" default:0];
    self.origin = [dict stringValueForKey:@"origin" default:@""];
    self.ticketStatus = [dict stringValueForKey:@"ticketStatus" default:@""];
    self.subType = [dict stringValueForKey:@"subType" default:@""];
    NSArray *logs = [dict mutableArrayValueForKey:@"latestIssueLogs"];
    if (logs.count>0) {
        NSString *logstr = [logs jsonStringEncoded];
        self.latestIssueLogsStr =logstr;
    }
   
    NSDictionary *rendered = dict[@"renderedText"];
    self.renderedTextStr = rendered?[rendered jsonPrettyStringEncoded]:@"";
    
    NSDictionary *originInfoJSON = dict[@"originInfoJSON"];
    if (originInfoJSON) {
        
    }
    self.originInfoJSONStr =originInfoJSON?[originInfoJSON jsonPrettyStringEncoded]:@"";
    self.isRead = NO;
}

@end
