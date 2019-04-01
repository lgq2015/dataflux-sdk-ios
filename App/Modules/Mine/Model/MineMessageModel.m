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
}


-(void)setValueWithDict:(NSDictionary *)dict{
    [super setValueWithDict:dict];
    NSDictionary *content = dict[@"content"];
    [self setLocalValueWithDict:content];

}


@end
