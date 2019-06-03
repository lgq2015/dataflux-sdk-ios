//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhugeIOBaseEventHelper.h"


@interface ZhugeIOMineHelper : ZhugeIOBaseEventHelper


- (ZhugeIOMineHelper *)eventBottomTab;

- (ZhugeIOMineHelper *)eventLookInfo;

- (ZhugeIOMineHelper *)eventChangeName;

- (ZhugeIOMineHelper *)eventChangePhone;

- (ZhugeIOMineHelper *)eventGetVerifyCode;

- (ZhugeIOMineHelper *)eventInputVerifyCode;

- (ZhugeIOMineHelper *)eventVerifyPwd;

- (ZhugeIOMineHelper *)eventChangeEmail;

- (ZhugeIOMineHelper *)eventChangeHeadImage;

- (ZhugeIOMineHelper *)eventClickMessage;

- (ZhugeIOMineHelper *)eventLookMessage;

- (ZhugeIOMineHelper *)eventClickIssueResource;

- (ZhugeIOMineHelper *)eventClickCollection;

- (ZhugeIOMineHelper *)eventDeleteCollection;

- (ZhugeIOMineHelper *)eventClickSuggest;

- (ZhugeIOMineHelper *)eventClickContactUs;

- (ZhugeIOMineHelper *)eventClickAboutProfWang;

- (ZhugeIOMineHelper *)eventClickSetting;

- (ZhugeIOMineHelper *)eventClickSecurityPrivacy;

- (ZhugeIOMineHelper *)eventClickChangePwd;

- (ZhugeIOMineHelper *)eventClickSetPwd;

- (ZhugeIOMineHelper *)eventSetNotifySwitch;

- (ZhugeIOMineHelper *)eventClearCache;

- (ZhugeIOMineHelper *)eventLoginOut;

- (ZhugeIOMineHelper *)attrTabName;

- (ZhugeIOMineHelper *)verifyType:(NSString *)type;

- (ZhugeIOMineHelper *)attrVerifyWayMobile;

- (ZhugeIOMineHelper *)attrVerifyWayPwd;

- (ZhugeIOMineHelper *)attrSceneVerify;

- (ZhugeIOMineHelper *)attrSceneChangeMobile;

- (ZhugeIOMineHelper *)attrSceneChangeEmail;

- (ZhugeIOMineHelper *)attrSceneChangePwd;

- (ZhugeIOMineHelper *)attrMessageTitle:(NSString *)title;

- (ZhugeIOMineHelper *)attrResultReceive;

- (ZhugeIOMineHelper *)attrResultNoReceive;

- (ZhugeIOMineHelper *)attrResultLogout;

- (ZhugeIOMineHelper *)attrResultCancel;
@end