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


- (ZhugeIOBaseEventHelper *)eventBottomTab {
    return [self event:@"点击底部Tab"];
}

- (ZhugeIOBaseEventHelper *)eventLookInfo {
    return [self event:@"查看基本信息"];
}


- (ZhugeIOBaseEventHelper *)eventChangeName {
    return [self event:@"编辑姓名"];
}

- (ZhugeIOBaseEventHelper *)eventChangePhone {
    return [self event:@"修改手机"];
}


- (ZhugeIOBaseEventHelper *)eventGetVerifyCode {
    return [self event:@"获取验证码"];
}

- (ZhugeIOBaseEventHelper *)eventInputVerifyCode {
    return [self event:@"输入验证码"];
}

- (ZhugeIOBaseEventHelper *)eventVerifyPwd {
    return [self event:@"密码验证"];
}


- (ZhugeIOBaseEventHelper *)eventChangeEmail {
    return [self event:@"修改邮箱"];
}

- (ZhugeIOBaseEventHelper *)eventChangeHeadImage {
    return [self event:@"更改头像"];
}

- (ZhugeIOBaseEventHelper *)eventClickMessage {
    return [self event:@"进入我的消息"];
}

- (ZhugeIOBaseEventHelper *)eventLookMessage {
    return [self event:@"查看消息"];
}

- (ZhugeIOBaseEventHelper *)eventClickIssueResource {
    return [self event:@"配置情报源"];
}


- (ZhugeIOBaseEventHelper *)eventClickCollection {
    return [self event:@"进入我的收藏"];
}

- (ZhugeIOBaseEventHelper *)eventDeleteCollection {
    return [self event:@"删除收藏文章"];
}

- (ZhugeIOBaseEventHelper *)eventClickSuggest {
    return [self event:@"意见与反馈"];
}

- (ZhugeIOBaseEventHelper *)eventClickContactUs {
    return [self event:@"联系我们"];
}

- (ZhugeIOBaseEventHelper *)eventClickAboutProfWang {
    return [self event:@"关于王教授"];
}

- (ZhugeIOBaseEventHelper *)eventClickSetting {
    return [self event:@"设置"];
}


- (ZhugeIOBaseEventHelper *)eventClickSecurityPrivacy {
    return [self event:@"安全与隐私"];
}

- (ZhugeIOBaseEventHelper *)eventClickChangePwd {
    return [self event:@"修改密码"];
}

- (ZhugeIOBaseEventHelper *)eventClickSetPwd {
    return [self event:@"设置密码"];
}

- (ZhugeIOBaseEventHelper *)eventSetNotifySwitch {
    return [self event:@"设置接收消息通知"];
}

- (ZhugeIOBaseEventHelper *)eventClearCache {
    return [self event:@"清除缓存"];
}

- (ZhugeIOBaseEventHelper *)eventLoginOut {
    return [self event:@"退出登录"];
}

- (ZhugeIOBaseEventHelper *)attrTabName {
    self.data[@"目标位置"] = @"我的";
    return self;
}


- (ZhugeIOBaseEventHelper *)verifyType:(NSString *)type {
    self.data[@"验证方式"] = type;
    return self;
}

- (ZhugeIOBaseEventHelper *)attrVerifyWayMobile {
    return [self verifyType:@"手机号"];
}

- (ZhugeIOBaseEventHelper *)attrVerifyWayPwd {
    return [self verifyType:@"密码"];
}

- (ZhugeIOBaseEventHelper *)attrSceneVerify {
    return [self scence:@"验证身份"];
}


- (ZhugeIOBaseEventHelper *)attrSceneChangeMobile {
    return [self scence:@"修改手机号"];
}

- (ZhugeIOBaseEventHelper *)attrSceneChangeEmail {
    return [self scence:@"修改邮箱"];
}

- (ZhugeIOBaseEventHelper *)attrSceneChangePwd {
    return [self scence:@"修改密码"];
}

- (ZhugeIOBaseEventHelper *)attrMessageTitle:(NSString *)title {
    self.data[@"消息标题"] =title;
    return self;
}


-(ZhugeIOBaseEventHelper *)result:(NSString *)result{
    self.data[@"结果"] =result;
    return self;
}

-(ZhugeIOBaseEventHelper *)attrResultReceive{
    return [self result:@"接收"];
}

-(ZhugeIOBaseEventHelper *)attrResultNoReceive{
    return [self result:@"不接收"];
}

-(ZhugeIOBaseEventHelper *)attrResultLogout{
    return [self result:@"退出"];
}

-(ZhugeIOBaseEventHelper *)attrResultCancel{
    return [self result:@"取消"];
}


@end