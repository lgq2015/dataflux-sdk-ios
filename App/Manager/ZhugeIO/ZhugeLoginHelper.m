//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeLoginHelper.h"


@implementation ZhugeLoginHelper {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"登录";
    }
    return self;
}

-(ZhugeIOBaseEventHelper *) eventGetVeryCode{
    return [self event:@"获取验证码"];
}

-(ZhugeIOBaseEventHelper *) eventInputGetVeryCode{
    return [self event:@"输入验证码"];
}


-(ZhugeIOBaseEventHelper *) eventSetPassword{
    return [self event:@"设置密码"];
}

-(ZhugeIOBaseEventHelper *) eventJumpSetPwd{
    return [self event:@"跳过设置密码"];
}

-(ZhugeIOBaseEventHelper *) eventServiceProtocols{
    return [self event:@"查看服务协议"];
}

-(ZhugeIOBaseEventHelper *) eventPrivacyPolicy{
    return [self event:@"查看隐私权政策"];
}

-(ZhugeIOBaseEventHelper *) eventLoginSuccess{
    return [self event:@"登录成功"];
}


-(ZhugeIOBaseEventHelper *) eventLoginFail{
    return [self event:@"登录失败"];
}


-(ZhugeIOBaseEventHelper *) eventGuideStay{
    return [self event:@"引导页停留"];
}

-(ZhugeIOBaseEventHelper *) attrSceneLogin{
    return [self scence:@"忘记密码"];
}


-(ZhugeIOBaseEventHelper *) attrSceneNewAccount{
    return [self scence:@"新用户"];
}


- (ZhugeIOBaseEventHelper *)attrPhone:(NSString *)phone {
    return self.data[@"手机号"] = phone;
}


- (ZhugeIOBaseEventHelper *)attrEmail:(NSString *)email {
    return self.data[@"邮箱"] = email;
}

- (ZhugeIOBaseEventHelper *)attrResultPass{
    return self.data[@"结果"] = @"通过";
}

- (ZhugeIOBaseEventHelper *)attrResultFail{
    return self.data[@"结果"] = @"未通过";
}

- (ZhugeIOBaseEventHelper *)attrLoginFail:(NSString *)reason{
    return self.data[@"失败原因"] = reason;
}

- (ZhugeIOBaseEventHelper *)attrStayTime{
    return self.data[@"时长"] = @"秒";
}

@end