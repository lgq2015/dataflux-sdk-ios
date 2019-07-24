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
        [self setValueWithLocalDict:dict];
    }
    return self;
}

- (void)setValueWithLocalDict:(NSDictionary *)dict {
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
    NSDictionary *metaJson = PWSafeDictionaryVal(dict,@"metaJSON");
    NSDictionary *externalDownloadURL = PWSafeDictionaryVal(dict,@"externalDownloadURL");
    NSDictionary *accountInfo = PWSafeDictionaryVal(dict,@"accountInfo");
    NSDictionary *atStatus = PWSafeDictionaryVal(dict, @"atStatus");
    NSDictionary *atInfoJSON = PWSafeDictionaryVal(dict, @"atInfoJSON");
    NSDictionary *issueSnapshotJSON_cache = PWSafeDictionaryVal(dict, @"issueSnapshotJSON_cache");
    self.issueSnapshotJSON_cacheStr = issueSnapshotJSON_cache?[issueSnapshotJSON_cache jsonPrettyStringEncoded] : @"";
    self.originInfoJSONStr = originInfoJSON ? [originInfoJSON jsonPrettyStringEncoded] : @"";
    self.metaJsonStr = metaJson ? [metaJson jsonPrettyStringEncoded] : @"";
    self.externalDownloadURLStr = externalDownloadURL ? [externalDownloadURL jsonPrettyStringEncoded] : @"";
    self.accountInfoStr = accountInfo ? [accountInfo jsonPrettyStringEncoded] : @"";
    self.atStatusStr = atStatus?[atStatus jsonStringEncoded]:@"";
    self.atInfoJSONStr = atInfoJSON ?[atInfoJSON jsonStringEncoded]:@"";
    self.atInfoJSON = atInfoJSON;
    self.childIssueStr = PWSafeDictionaryVal(dict, @"childIssue")?[PWSafeDictionaryVal(dict, @"childIssue") jsonPrettyStringEncoded]:@"";
    if ([dict containsObjectForKey:@"assignedToAccountInfo"]) {
        NSDictionary *assignedToAccountInfo = PWSafeDictionaryVal(dict, @"assignedToAccountInfo");
        self.assignedToAccountInfoStr = assignedToAccountInfo?[assignedToAccountInfo jsonStringEncoded]:@"";
    }
}

-(NSString *)createLastIssueLogJsonString{

    NSMutableDictionary *dic = [@{
            @"type":self.type,
            @"content":self.content,
            @"issueId":self.issueId,
            @"updateTime":self.updateTime,
            @"origin":self.origin,
            @"subType":self.subType,
            @"id":self.id,
            @"seq":@(self.seq),
            @"createTime":self.createTime,
    }mutableCopy];

    NSDictionary *originInfoJSON = [self.originInfoJSONStr jsonValueDecoded];
    NSDictionary *metaJson = [self.metaJsonStr jsonValueDecoded];
    NSDictionary *externalDownloadURL = [self.externalDownloadURLStr jsonValueDecoded];
    NSDictionary *accountInfo = [self.accountInfoStr jsonValueDecoded];
    NSDictionary *atInfoJSON  = [self.atInfoJSONStr jsonValueDecoded];
    if(originInfoJSON){
        dic[@"originInfoJSON"] =originInfoJSON;
    }
    if(metaJson){
        dic[@"metaJSON"] =metaJson;
    }
    if(externalDownloadURL){
        dic[@"externalDownloadURL"] =externalDownloadURL;
    }
    if(accountInfo){
        dic[@"accountInfo"] =accountInfo;
    }
    if(atInfoJSON){
        dic[@"atInfoJSON"] = atInfoJSON;
    }
    return [@[dic] jsonStringEncoded];
}

- (instancetype)initSendIssueLogDefaultLogModel{
    if (self = [super init]) {
        [self createSendIssueLogDefaultLogModel];
    }
    return self;
}
- (void)createSendIssueLogDefaultLogModel{
    self.origin = @"me";
    self.updateTime = [[NSDate date] getNowUTCTimeStr];
    self.sendError = NO;
}
@end
