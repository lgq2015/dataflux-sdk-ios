//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhugeIOBaseEventHelper.h"


@interface ZhugeIOLoginHelper : ZhugeIOBaseEventHelper


- (ZhugeIOLoginHelper *)eventGetVeryCode;

- (ZhugeIOLoginHelper *)eventInputGetVeryCode;

- (ZhugeIOLoginHelper *)eventSetPassword;

- (ZhugeIOLoginHelper *)eventJumpSetPwd;

- (ZhugeIOLoginHelper *)eventServiceProtocols;

- (ZhugeIOLoginHelper *)eventPrivacyPolicy;

- (ZhugeIOLoginHelper *)eventLoginSuccess;

- (ZhugeIOLoginHelper *)eventLoginFail;

- (ZhugeIOLoginHelper *)eventGuideStay;

- (ZhugeIOLoginHelper *)attrSceneLogin;

- (ZhugeIOLoginHelper *)attrSceneForget;

- (ZhugeIOLoginHelper *)attrSceneNewAccount;

- (ZhugeIOLoginHelper *)attrPhone:(NSString *)phone;

- (ZhugeIOLoginHelper *)attrEmail:(NSString *)email;

- (ZhugeIOLoginHelper *)attrResultPass;

- (ZhugeIOLoginHelper *)attrResultNoPass;

- (ZhugeIOLoginHelper *)attrLoginFail:(NSString *)reason;

- (ZhugeIOLoginHelper *)attrStayTime;
@end