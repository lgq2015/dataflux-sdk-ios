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

    if ([dict[@"provider"] isEqualToString:@"aliyun"]) {
        self.type = SourceTypeAli;
    }else if([dict[@"provider"] isEqualToString:@"qcloud"]){
        self.type = SourceTypeTencent;
    }else if([dict[@"provider"] isEqualToString:@"aws"]){
        self.type = SourceTypeAWS;
    }else if([dict[@"provider"] isEqualToString:@"ucloud"]){
        self.type = SourceTypeUcloud;
    }else if ([dict[@"provider"] isEqualToString:@"domain"]){
        self.type = SourceTypeDomainNameDiagnose;
    }else if ([dict[@"provider"] isEqualToString:@"carrier.corsair"]){
        self.type = SourceTypeSingleDiagnose;
    }else if([dict[@"provider"] isEqualToString:@"carrier.corsairmaster"]){
        self.type = SourceTypeClusterDiagnose;
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
