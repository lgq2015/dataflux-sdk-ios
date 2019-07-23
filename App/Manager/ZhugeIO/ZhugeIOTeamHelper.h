//
// Created by Brandon on 2019-06-03.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhugeIOBaseEventHelper.h"


@interface ZhugeIOTeamHelper : ZhugeIOBaseEventHelper
- (ZhugeIOTeamHelper *)eventBottomTab;

- (ZhugeIOTeamHelper *)eventCreateTeamStay;

- (ZhugeIOTeamHelper *)eventClickInvite;

- (ZhugeIOTeamHelper *)eventConfigIssue;

- (ZhugeIOTeamHelper *)eventClickServiceLog;

- (ZhugeIOTeamHelper *)eventClickTeamManager;

- (ZhugeIOTeamHelper *)eventSwitchTeam;

- (ZhugeIOTeamHelper *)eventLookMember;

- (ZhugeIOTeamHelper *)eventCallMember;

- (ZhugeIOTeamHelper *)eventJoinScan;

- (ZhugeIOTeamHelper *)eventInviteEmail;

- (ZhugeIOTeamHelper *)eventInvitePhone;

- (ZhugeIOTeamHelper *)eventSaveQRCode;

- (ZhugeIOTeamHelper *)eventSureEmailInvite;

- (ZhugeIOTeamHelper *)eventSurePhoneInvite;

- (ZhugeIOTeamHelper *)eventLookServiceLog;

- (ZhugeIOTeamHelper *)eventTransferManager;

- (ZhugeIOTeamHelper *)eventTransferManagerSuccess;

- (ZhugeIOTeamHelper *)eventCancelTeam;

- (ZhugeIOTeamHelper *)eventSignOutTeam;

- (ZhugeIOTeamHelper *)attrTabName;

- (ZhugeIOTeamHelper *)attrStayTime;

- (ZhugeIOTeamHelper *)attrFrom;

- (ZhugeIOTeamHelper *)attrResultSuccess;

- (ZhugeIOTeamHelper *)attrResultCancel;
@end