//
//  IssueSourceViewModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceViewModel.h"

@implementation IssueSourceViewModel
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithJson:dictionary];
    }
    return self;
}
- (void)setValueWithJson:(NSDictionary *)dict{
    self.name = dict[@"name"];
    self.issueSourceId = dict[@"id"];
    self.provider = dict[@"provider"];

    BOOL isVirtual = [dict boolValueForKey:@"isVirtual" default:NO];

    if(isVirtual){
        self.state = SourceStateDetected;
    } else{
        if ([dict[@"scanCheckStatus"] isEqualToString:@"neverStarted"]) {
            self.state = SourceStateNotDetected;
        }else if([dict[@"scanCheckStatus"] isEqualToString:@"invalidIssueSource"]){
            self.state = SourceStateAbnormal;
        }else{
            self.state = SourceStateDetected;
        }
    }
    NSString *provider = [dict stringValueForKey:@"provider" default:@""];
    if ([provider isEqualToString:@"aliyun"]) {
        self.type = SourceTypeAli;
    }else if([provider isEqualToString:@"qcloud"]){
        self.type = SourceTypeTencent;
    }else if([provider isEqualToString:@"aws"]){
        self.type = SourceTypeAWS;
    }else if([provider isEqualToString:@"ucloud"]){
        self.type = SourceTypeUcloud;
    }else if ([provider isEqualToString:@"domain"]){
        self.type = SourceTypeDomainNameDiagnose;
    }else if ([provider isEqualToString:@"carrier.corsair"]){
        self.type = SourceTypeSingleDiagnose;
    }else if([provider isEqualToString:@"carrier.corsairmaster"]){
        self.type = SourceTypeClusterDiagnose;
    }else if([provider isEqualToString:@"carrier.alert"]){
        self.type = SourceTypeMessageDock;
    }else if([provider isEqualToString:@"aliyun.cainiao"]){
        self.type = SourceTypeAliCainiao;
    }else if([provider isEqualToString:@"aliyun.finance"]){
        self.type = SourceTypeAliFinance;
    }
    if (self.type == SourceTypeClusterDiagnose || self.type == SourceTypeSingleDiagnose) {
       
        if ([dict[@"optionsJSONStr"] isKindOfClass:NSString.class]) {
                NSString *optionsJSON =dict[@"optionsJSONStr"];
                NSDictionary *dict2 = [optionsJSON jsonValueDecoded];
                self.clusterID = [dict2 stringValueForKey:@"uploaderUid" default:@""];
        }else{
                self.clusterID = dict[@"optionsJSON"][@"uploaderUid"];
        }
    }
    
     if(dict[@"credentialJSONStr"]) {
         if ([dict[@"credentialJSONStr"] isKindOfClass:NSString.class]) {
             NSString *credentialJSON =dict[@"credentialJSONStr"];
             NSDictionary *dict2 = [credentialJSON jsonValueDecoded];
             self.akId = dict2[@"akId"];
         }else{
        self.akId = dict[@"credentialJSONStr"][@"akId"];
         }
    }
    self.updateTime = dict[@"updateTime"];
    
}
@end
