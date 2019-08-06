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
    self.endTime = [dict stringValueForKey:@"endTime" default:@""];
    self.localUpdateTime = self.createTime;
    self.status = [dict stringValueForKey:@"status" default:@""];
    self.actSeq = [dict longValueForKey:@"actSeq" default:0];
    self.seq = [dict longValueForKey:@"seq" default:0];
    self.origin = [dict stringValueForKey:@"origin" default:@""];
    if ([dict stringValueForKey:@"originExecMode" default:@""].length>0) {
        self.originExecMode = [dict stringValueForKey:@"originExecMode" default:@""];
    }
    self.ticketStatus = [dict stringValueForKey:@"ticketStatus" default:@""];
    self.subType = [dict stringValueForKey:@"subType" default:@""];
    self.needAttention = [dict boolValueForKey:@"needAttention" default:YES];
    NSArray *logs = [dict mutableArrayValueForKey:@"latestIssueLogs"];
    if (logs.count > 0) {
        NSString *logstr = [logs jsonStringEncoded];
//        self.lastIssueLogSeq = [logs[0] longLongValueForKey:@"seq" default:0];
        self.latestIssueLogsStr = logstr;
    }
    
    self.lastIssueLogSeq = [dict longLongValueForKey:@"lastIssueLogSeq" default:0];
    NSDictionary *tags = PWSafeDictionaryVal(dict, @"tags");
    if (tags) {
        self.tagsStr = [tags jsonStringEncoded];
    }
    NSDictionary *readAtInfo = PWSafeDictionaryVal(dict, @"readAtInfo");
    if (readAtInfo) {
        self.readAtInfoStr = [readAtInfo jsonStringEncoded];
    }
    NSArray *watchInfoJSON = PWSafeArrayVal(dict, @"watchInfoJSON");
    if (watchInfoJSON) {
        self.watchInfoJSONStr = [watchInfoJSON jsonStringEncoded];
    }
    NSDictionary *rendered = PWSafeDictionaryVal(dict, @"renderedText");
    self.renderedTextStr = rendered ? [rendered jsonPrettyStringEncoded] : @"";
    NSDictionary *markTookOverInfo = PWSafeDictionaryVal(dict, @"markTookOverAccountInfo");
    NSDictionary *markEndInfoInfo = PWSafeDictionaryVal(dict, @"markEndAccountInfo");
    self.markTookOverInfoJSONStr = markTookOverInfo?[markTookOverInfo jsonPrettyStringEncoded]:@"";
    self.markEndAccountInfoStr =markEndInfoInfo?[markEndInfoInfo jsonStringEncoded]:@"";
    self.markStatus = [dict stringValueForKey:@"markStatus" default:@""];
    NSDictionary *originInfoJSON = PWSafeDictionaryVal(dict, @"originInfoJSON");
    if (originInfoJSON) {
        self.originInfoJSONStr = [originInfoJSON jsonPrettyStringEncoded];
        NSDictionary *alertInfo = PWSafeDictionaryVal(originInfoJSON, @"alertInfo");
        if ([alertInfo stringValueForKey:@"origin" default:@""].length>0) {
            self.alertHubTitle =[alertInfo stringValueForKey:@"origin" default:@""];
        }
    }
    
    self.isRead = NO;
    self.issueLogRead= self.lastIssueLogSeq <= 0;
    self.cellHeight = 0;
    self.isEnded = [dict boolValueForKey:@"isEnded" default:NO];
    NSDictionary *statusChangeAccountInfo = PWSafeDictionaryVal(dict, @"statusChangeAccountInfo");
    if (statusChangeAccountInfo) {
        self.statusChangeAccountInfoStr = [statusChangeAccountInfo jsonStringEncoded];
    }
    if ([dict containsObjectForKey:@"assignAccountInfo"]) {
        NSDictionary *assignAccountInfo = PWSafeDictionaryVal(dict, @"assignAccountInfo");
        if (assignAccountInfo) {
            self.assignAccountInfoStr = [assignAccountInfo jsonStringEncoded];
        }
    }
    if ([dict containsObjectForKey:@"assignedToAccountInfo"]) {
        NSDictionary *assignedToAccountInfo = PWSafeDictionaryVal(dict, @"assignedToAccountInfo");
        if (assignedToAccountInfo) {
            self.assignedToAccountInfoStr = [assignedToAccountInfo jsonStringEncoded];
        }
    }else{
        self.assignedToAccountInfoStr = @"";
    }
    
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
            self.title = NSLocalizedString(@"local.IssueSourceAbnormal", @"");
            self.isInvalidIssue = YES;
        }
    }

}

@end
