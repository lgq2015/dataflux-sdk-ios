//
//  MineMessageModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineMessageModel.h"

@implementation MineMessageModel


- (void)setLocalValueWithDict:(NSDictionary *)dict {

    self.accountId = [dict stringValueForKey:@"accountId" default:@""];
    self.content = [dict stringValueForKey:@"content" default:@""];
    self.createTime = [dict stringValueForKey:@"createTime" default:@""];
    self.createTime = [dict stringValueForKey:@"createTime" default:@""];
    self.createAccountId = [dict stringValueForKey:@"createAccountId" default:@""];
    self.isDeleted = [dict boolValueForKey:@"isDeleted" default:NO];
    self.isReaded = [dict boolValueForKey:@"isReaded" default:NO];
    self.messageType = [dict stringValueForKey:@"messageType" default:@""];
    self.title = [dict stringValueForKey:@"title" default:@""];
    self.messageID = [dict stringValueForKey:@"id" default:@""];
    self.updateAccountId = [dict stringValueForKey:@"updateAccountId" default:@""];
    self.updateTime = [dict stringValueForKey:@"updateTime" default:@""];
    self.uri = [dict stringValueForKey:@"uri" default:@""];
    if ([self.messageType isEqualToString:@"team"]) {
        self.colorStr = @"#2EB5F3";
        self.typeStr = NSLocalizedString(@"local.team", @"");
    }else if([self.messageType isEqualToString:@"account"]){
        self.colorStr = @"#FFCF27";
        self.typeStr = NSLocalizedString(@"local.account", @"");
    }else if([self.messageType isEqualToString:@"issue_source"]){
        self.colorStr = @"#3B85F8";
        self.typeStr = NSLocalizedString(@"local.issueSource", @"");
    }else if([self.messageType isEqualToString:@"service_package"]){
        self.colorStr = @"#3B85F8";
        self.typeStr = NSLocalizedString(@"local.service_package", @"");
    }else if([self.messageType isEqualToString:@"service"]){
        self.colorStr = @"#FFA46B";
        self.typeStr = NSLocalizedString(@"local.service", @"");
    }else if([self.messageType isEqualToString:@"system"]){
        self.colorStr = @"#49DADD";
        self.typeStr = NSLocalizedString(@"local.system", @"");
    }else if([self.messageType isEqualToString:@"member"]){
        self.colorStr = @"#26DBAC";
        self.typeStr = NSLocalizedString(@"local.member", @"");
    }else if([self.messageType isEqualToString:@"role"]){
        self.colorStr = @"#936AF2";
        self.typeStr = NSLocalizedString(@"local.role", @"");
    }
}


-(void)setValueWithDict:(NSDictionary *)dict{
    [super setValueWithDict:dict];
    NSDictionary *content = dict[@"content"];
    [self setLocalValueWithDict:content];

}


@end
