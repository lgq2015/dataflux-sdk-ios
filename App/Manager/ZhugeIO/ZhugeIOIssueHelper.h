//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhugeIOBaseEventHelper.h"


@interface ZhugeIOIssueHelper : ZhugeIOBaseEventHelper

- (ZhugeIOIssueHelper *)eventClickBottomTab;

- (ZhugeIOIssueHelper *)eventSwitchTeam;

- (ZhugeIOIssueHelper *)attrTabName;

- (ZhugeIOIssueHelper *)attrTime;

- (ZhugeIOIssueHelper *)attrIssueTitle:(NSString *)name;

- (ZhugeIOIssueHelper *)attrIssueType:(NSString *)type;

- (ZhugeIOIssueHelper *)attrIssueLevel:(NSString *)level;

- (ZhugeIOIssueHelper *)attrAddEnclosure:(BOOL)isAttach;

- (ZhugeIOIssueHelper *)attrContentWords;

- (ZhugeIOIssueHelper *)attrContentImage;

- (ZhugeIOIssueHelper *)attrMemberOrdinary;

- (ZhugeIOIssueHelper *)attrMemberExpert;

- (ZhugeIOIssueHelper *)attrCallPhone:(BOOL)call;

- (ZhugeIOIssueHelper *)eventClickScan;

- (ZhugeIOIssueHelper *)eventClickIssueClass;

- (ZhugeIOIssueHelper *)eventLookIssue;

- (ZhugeIOIssueHelper *)eventIssueLookTime;

- (ZhugeIOIssueHelper *)eventCreateProblem;

- (ZhugeIOIssueHelper *)eventLookSuggestAtticle;

- (ZhugeIOIssueHelper *)eventJoinDiscuss;

- (ZhugeIOIssueHelper *)eventDiscussAreaTime;

- (ZhugeIOIssueHelper *)eventDiscussAreaSay;

- (ZhugeIOIssueHelper *)eventClickLookDiscussMember;

- (ZhugeIOIssueHelper *)eventCallExpert;

- (ZhugeIOIssueHelper *)eventCloseProblem;

@end