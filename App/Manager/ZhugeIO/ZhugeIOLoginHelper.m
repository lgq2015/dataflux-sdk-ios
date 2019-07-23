//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOLoginHelper.h"


@implementation ZhugeIOLoginHelper {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"登录";
    }
    return self;
}

- (ZhugeIOLoginHelper *)eventGetVeryCode {
    [self event:@"获取验证码"];
    return self;
}

- (ZhugeIOLoginHelper *)eventInputGetVeryCode {
    [self event:@"输入验证码"];
    return self;

}


- (ZhugeIOLoginHelper *)eventSetPassword {
    [self event:@"设置密码"];
    return self;

}

- (ZhugeIOLoginHelper *)eventJumpSetPwd {
    [self event:@"跳过设置密码"];
    return self;

}

- (ZhugeIOLoginHelper *)eventServiceProtocols {
    [self event:@"查看服务协议"];
    return self;

}

- (ZhugeIOLoginHelper *)eventPrivacyPolicy {
    [self event:@"查看隐私权政策"];
    return self;

}

- (ZhugeIOLoginHelper *)eventLoginSuccess {
    [self event:@"登录成功"];
    return self;

}


- (ZhugeIOLoginHelper *)eventLoginFail {
    [self event:@"登录失败"];
    return self;

}


- (ZhugeIOLoginHelper *)eventGuideStay {
    [self event:@"引导页停留"];
    return self;

}

- (ZhugeIOLoginHelper *)attrSceneLogin {
    [self scene:@"登录"];
    return self;

}

- (ZhugeIOLoginHelper *)attrSceneForget {
    [self scene:@"忘记密码"];
    return self;

}



- (ZhugeIOLoginHelper *)attrSceneNewAccount {
    [self scene:@"新用户"];
    return self;

}


- (ZhugeIOLoginHelper *)attrPhone:(NSString *)phone {
    self.data[@"手机号"] = phone;
    return self;

}


- (ZhugeIOLoginHelper *)attrEmail:(NSString *)email {
    self.data[@"邮箱"] = email;
    return self;

}

- (ZhugeIOLoginHelper *)attrResultPass {
    self.data[@"结果"] = @"通过";
    return self;

}

- (ZhugeIOLoginHelper *)attrResultNoPass {
    self.data[@"结果"] = @"未通过";
    return self;

}

- (ZhugeIOLoginHelper *)attrLoginFail:(NSString *)reason {
    self.data[@"失败原因"] = reason;
    return self;

}

- (ZhugeIOLoginHelper *)attrStayTime {
    self.data[@"时长"] = @"秒";
    return self;

}

@end