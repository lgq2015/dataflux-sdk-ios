//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOMineHelper.h"


@implementation ZhugeIOMineHelper {

}
- (instancetype)init {
    self = [super init];
    if (self) {

        self.category = @"我的";

    }

    return self;
}


- (ZhugeIOMineHelper *)eventBottomTab {
    [self event:@"点击底部Tab"];
    return self;
}

- (ZhugeIOMineHelper *)eventLookInfo {
    [self event:@"查看基本信息"];
    return self;

}


- (ZhugeIOMineHelper *)eventChangeName {
    [self event:@"编辑姓名"];
    return self;

}

- (ZhugeIOMineHelper *)eventChangePhone {
    [self event:@"修改手机"];
    return self;

}


- (ZhugeIOMineHelper *)eventGetVerifyCode {
    [self event:@"获取验证码"];
    return self;

}

- (ZhugeIOMineHelper *)eventInputVerifyCode {
    [self event:@"输入验证码"];
    return self;

}

- (ZhugeIOMineHelper *)eventVerifyPwd {
    [self event:@"密码验证"];
    return self;

}


- (ZhugeIOMineHelper *)eventChangeEmail {
    [self event:@"修改邮箱"];
    return self;

}

- (ZhugeIOMineHelper *)eventChangeHeadImage {
    [self event:@"更改头像"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickMessage {
    [self event:@"进入我的消息"];
    return self;

}

- (ZhugeIOMineHelper *)eventLookMessage {
    [self event:@"查看消息"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickIssueResource {
    [self event:@"配置情报源"];
    return self;
}


- (ZhugeIOMineHelper *)eventClickCollection {
    [self event:@"进入我的收藏"];
    return self;

}

- (ZhugeIOMineHelper *)eventDeleteCollection {
    [self event:@"删除收藏文章"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickSuggest {
    [self event:@"意见与反馈"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickContactUs {
    [self event:@"联系我们"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickAboutProfWang {
    [self event:@"关于王教授"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickSetting {
    [self event:@"设置"];
    return self;

}


- (ZhugeIOMineHelper *)eventClickSecurityPrivacy {
    [self event:@"安全与隐私"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickChangePwd {
    [self event:@"修改密码"];
    return self;

}

- (ZhugeIOMineHelper *)eventClickSetPwd {
    [self event:@"设置密码"];
    return self;

}

- (ZhugeIOMineHelper *)eventSetNotifySwitch {
    [self event:@"设置接收消息通知"];
    return self;

}

- (ZhugeIOMineHelper *)eventClearCache {
    [self event:@"清除缓存"];
    return self;

}

- (ZhugeIOMineHelper *)eventLoginOut {
    [self event:@"退出登录"];
    return self;

}

- (ZhugeIOMineHelper *)attrTabName {
    self.data[@"目标位置"] = @"我的";
    return self;

}


- (ZhugeIOMineHelper *)verifyType:(NSString *)type {
    self.data[@"验证方式"] = type;
    return self;
}

- (ZhugeIOMineHelper *)attrVerifyWayMobile {
    [self verifyType:@"手机号"];
    return self;

}

- (ZhugeIOMineHelper *)attrVerifyWayPwd {
    [self verifyType:@"密码"];
    return self;

}

- (ZhugeIOMineHelper *)attrSceneVerify {
    [self scene:@"验证身份"];
    return self;

}


- (ZhugeIOMineHelper *)attrSceneChangeMobile {
    [self scene:@"修改手机号"];
    return self;

}

- (ZhugeIOMineHelper *)attrSceneChangeEmail {
    [self scene:@"修改邮箱"];
    return self;

}

- (ZhugeIOMineHelper *)attrSceneChangePwd {
    [self scene:@"修改密码"];
    return self;

}

- (ZhugeIOMineHelper *)attrMessageTitle:(NSString *)title {
    self.data[@"消息标题"] = title;
    return self;
}


- (ZhugeIOMineHelper *)attrResultReceive {
    [self result:@"接收"];
    return self;

}

- (ZhugeIOMineHelper *)attrResultNoReceive {
    [self result:@"不接收"];
    return self;

}

- (ZhugeIOMineHelper *)attrResultLogout {
    [self result:@"退出"];
    return self;

}

- (ZhugeIOMineHelper *)attrResultCancel {
    [self result:@"取消"];
    return self;

}


@end