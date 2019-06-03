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
    return [self event:@"点击底部Tab"];
}

- (ZhugeIOMineHelper *)eventLookInfo {
    return [self event:@"查看基本信息"];
}


- (ZhugeIOMineHelper *)eventChangeName {
    return [self event:@"编辑姓名"];
}

- (ZhugeIOMineHelper *)eventChangePhone {
    return [self event:@"修改手机"];
}


- (ZhugeIOMineHelper *)eventGetVerifyCode {
    return [self event:@"获取验证码"];
}

- (ZhugeIOMineHelper *)eventInputVerifyCode {
    return [self event:@"输入验证码"];
}

- (ZhugeIOMineHelper *)eventVerifyPwd {
    return [self event:@"密码验证"];
}


- (ZhugeIOMineHelper *)eventChangeEmail {
    return [self event:@"修改邮箱"];
}

- (ZhugeIOMineHelper *)eventChangeHeadImage {
    return [self event:@"更改头像"];
}

- (ZhugeIOMineHelper *)eventClickMessage {
    return [self event:@"进入我的消息"];
}

- (ZhugeIOMineHelper *)eventLookMessage {
    return [self event:@"查看消息"];
}

- (ZhugeIOMineHelper *)eventClickIssueResource {
    return [self event:@"配置情报源"];
}


- (ZhugeIOMineHelper *)eventClickCollection {
    return [self event:@"进入我的收藏"];
}

- (ZhugeIOMineHelper *)eventDeleteCollection {
    return [self event:@"删除收藏文章"];
}

- (ZhugeIOMineHelper *)eventClickSuggest {
    return [self event:@"意见与反馈"];
}

- (ZhugeIOMineHelper *)eventClickContactUs {
    return [self event:@"联系我们"];
}

- (ZhugeIOMineHelper *)eventClickAboutProfWang {
    return [self event:@"关于王教授"];
}

- (ZhugeIOMineHelper *)eventClickSetting {
    return [self event:@"设置"];
}


- (ZhugeIOMineHelper *)eventClickSecurityPrivacy {
    return [self event:@"安全与隐私"];
}

- (ZhugeIOMineHelper *)eventClickChangePwd {
    return [self event:@"修改密码"];
}

- (ZhugeIOMineHelper *)eventClickSetPwd {
    return [self event:@"设置密码"];
}

- (ZhugeIOMineHelper *)eventSetNotifySwitch {
    return [self event:@"设置接收消息通知"];
}

- (ZhugeIOMineHelper *)eventClearCache {
    return [self event:@"清除缓存"];
}

- (ZhugeIOMineHelper *)eventLoginOut {
    return [self event:@"退出登录"];
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
    return [self verifyType:@"手机号"];
}

- (ZhugeIOMineHelper *)attrVerifyWayPwd {
    return [self verifyType:@"密码"];
}

- (ZhugeIOMineHelper *)attrSceneVerify {
    return [self scene:@"验证身份"];
}


- (ZhugeIOMineHelper *)attrSceneChangeMobile {
    return [self scene:@"修改手机号"];
}

- (ZhugeIOMineHelper *)attrSceneChangeEmail {
    return [self scene:@"修改邮箱"];
}

- (ZhugeIOMineHelper *)attrSceneChangePwd {
    return [self scene:@"修改密码"];
}

- (ZhugeIOMineHelper *)attrMessageTitle:(NSString *)title {
    self.data[@"消息标题"] =title;
    return self;
}



-(ZhugeIOMineHelper *)attrResultReceive{
    return [self result:@"接收"];
}

-(ZhugeIOMineHelper *)attrResultNoReceive{
    return [self result:@"不接收"];
}

-(ZhugeIOMineHelper *)attrResultLogout{
    return [self result:@"退出"];
}

-(ZhugeIOMineHelper *)attrResultCancel{
    return [self result:@"取消"];
}


@end